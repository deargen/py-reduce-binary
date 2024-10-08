FROM ubuntu:18.04 as builder
## USAGE: docker build . -f linux_build.Dockerfile -t reduce-appimage --build-arg REDUCE_RELEASE_TAG=v4.14
RUN apt-get update && apt-get install -y \
            g++ make cmake git \
			binutils  # to check the minimum required glibc version

ENV BUILD_DIR=/opt/build
RUN mkdir -p $BUILD_DIR

FROM builder as appimage
ARG REDUCE_RELEASE_TAG='master'
## Fetch Code
WORKDIR /opt
RUN git clone -b $REDUCE_RELEASE_TAG --depth 1 https://github.com/rlabduke/reduce
ENV REPO_ROOT=/opt/reduce

## Build
WORKDIR $REPO_ROOT
ENV LD_LIBRARY_PATH="$BUILD_DIR/lib"
ENV CPPFLAGS="-I$BUILD_DIR/include"
ENV LDFLAGS="-L$BUILD_DIR/lib"
RUN cmake . -DCMAKE_INSTALL_PREFIX="$BUILD_DIR"
RUN make -j4 && make install

## Check the minimum required glibc version
RUN objdump -T "$BUILD_DIR/bin/reduce" | grep -v GLIBCXX | grep GLIBC | sed 's/.*GLIBC_\([.0-9]*\).*/\1/g' | sort -Vu | tail -1 > /opt/binary_glibc_dependency.txt
