# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && apt-get install -y make autoconf automake libtool libdb-dev
RUN apt-get install -y \
    libc6-dev \
    libc++-dev \
    gcc \
    g++ \
    make \
    wget \
    gdb \
    llvm-dev \
    llvm-10 \
    clang \
    g++-multilib

RUN apt-get -y install afl++
RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
    automake \
    cmake \
    meson \
    ninja-build \
    bison flex \
    build-essential \
    git \
    python3 python3-dev python3-setuptools python-is-python3 \
    libtool libtool-bin \
    libglib2.0-dev \
    wget vim jupp nano bash-completion less \
    apt-utils apt-transport-https ca-certificates gnupg dialog \
    libpixman-1-dev \
    gnuplot-nox \
    && rm -rf /var/lib/apt/lists/*
    
RUN apt-get install -y build-essential python3-dev automake cmake git flex bison libglib2.0-dev libpixman-1-dev python3-setuptools
# try to install llvm 10 and install the distro default if that fails
RUN apt-get install -y llvm-10 llvm-10-dev clang-10 || apt-get install -y llvm llvm-dev clang
RUN apt-get install -y ninja-build # for QEMU mode

ENV LLVM_CONFIG=llvm-config-10
ENV gcc=/usr/bin/gcc.exe 
ENV gcc=gcc-7-plugin-dev
ENV AFL_SKIP_CPUFREQ=1
ENV AFL_TRY_AFFINITY=1
ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1
RUN export CC=clang && export CXX=clang++
RUN export LLVM_CONFIG=/usr/bin/llvm-config-10

WORKDIR AFL
COPY . $SRC/
COPY .clusterfuzzlite/build.sh $SRC/
COPY .clusterfuzzlite/imgRead_libfuzzer.c .clusterfuzzlite/input/image.img $SRC/
