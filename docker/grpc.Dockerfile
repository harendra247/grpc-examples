FROM ubuntu:20.04

LABEL maintainer="Harendra Singh <harendra247@hotmail.com>"

ARG GPRC_VERSION=1.44.0
ARG NUM_JOBS=8
ARG MY_INSTALL_DIR=$HOME/.local
ARG MY_CODE_DIR=$HOME/

###ENV DEBIAN_FRONTEND noninteractive

# Install package dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
            && apt-get install -y --no-install-recommends \
            build-essential \
            software-properties-common \
            autoconf \
            automake \
            libtool \
            pkg-config \
            ca-certificates \
            wget \
            git \
            curl \
            vim \
            gdb \
            valgrind \
            cmake && apt-get clean && rm -rf /var/lib/apt/lists/*

#### gRPC
#### https://github.com/grpc/grpc/tree/master/src/cpp
#### https://github.com/grpc/grpc/blob/master/BUILDING.md
#### apt-get install -y build-essential autoconf libtool pkg-config && \
###RUN cd /tmp && \
###     git clone --recurse-submodules -b v${GPRC_VERSION} https://github.com/grpc/grpc && \
###     cd grpc && mkdir -p cmake/build && pushd cmake/build && cmake -DgRPC_INSTALL=ON \
###     -DgRPC_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR ../.. && \
###     make -j${NUM_JOBS} && make install && popd && cd ../ && rm -rf grpc
###
###RUN cd /tmp && \
###git clone https://github.com/abseil/abseil-cpp.git && \
###cd abseil-cpp && mkdir build && pushd build && \
###cmake .. -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR && \
###make -j${NUM_JOBS} && make install && popd && cd ../ && rm -rf abseil-cpp

RUN INSTALL_DIR=$MY_INSTALL_DIR && mkdir -p $INSTALL_DIR \
	&& export PATH="$INSTALL_DIR/bin:$PATH" \
	&& git clone --recurse-submodules -b v${GPRC_VERSION} https://github.com/grpc/grpc \
	&& cd grpc && mkdir -p cmake/build && pushd cmake/build \
	&& cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR ../.. \
	&& make -j${NUM_JOBS} && make install && popd \
	&& mkdir -p third_party/abseil-cpp/cmake/build \
	&& pushd third_party/abseil-cpp/cmake/build \
	&& cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE ../.. \
	&& make -j${NUM_JOBS} && make install && popd && cd ../ && rm -rf grpc

###RUN export SRC_DIR=protos/ && export DST_DIR=src/sample_grpc/ && mkdir -p $DST_DIR \
###	&& protoc -I=$SRC_DIR --cpp_out=$DST_DIR $SRC_DIR/sample_grpc.proto \
###	&& protoc -I=$SRC_DIR --grpc_out=$DST_DIR --plugin=protoc-gen-grpc=$INSTALL_DIR/bin/grpc_cpp_plugin $SRC_DIR/sample_grpc.proto
RUN CODE_DIR=$MY_CODE_DIR && mkdir -p $CODE_DIR \
	&& export PATH="$CODE_DIR/bin:$PATH" \
	&& git clone https://github.com/grpc_examples \
	&& cd grpc_examples && mkdir -p cmake/build && pushd cmake/build \
	&& cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=$CODE_DIR ../.. \
	&& make -j${NUM_JOBS} && make install && popd && cd ../ && rm -rf grpc_examples

