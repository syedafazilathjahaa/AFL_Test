set -e
CC=clang  CXX=clang++ CFLAGS=-fsanitize=address
export CC CXX

# Make sure we don't clobber anything in the current directory.
rm -rf afl-build
git clone --depth=1 https://github.com/AFLplusplus/AFLplusplus afl-build
cd afl-build
make all
ar ru FuzzingEngine.a afl-compiler-rt.o utils/aflpp_driver/aflpp_driver.o

cp -f FuzzingEngine.a afl-fuzz afl-showmap ../
ls -lrth
echo "Success: link fuzz target against FuzzingEngine.a!"

$CC -fsanitize=address -fsanitize-coverage=trace-pc-guard imageRead.c FuzzingEngine.a -o imageRead
