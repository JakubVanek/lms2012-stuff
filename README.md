# LMS2012 format conversion libraries & utilities

## RBF (Robot Bytecode File)

Ev3dev already has a new assembler, see [lmsasm](https://github.com/ev3dev/lmsasm/).

## RPF (Robot Program File)

This is just a templated RBF file (see [template.lms](https://github.com/mindboards/ev3sources-xtended/blob/master/ev3sources/lms2012/lmssrc/Brick%20Program/template.lms))

Some sort of viewer might be useful. *TODO*

## RGF (Robot Graphics File)

Done.

### Small utility + library in Go
- `/rgf` - Go library for loading and saving RGF images.
- `/lmsbmp` - Go utility built around the `rgf` library. See the `/lmsbmp/lmsbmp.md` manpage for details.

### ImageMagick way
You can also use ImageMagick to achieve the same thing. To convert as with `--bt601=true`, use the following command line:
```sh
convert source.png -crop WxH+X+Y -grayscale rec601luma -dither FloydSteinberg -remap pattern:gray50 destination.rgf
```

To convert the image like with `--bt601=false`, use the following command line:
```sh
convert source.png -crop WxH+X+Y -dither FloydSteinberg -remap pattern:gray50 destination.rgf
```

## RSF (Robot Sound File)

*TODO*

Format:

- byte 1-2: big-endian u16 format magic
  - `0x0100` - uncompressed u8 8 kHz samples
  - `0x0101` - IMA ADPCM? 8 KHz samples
- byte 3-4: big-endian u16 sound data length
- byte 5-6: big-endian u16 sample rate
  - it is not parsed in c_sound - 8 kHz is the only possible value
- byte 7-8: big-endian u16 "sound playback mode"
  - it is not parsed in c_sound; but it may have a purpose elsewhere
- bytes 9-end: sound data
  - either u8 samples
  - or ADPCM 4bit samples

U8 decode:
```sh
LENGTH=$(od -An --endian=big -j 2 -N 2 -t u2 input.rsf)
tail -c +9 input.rsf | head -c $LENGTH | sox -t raw -r 8000 -b 8 -e unsigned-integer -c 1 - output.wav
```

U8 encode:
```sh
sox input.wav -t raw -r 8000 -b 8 -e unsigned-integer -c 1 output.raw
LENGTH=$(cat output.raw | wc -c)
echo -ne '\x01\x00' >output.rsf
printf "0: %.4x" $LENGTH | xxd -r -g0 >>output.rsf
echo -ne '\x1F\x40\x00\x00' >>output.rsf
cat output.raw >>output.rsf
```

## RDF (Robot Datalog File)

*TODO* (see [cnvlog.c](https://github.com/mindboards/ev3sources-xtended/blob/master/ev3sources/lms2012/lmssrc/adk/cnvlog/cnvlog.c))

## RAF (Robot Archive File)

This is just a tarball (see [c_memory.c](https://github.com/mindboards/ev3sources-xtended/blob/b32a23625be02eb22f23ac45d2ef3bd4a2a9173f/ev3sources/lms2012/c_memory/source/c_memory.c#L4646))

```sh
tar -czf archive.raf <files> # create
tar -xzf archive.raf # extract
```

## RTF (Robot Text File)

This is a simple text file.

## RCF (Robot Config File)

This is also a text file.

Typedata parser might be useful. *TODO* (see [c_input.c](https://github.com/mindboards/ev3sources-xtended/blob/b32a23625be02eb22f23ac45d2ef3bd4a2a9173f/ev3sources/lms2012/c_input/source/c_input.c#L773))


## Disclaimer

LEGO® is a trademark of the LEGO Group of companies which does not sponsor,
authorize or endorse this software.
