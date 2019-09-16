./build/slang $1 > ./build/$1.ll.1
cat ll/bool.ll ll/char.ll ll/closure.ll ll/common.ll ll/fixnum.ll ll/generic.ll ll/pair.ll ll/port.ll ll/string.ll ll/symbol.ll ll/vector.ll ./build/$1.ll.1 > ./build/$1.combined.ll.1
llc ./build/$1.combined.ll.1 --filetype=obj -o ./build/$1.o.1
clang -m64 -g -no-pie ./build/$1.o.1 -o ./build/$1.elf.1
./build/$1.elf.1
