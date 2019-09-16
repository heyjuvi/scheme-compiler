./build/tests/slang.elf $1 > ./build/$1.ll.2
cat ll/bool.ll ll/char.ll ll/closure.ll ll/common.ll ll/fixnum.ll ll/generic.ll ll/pair.ll ll/port.ll ll/string.ll ll/symbol.ll ll/vector.ll ./build/$1.ll.2 > ./build/$1.combined.ll.2
llc ./build/$1.combined.ll.2 --filetype=obj -o ./build/$1.o.2
clang -m64 -g -no-pie ./build/$1.o.2 -o ./build/$1.elf.2
./build/$1.elf.2
