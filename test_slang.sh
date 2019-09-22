scm_source=$(basename $1)
cat tests/test-lib.scm $1 > ./build/$scm_source.test
$2 ./build/$scm_source.test > ./build/$scm_source.ll.$3
cat ll/bool.ll ll/char.ll ll/closure.ll ll/common.ll ll/fixnum.ll ll/generic.ll ll/pair.ll ll/port.ll ll/string.ll ll/symbol.ll ll/vector.ll  ./build/$scm_source.ll.$3 > ./build/$scm_source.combined.ll.$3
llc ./build/$scm_source.combined.ll.$3 --filetype=obj -o ./build/$scm_source.o.$3
clang -m64 -g -no-pie ./build/$scm_source.o.$3 -o ./build/$scm_source.elf.$3
./build/$scm_source.elf.$3
