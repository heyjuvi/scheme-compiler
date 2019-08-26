#!/usr/bin/env bash
cd build
ninja
./sc > test.ll
cat ../ll/common.ll \
    ../ll/fixnum.ll \
    ../ll/pair.ll \
    ../ll/closure.ll \
    test.ll > program.ll
llc --filetype=obj program.ll
clang -c -g ../driver.c
clang -g -o driver driver.o program.o
./driver
cd ../
