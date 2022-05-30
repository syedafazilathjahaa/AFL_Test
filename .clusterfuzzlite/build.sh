set -e
CC=clang  CXX=clang++ CFLAGS=-fsanitize=address
export CC CXX
set $LLVM_CONFIG=/usr/bin/llvm-config-10

cd $SRC/.clusterfuzzlite/input
ls -lrth
xxd image.img

git clone https://github.com/AFLplusplus/AFLplusplus

cd AFLplusplus
make all
make install
cp $SRC/.clusterfuzzlite/imgRead.c .
ls -lrth

./afl-cc -fsanitize=address,undefined -ggdb imgRead.c -o imgRead
./afl-fuzz -i $SRC/.clusterfuzzlite/input/ -o output -m none -- ./imgRead @@
