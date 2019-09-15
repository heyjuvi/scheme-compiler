./build/tests/slang.elf $1 > ./build/$1.ll
cat ll/bool.ll ll/char.ll ll/closure.ll ll/common.ll ll/fixnum.ll ll/generic.ll ll/pair.ll ll/port.ll ll/string.ll ll/symbol.ll ll/vector.ll ./build/$1.ll > ./build/$1.combined.ll
llc ./build/$1.combined.ll --filetype=obj -o ./build/$1.o
clang -m64 -g -no-pie ./build/$1.o -o ./build/$1.elf
./build/$1.elf
