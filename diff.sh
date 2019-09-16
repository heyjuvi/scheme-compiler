./test_slang1.sh $1
./test_slang2.sh $1
meld ./build/$1.ll.1 ./build/$1.ll.2
