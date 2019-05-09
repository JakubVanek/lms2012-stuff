// Copyright 2016,2019 David Lechner <david@lechnology.com>
// Copyright 2019 Jakub Vanek <linuxtardis@gmail.com>
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main

import (
	"flag"
	"image"
	_ "image/jpeg"
	"image/png"
	"log"
	"os"

	"github.com/ev3dev/lmsasm/rgf"
)

func main() {
	dither := flag.Bool("dither", true, "Enable dithering")
	cutoff := flag.Int("cutoff", 128, "Cutoff brightness")
	toPNG := flag.Bool("topng", false, "Whether to convert PNG->RGF (default) or RGF->PNG (this flag)")
	flag.Parse()

	if flag.NArg() != 2 {
		log.Fatal("Missing input file name")
	}
	input := flag.Arg(0)
	output := flag.Arg(1)

	in, err := os.Open(input)
	if err != nil {
		log.Fatal("Error opening input file:", err)
	} else {
		defer in.Close()
	}

	out, err := os.Create(output)
	if err != nil {
		log.Fatal("Error opening output file:", err)
	} else {
		defer out.Close()
	}

	if *toPNG {
		upconvert(in, out)
	} else {
		downconvert(in, out, *dither, *cutoff)
	}
}

// upconvert converts an RGF file to a PNG file
func upconvert(in *os.File, out *os.File) {
	bmp, err := rgf.Read(in)
	if err != nil {
		log.Fatal("Error reading RGF: ", err)
	}
	err = png.Encode(out, bmp)
	if err != nil {
		log.Fatal("Error writing PNG: ", err)
	}
}

// downconvert converts a PNG/JPG file to an RGF file.
func downconvert(in *os.File, out *os.File, dither bool, thresh int) {
	img, _, err := image.Decode(in)
	if err != nil {
		log.Fatal("Error decoding image: ", err)
	}

	var bmp *rgf.Bitmap
	if dither {
		bmp = rgf.ByDither(img)
	} else {
		bmp = rgf.ByThreshold(img, uint8(thresh))
	}

	_, err = bmp.Write(out)
	if err != nil {
		log.Fatal("Error writing RGF: ", err)
	}
}
