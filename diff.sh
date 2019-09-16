./test_slang.sh $1 ./build/slang 1
./test_slang.sh $1 ./build/tests/slang 2
meld ./build/$1.ll.1 ./build/$1.ll.2
