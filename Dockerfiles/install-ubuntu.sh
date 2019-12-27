#!/bin/bash
set -e

# parse command line arguments

shared=false
cuda=false

for key in "$@"; do
    case $key in
        --shared)
        shared=true
        ;;
        --cuda)
        cuda=true
        ;;
    esac
done

if $shared; then
    # install bazel for the shared library version
    export BAZEL_VERSION=${BAZEL_VERSION:-`cat ./tensorflow_cc/Dockerfiles/BAZEL_VERSION`}
    apt-get -y install pkg-config zip g++ zlib1g-dev unzip python
    bazel_installer=bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
    wget -P /tmp https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/${bazel_installer}
    chmod +x /tmp/${bazel_installer}
    /tmp/${bazel_installer}
    rm /tmp/${bazel_installer}
fi
if $cuda; then
    # install libcupti
    apt-get -y install cuda-command-line-tools-10-1
fi

apt-get -y clean

# when building TF with Intel MKL support, `locate` database needs to exist
updatedb

# build and install tensorflow_cc
./tensorflow_cc/Dockerfiles/install-common.sh "$@"

