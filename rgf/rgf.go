// Copyright 2019 Jakub Vanek <linuxtardis@gmail.com>
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package rgf provides functionality for reading and writing EV3 RGF files.
package rgf

import (
	"fmt"
	"image"
	"image/color"
	"image/draw"
	"io"
)

// Read RGF header containing image size.
func readSize(rd io.Reader) (image.Rectangle, error) {
	header := make([]byte, 2)
	n, err := rd.Read(header)

	if err != nil {
		return image.Rect(0, 0, 0, 0), err
	}
	if n != 2 {
		return image.Rect(0, 0, 0, 0), fmt.Errorf("rgf: image header is truncated (%d)", n)
	}
	w := header[0]
	h := header[1]
	return image.Rect(0, 0, int(w), int(h)), nil
}

// Write RGF header containing image size.
func writeSize(wr io.Writer, bounds image.Rectangle) error {
	w := bounds.Dx()
	h := bounds.Dy()

	if w < 0 || w > 255 {
		return fmt.Errorf("rgf: image width out of range: %d", w)
	}
	if h < 0 || h > 255 {
		return fmt.Errorf("rgf: image height out of range: %d", h)
	}

	data := []byte{byte(w), byte(h)}

	n, err := wr.Write(data)
	if err != nil {
		return err
	}
	if n != 2 {
		return fmt.Errorf("rgf: written header truncated (%d)", n)
	}
	return nil
}

// Allocate buffer large enough to hold RGF image with size of 'im'.
func allocate(im *image.Paletted) []byte {
	return make([]byte, (im.Rect.Dx()+7)/8*im.Rect.Dy())
}

// Read all pixels from reader and write then into 1bpp paletted image.
func readPix(r io.Reader, im *image.Paletted) error {
	data := allocate(im)

	n, err := r.Read(data)
	if err != nil {
		return err
	}
	if n != cap(data) {
		return fmt.Errorf("rgf: input file truncated, got %d, expected %d", n, cap(data))
	}

	var idxByte uint = 0
	var idxBit uint8 = 0

	for y := im.Rect.Min.Y; y < im.Rect.Max.Y; y++ {
		for x := im.Rect.Min.X; x < im.Rect.Max.X; x++ {
			bit := (data[idxByte] >> idxBit) & 0x01
			im.SetColorIndex(x, y, uint8(bit))

			idxBit++
			if idxBit >= 8 {
				idxByte++
				idxBit = 0
			}
		}
		if idxBit != 0 {
			idxByte++
			idxBit = 0
		}
	}
	return nil
}

// Write all pixels from a 1bpp paletted image to a writer.
func writePix(w io.Writer, im *image.Paletted) error {
	data := allocate(im)

	var idxByte uint = 0
	var idxBit uint8 = 0

	for y := im.Rect.Min.Y; y < im.Rect.Max.Y; y++ {
		for x := im.Rect.Min.X; x < im.Rect.Max.X; x++ {
			col := im.ColorIndexAt(x, y) & 0x01
			data[idxByte] |= col << idxBit

			idxBit++
			if idxBit >= 8 {
				idxByte++
				idxBit = 0
			}
		}
		if idxBit != 0 {
			idxByte++
			idxBit = 0
		}
	}

	n, err := w.Write(data)
	if err != nil {
		return err
	}
	if n != cap(data) {
		return fmt.Errorf("rgf: output file truncated, got %d, expected %d", n, cap(data))
	}

	return nil
}

// Convert any image to 1bpp paletted image.
func rerender(src image.Image, render draw.Drawer) *image.Paletted {
	colors := []color.Color{color.White, color.Black}

	img := image.NewPaletted(src.Bounds(), colors)
	render.Draw(img, img.Bounds(), src, src.Bounds().Min)

	return img
}

// Encode image 'src' to RGF to writer 'w', while using Drawer 'render'
// for colorspace conversion. Render can be nil, in which case
// builtin Floyd-Steinberg dithering drawer will be used.
func Encode(w io.Writer, src image.Image, render draw.Drawer) error {
	if render == nil {
		render = draw.FloydSteinberg
	}

	img := rerender(src, render)

	err := writeSize(w, img.Bounds())
	if err != nil {
		return err
	}

	err = writePix(w, img)
	if err != nil {
		return err
	}
	return nil
}

// Decode RGF image from reader 'r'.
func Decode(r io.Reader) (image.Image, error) {
	bounds, err := readSize(r)
	if err != nil {
		return nil, err
	}

	colors := []color.Color{color.White, color.Black}
	img := image.NewPaletted(bounds, colors)

	err = readPix(r, img)
	if err != nil {
		return nil, err
	}

	return img, nil
}

// Image proxy for cropping and grayscale transformation
type ImageProxy struct {
	Image image.Image
	Crop  image.Rectangle
	BT601 bool
}

// Create a new image proxy
// - im - image to wrap
// - start - crop source image to start from this point
// - size - crop source image to this width and height
// - hardlimit - whether to also crop to the 255x255 RGF limit
// - bt601 - whether to perform RGB -> BT.601 color conversion
func NewImageProxy(im image.Image, start, size image.Point, hardlimit bool, bt601 bool) image.Image {
	min := start
	max := start.Add(size)
	maxHard := start.Add(image.Point{X: 255, Y: 255})

	boundReal := im.Bounds()
	boundUser := image.Rectangle{Min: min, Max: max}
	boundHard := image.Rectangle{Min: min, Max: maxHard}

	boundFinal := boundReal.Intersect(boundUser)
	if hardlimit {
		boundFinal = boundFinal.Intersect(boundHard)
	}
	return &ImageProxy{
		Image: im,
		Crop:  boundFinal,
		BT601: bt601}
}

// Return cropped image bounds.
func (proxy *ImageProxy) Bounds() image.Rectangle {
	return proxy.Crop
}

// Return original or filtered color model.
func (proxy *ImageProxy) ColorModel() color.Model {
	if proxy.BT601 {
		return color.Gray16Model
	} else {
		return proxy.Image.ColorModel()
	}
}

// Return original or filtered pixel at a specific point.
func (proxy *ImageProxy) At(x, y int) color.Color {
	col := proxy.Image.At(x, y)
	if proxy.BT601 {
		return color.Gray16Model.Convert(col)
	} else {
		return col
	}
}
