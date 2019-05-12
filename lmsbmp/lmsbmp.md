% LMSBMP(1) | User's Manual
% Jakub Vanek
% May 2019

# NAME

lmsbmp - LEGO MINDSTORMS EV3 bitmap converter

# SYNOPSIS

lmsbmp --in=*in-file* --out=*out-file* [-x=*x0*] [-y=*y0*] [-w=*width*] [-h=*height*] [--bt601=*true/false*]

# DESCRIPTION

Converts between EV3 Robot Graphics Files and ordinary images.

# OPTIONS

--in=*in-file*
: Input image, this can be either a RGF image or a JPEG/PNG/GIF image.

--out=*out-file*
: Output image, this can be either a RGF image or a JPEG/PNG/GIF image.

-x=*x0*
: Crop the source image to start at this origin x coordinate.

-y=*y0*
: Crop the source image to start at this origin y coordinate.

-w=*width*
: Crop the source image to have the following width. If RGF is specified
  as the destination format, the image is also cropped to be at most 255
  pixels wide.

-h=*height*
: Crop the source image to have the following height. If RGF is specified
  as the destination format, the image is also cropped to be at most 255
  pixels tall.

--bt601=*true/false*
: Whether to perform RGB -> BT.601 grayscale conversion before saving
  the image. This may make the image look better or worse, so it is best
  to try and see what looks better.
