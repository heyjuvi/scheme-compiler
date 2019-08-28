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
clang -m64 -c -g ../driver.c
clang -m64 -g -o driver driver.o program.o -no-pie -O3
time ./driver
cd ../
