#!/usr/bin/bash
set -e

./test_slang.sh tests/fixnum.scm $1 $2
./test_slang.sh tests/char.scm $1 $2
./test_slang.sh tests/bool.scm $1 $2
./test_slang.sh tests/pair.scm $1 $2
./test_slang.sh tests/vector.scm $1 $2
./test_slang.sh tests/closure.scm $1 $2
./test_slang.sh tests/string.scm $1 $2
./test_slang.sh tests/symbol.scm $1 $2
./test_slang.sh tests/if.scm $1 $2
./test_slang.sh tests/begin.scm $1 $2
./test_slang.sh tests/let.scm $1 $2
./test_slang.sh tests/cond.scm $1 $2
./test_slang.sh tests/set.scm $1 $2
#./test_slang2.sh ../tests/io.scm
