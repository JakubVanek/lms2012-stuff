// Copyright 2016,2019 David Lechner <david@lechnology.com>
// Copyright 2019 Jakub Vanek <linuxtardis@gmail.com>
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// This program can convert to and from the EV3 RGF format.
// It is also an example for how to use the 'rgf' library.
package main

import (
	"flag"
	"image"
	_ "image/gif"
	_ "image/jpeg"
	"image/png"
	"log"
	"os"
	"strings"

	"github.com/ev3dev/lmsasm/rgf"
)

func main() {
	src := flag.String("in", "", "Source image file.")
	dst := flag.String("out", "", "Destination image file.")
	w := flag.Uint("w", 16384, "Crop output image to the specified width.")
	h := flag.Uint("h", 16384, "Crop output image to the specified height.")
	x := flag.Int("x", 0, "Crop output image to the specified starting x position.")
	y := flag.Int("y", 0, "Crop output image to the specified starting y position.")
	gray := flag.Bool("bt601", true, "Whether to convert image to BT.601 grayscale before dithering.")
	flag.Parse()

	if flag.NArg() != 0 {
		log.Fatal("Unexpected positional argument.")
	}

	if len(*src) == 0 {
		log.Fatal("Source file is mandatory.")
	}
	if len(*dst) == 0 {
		log.Fatal("Destination file is mandatory.")
	}

	in, err := os.Open(*src)
	if err != nil {
		log.Fatal("Error opening input file:", err)
	} else {
		defer in.Close()
	}

	out, err := os.Create(*dst)
	if err != nil {
		log.Fatal("Error opening output file:", err)
	} else {
		defer out.Close()
	}

	var img image.Image
	var filt image.Image

	srcRGF := strings.HasSuffix(strings.ToLower(*src), ".rgf")
	dstRGF := strings.HasSuffix(strings.ToLower(*dst), ".rgf")

	if srcRGF {
		img, err = rgf.Decode(in)
	} else {
		img, _, err = image.Decode(in)
	}
	if err != nil {
		log.Fatal("Error reading input image: ", err)
	}

	start := image.Point{X: *x, Y: *y}
	size := image.Point{X: int(*w), Y: int(*h)}
	filt = rgf.NewImageProxy(img, start, size, dstRGF, *gray)

	if dstRGF {
		err = rgf.Encode(out, filt, nil)
	} else {
		err = png.Encode(out, filt)
	}
	if err != nil {
		log.Fatal("Error writing output image: ", err)
	}

}
