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

## RDF (Robot Datalog File)

*TODO*

## RAF (Robot Archive File)

*TODO*

However, you can create the file using tar:
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
