<p align="center">
  <img width="400" src="./github/logo_paths.svg">
</p>

Slang is a (far from feature-complete) scheme to llvm ir compiler.

## Building

To build everything and run all tests, run the following:
``` bash
meson build
./build_all.sh
```

You need to have the chicken scheme compiler installed to bootstrap slang.

## Examples

To run an example (or your own code), simply use this command:
``` bash
./test_slang.sh examples/romans.scm ./build/self_hosted.elf example
```
