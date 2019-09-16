cd build
ninja
ninja test
cd ..
./build_self_hosted.sh
./run_all_tests.sh build/self_hosted.elf self

