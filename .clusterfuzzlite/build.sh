cd $SRC/.clusterfuzzlite
chmod +x ./build_afl.bash

$CC -fsanitize=address -fsanitize-coverage=trace-pc-guard fuzzer.cc FuzzingEngine.a -o fuzzer
