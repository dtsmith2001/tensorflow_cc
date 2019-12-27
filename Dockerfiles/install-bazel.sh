#!/bin/bash
set -e

if [ "$1" == "true" ]
then
	# install bazel for the shared library version
	export BAZEL_VERSION=${BAZEL_VERSION:-`cat ./tensorflow_cc/Dockerfiles/BAZEL_VERSION`}
	apt-get -y install pkg-config zip g++ zlib1g-dev unzip python
	bazel_installer=bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
	wget -P /tmp https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/${bazel_installer}
	chmod +x /tmp/${bazel_installer}
	/tmp/${bazel_installer}
	rm /tmp/${bazel_installer}
fi
