./build/tests/slang ./build/tests/self_combined.scm > ./build/self_hosted.ll
cat ll/bool.ll ll/char.ll ll/closure.ll ll/common.ll ll/fixnum.ll ll/generic.ll ll/pair.ll ll/port.ll ll/string.ll ll/symbol.ll ll/vector.ll ./build/self_hosted.ll > ./build/self_hosted.combined.ll
llc ./build/self_hosted.combined.ll --filetype=obj -o ./build/self_hosted.o
clang -m64 -g -no-pie ./build/self_hosted.o -o ./build/self_hosted.elf
