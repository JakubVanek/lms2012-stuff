% LMSBMP(1) | User's Manual
% Jakub Vanek
% May 2019

# NAME

lmsbmp - LEGO MINDSTORMS EV3 bitmap converter

# SYNOPSIS

lmsbmp [--dither true/false] [--cutoff *level*] [--topng] *in-file* *out-file*

# DESCRIPTION

Converts between EV3 Robot Graphics Files and ordinary images.

# OPTIONS

--dither *true*/*false*
: Enable or disable dithering. To enhance image quality, it is enabled
  by default.

--cutoff *level*
: When dithering is disabled, this value is used as a threshold for
  deciding whether a pixel should be black or white.

--topng
: When this flag is specified, RGF files will be converted to PNG. When
  this flag is omitted, JPEG or PNG files will be converted to RGF.

*in-file*
: Input image, this can be either a JPEG/PNG file or a RGF file.
  This depends on the program mode; see **--topng** switch. By default,
  this is the JPEG/PNG file.

*out-file*
: Output path, this can be either a PNG file or a RGF file.
  This depends on the program mode; see **--topng** switch. By default,
  this is the EV3 RGF file.
