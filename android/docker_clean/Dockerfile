FROM pipeline_android_build:latest as builder

WORKDIR /root/morello_workspace

RUN tar -cf soc.tar output/soc/android-nano.img output/soc/firmware bsp/board-firmware/* \
    && xz -T0 soc.tar

FROM ubuntu:20.04 as cleanroom

WORKDIR /root/

# Ubuntu 20.04 has some BS timezone noncery during the setup that we need to skip.
ARG DEBIAN_FRONTEND=noninteractive

# Use bash
SHELL ["/bin/bash", "-c"]

RUN apt update -y
RUN apt install -y wget gcc g++ make binutils build-essential bc openssl git python

# Needed for cmake install
RUN apt install -y libssl-dev

# Copy cmake
COPY --from=builder /root/cmake-3.23.1 /root/cmake-3.23.1
Run cd cmake-3.23.1 \
    && make install
Run rm -r cmake-3.23.1

# Copy toolchain
WORKDIR /root/morello_workspace
COPY toolchain.morello.cmake /root/morello_workspace/toolchain.morello.cmake

# Copy important dirs from other build
# Track build version
COPY --from=builder /root/morello_workspace/.repo/manifests /root/morello_workspace/.repo/manifests/

RUN mkdir android tools
COPY --from=builder /root/morello_workspace/tools/clang /root/morello_workspace/tools/clang/
COPY --from=builder /root/morello_workspace/android/bionic /root/morello_workspace/android/bionic/
COPY --from=builder /root/morello_workspace/android/system /root/morello_workspace/android/system/
COPY --from=builder /root/morello_workspace/android/hardware /root/morello_workspace/android/hardware/
COPY --from=builder /root/morello_workspace/android/libnativehelper /root/morello_workspace/android/libnativehelper/

RUN mkdir -p android/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/aarch64-linux-android
RUN mkdir -p android/prebuilts/clang/host/linux-x86
COPY --from=builder /root/morello_workspace/android/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/aarch64-linux-android/bin \
        /root/morello_workspace/android/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/aarch64-linux-android/bin/
COPY --from=builder /root/morello_workspace/android/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin \
        /root/morello_workspace/android/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/
# The below commented copy is a symlink to a 1.6G directory. When using the copy function on a symlink it follows it and copies the data
# A suggested workaround is to copy the directory the symlink is in, as then the symlink is preserved. This isn't great in our case 
# as the directory contains 9.9GB of data which we don't want. So making the symlink ourselves seems like the best option
# COPY --from=builder /root/morello_workspace/android/prebuilts/clang/host/linux-x86/clang-morello \
#         /root/morello_workspace/android/prebuilts/clang/host/linux-x86/clang-morello/
# https://github.com/moby/moby/issues/40449
# https://stackoverflow.com/questions/66821257/what-are-docker-copys-rules-about-symlinks-how-can-i-preserve-symlinks
Run ln -s /root/morello_workspace/tools/clang /root/morello_workspace/android/prebuilts/clang/host/linux-x86/clang-morello

# copy external/ libarchcap libcxx libcxxabi jemalloc_new libshim ltp
RUN mkdir android/external
COPY --from=builder /root/morello_workspace/android/external/libarchcap \
        /root/morello_workspace/android/external/libarchcap/
COPY --from=builder /root/morello_workspace/android/external/libcxx \
        /root/morello_workspace/android/external/libcxx/
COPY --from=builder /root/morello_workspace/android/external/libcxxabi \
        /root/morello_workspace/android/external/libcxxabi/
COPY --from=builder /root/morello_workspace/android/external/jemalloc_new \
        /root/morello_workspace/android/external/jemalloc_new/
COPY --from=builder /root/morello_workspace/android/external/libshim \
        /root/morello_workspace/android/external/libshim/
COPY --from=builder /root/morello_workspace/android/external/ltp \
        /root/morello_workspace/android/external/ltp/

#copy frameworks/ native av
RUN mkdir android/frameworks
COPY --from=builder /root/morello_workspace/android/frameworks/native \
        /root/morello_workspace/android/frameworks/native/
COPY --from=builder /root/morello_workspace/android/frameworks/av \
        /root/morello_workspace/android/frameworks/av/

# copy out/ static_libraries
RUN mkdir -p android/out/target/product/morello/obj_morello/
COPY --from=builder /root/morello_workspace/android/out/target/product/morello/obj_morello/STATIC_LIBRARIES \
        /root/morello_workspace/android/out/target/product/morello/obj_morello/STATIC_LIBRARIES/
# add dummy standard libraries
RUN mkdir /root/morello_workspace/android/out/target/product/morello/obj_morello/STATIC_LIBRARIES/dummy_lib \
    && cd /root/morello_workspace/android/out/target/product/morello/obj_morello/STATIC_LIBRARIES/dummy_lib \
    && touch libc.a libm.a libdl.a libpthread.a librt.a 

# Copy zipped OS
RUN mkdir -p /root/morello_workspace/output/soc
COPY --from=builder /root/morello_workspace/soc.tar.xz \
        /root/morello_workspace/

# Allow other users access to the morello_workspace dir
RUN chmod +x /root

# Install internationalisation support, seemingly needed for Univeral Package push to succeed
# along with CA certificates
RUN apt install -y libicu66 ca-certificates

RUN apt-get install -y python3 python3-pip
RUN apt-get install -y psmisc jq sqlite3 zip xz-utils

# Install sudo allowing additional software to be installed if required
RUN apt install -y sudo


