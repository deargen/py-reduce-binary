#!/bin/bash

if [[ $OSTYPE != "linux-gnu" ]]; then
    echo "❌ This script is intended to be run on a Linux system."
    exit 1
fi

if [[ $# -ge 1 ]]; then
	REDUCE_RELEASE_TAG=$1
else
    echo "usage: $0 <REDUCE-RELEASE-TAG>"
    exit 1
fi

docker build . -f linux_build.Dockerfile -t reduce-build --build-arg REDUCE_RELEASE_TAG="$REDUCE_RELEASE_TAG"

docker rm -f reducecontainer
docker create -ti --name reducecontainer reduce-build bash
docker cp reducecontainer:/opt/build .
docker cp reducecontainer:/opt/binary_glibc_dependency.txt .
BINARY_GLIBC_DEPENDENCY=$(cat binary_glibc_dependency.txt)
rm binary_glibc_dependency.txt

# Check if the glibc dependency is lower than 2.17
# this should be 2.17. Only if the dependency is higher than 2.17, the value will be different
dependency_lower_than_2_17=$(printf "%s\n2.17" "$BINARY_GLIBC_DEPENDENCY" | sort -Vu | tail -1)

if [[ "$dependency_lower_than_2_17" != "2.17" ]]; then
    echo "⚠️ The glibc dependency is higher than 2.17."
    echo "⚠️ The binary may not run on all systems."
    echo "⚠️ Dependency: $BINARY_GLIBC_DEPENDENCY"
    docker rm -f reducecontainer
    exit 1
else
    echo "✅ The glibc dependency is lower than 2.17."
    echo "✅ The binary should run on most systems."
    echo "✅ Dependency: $BINARY_GLIBC_DEPENDENCY"
fi

docker rm -f reducecontainer
