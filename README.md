# Miscellaneous stuff related to LEGO EV3 firmware

## Reverse engineering the EV3 Color sensor

This contains reverse-engineered EV3 color sensor firmware source code. See [`ev3color`](ev3color) for details.

## EV3 sensor communication on a logic analyzer

This contains Sigrok/Pulseview recordings of the EV3 sensor communication.
See [`ev3sensors`](ev3sensors) for details.

## LMS2012 formats

### RBF (Robot Bytecode File)

Ev3dev already has a new assembler, see [lmsasm](https://github.com/ev3dev/lmsasm/).

### RPF (Robot Program File)

This is just a templated RBF file (see [template.lms](https://github.com/mindboards/ev3sources-xtended/blob/master/ev3sources/lms2012/lmssrc/Brick%20Program/template.lms))

Some sort of viewer might be useful. *TODO*

### RGF (Robot Graphics File)

Done.

#### Small utility + library in Go
- `/rgf` - Go library for loading and saving RGF images.
- `/lmsbmp` - Go utility built around the `rgf` library. See the `/lmsbmp/lmsbmp.md` manpage for details.

#### ImageMagick way
You can also use ImageMagick to achieve the same thing. To convert as with `--bt601=true`, use the following command line:
```sh
convert source.png -crop WxH+X+Y -grayscale rec601luma -dither FloydSteinberg -remap pattern:gray50 destination.rgf
```

To convert the image like with `--bt601=false`, use the following command line:
```sh
convert source.png -crop WxH+X+Y -dither FloydSteinberg -remap pattern:gray50 destination.rgf
```

### RSF (Robot Sound File)

Done.

This is the same format as the NXT RSO. FFmpeg already contains a muxer; SoX with RSO/RSF support can be found [here](http://github.com/jakubvanek/sox-rsf).

One strange thing is that ADPCM playback on EV3 sounds really loud and distorted.

### RDF (Robot Datalog File)

*TODO* (see [cnvlog.c](https://github.com/mindboards/ev3sources-xtended/blob/master/ev3sources/lms2012/lmssrc/adk/cnvlog/cnvlog.c))

### RAF (Robot Archive File)

This is just a tarball (see [c_memory.c](https://github.com/mindboards/ev3sources-xtended/blob/b32a23625be02eb22f23ac45d2ef3bd4a2a9173f/ev3sources/lms2012/c_memory/source/c_memory.c#L4646))

```sh
tar -czf archive.raf <files> # create
tar -xzf archive.raf # extract
```

### RTF (Robot Text File)

This is a simple text file.

### RCF (Robot Config File)

This is also a text file.

Typedata parser might be useful. *TODO* (see [c_input.c](https://github.com/mindboards/ev3sources-xtended/blob/b32a23625be02eb22f23ac45d2ef3bd4a2a9173f/ev3sources/lms2012/c_input/source/c_input.c#L773))


## Disclaimer

LEGO® is a trademark of the LEGO Group of companies which does not sponsor,
authorize or endorse this software.
