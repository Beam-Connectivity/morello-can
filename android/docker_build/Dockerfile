FROM ubuntu:20.04 as builder

WORKDIR /root/

# Ubuntu 20.04 has some BS timezone noncery during the setup that we need to skip.
ARG DEBIAN_FRONTEND=noninteractive

# Use bash
SHELL ["/bin/bash", "-c"]

# Packages to build android
RUN apt update -y
RUN apt install -y autoconf autopoint bc bison build-essential curl \
        device-tree-compiler dosfstools doxygen flex gdisk gettext-base git \
        libncurses5 libssl-dev libtinfo5 linux-libc-dev-arm64-cross m4 mtools \
        parted pkg-config python python3-distutils rsync snapd unzip uuid-dev \
        wget gcc g++ make binutils

# Get right cmake version
RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1.tar.gz \
    && tar -xf cmake-3.23.1.tar.gz \
    && rm cmake-3.23.1.tar.gz
Run cd cmake-3.23.1 \
    && ./bootstrap \
    && make -j4 \
    && make install

# Get repo tool
RUN mkdir -p .bin
RUN export REPO=$(mktemp /tmp/repo.XXXXXXXXX) \
    && curl -o ${REPO} https://storage.googleapis.com/git-repo-downloads/repo \
    && gpg --keyserver keys.openpgp.org --recv-key 8BB9AD793E8E6153AF0F9A4416530D5E920F5C65 \
    && curl -s https://storage.googleapis.com/git-repo-downloads/repo.asc | gpg \
        --verify - ${REPO} && install -m 755 ${REPO} ~/.bin/repo

# Make workspace
RUN mkdir morello_workspace
WORKDIR /root/morello_workspace

# Clone repo
RUN ${HOME}/.bin/repo init \
        -u https://git.morello-project.org/morello/manifest.git \
        -b morello/release-1.4.1 \
        -g busybox,android \
    && ${HOME}/.bin/repo sync

# Kernal changes
# Is this the best way of getting these inserted?
RUN KERNAL_CONFIG_LINE=`grep -n "kernel_config=(" build-scripts/build-linux.sh | cut -d : -f 1` \
    && sed -i "${KERNAL_CONFIG_LINE} a --enable CAN" build-scripts/build-linux.sh \
    && sed -i "${KERNAL_CONFIG_LINE} a --enable CAN_SLCAN" build-scripts/build-linux.sh \
    && sed -i "${KERNAL_CONFIG_LINE} a --enable USB_SERIAL" build-scripts/build-linux.sh \
    && sed -i "${KERNAL_CONFIG_LINE} a --enable USB_SERIAL_GENERIC" build-scripts/build-linux.sh \
    && sed -i "${KERNAL_CONFIG_LINE} a --enable USB_SERIAL_PL2303" build-scripts/build-linux.sh
RUN ./build-scripts/build-all.sh -p soc -f android-nano all
RUN cd android \
    && source build/envsetup.sh \
    && lunch morello_nano-eng \
    && m crtend_android_purecap libc++fs_purecap libc++_static_purecap libc++demangle_purecap \
        libm_purecap libc_purecap libcompiler_rt-extras_purecap libcompiler_rt_purecap \
        crtbegin_static_purecap
