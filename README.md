# LMS2012 format conversion libraries & utilities

## RBF (Robot Bytecode File)

See [lmsasm](https://github.com/ev3dev/lmsasm/).

## RPF (Robot Program File)

This should basically be a specially formatted RBF file.

Some sort of decompiler might be useful. *TODO*

## RGF (Robot Graphics File)

- `/rgf` - Go library for loading and saving RGF images.
- `/lmsbmp` - Go utility built around the `rgf` library. See the `/lmsbmp/lmsbmp.md` manpage for details.

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

*TODO*

## RAF (Robot Archive File)

This is just a tarball.

```sh
tar -czf archive.raf <files> # create
tar -xzf archive.raf # extract
```

## RTF (Robot Text File)

This is a simple text file.

## RCF (Robot Config File)

This is also a text file.

Typedata parser might be useful. *TODO*


## Disclaimer

LEGO® is a trademark of the LEGO Group of companies which does not sponsor,
authorize or endorse this software.
