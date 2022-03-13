# grpc-examples
gRPC c++ examples with CMake.

## Dependencies

* gRPC 1.44
* CMake 3.15.0+

## Files

```
.
|-- CMakeLists.txt
|-- LICENSE
|-- README.md
|-- docker
|   `-- grpc.Dockerfile
|-- protos
|   |-- calculator.proto
|   |-- greetings.proto
|   |-- route_guide.proto
|   `-- sample_grpc.proto
|-- runtime.sh
`-- src
    |-- CMakeLists.txt
    |-- Makefile
    |-- calculator
    |   |-- CMakeLists.txt
    |   |-- calculator_async_client.cpp
    |   |-- calculator_async_server.cpp
    |   |-- calculator_client.cpp
    |   `-- calculator_server.cpp
    |-- greetings
    |   |-- CMakeLists.txt
    |   |-- greetings_client.cpp
    |   `-- greetings_server.cpp
    `-- sample_grpc
        |-- CMakeLists.txt
        |-- sample_grpc_async_client.cpp
        |-- sample_grpc_async_server.cpp
        |-- sample_grpc_client.cpp
        `-- sample_grpc_server.cpp
```

## Working with Examples

### How to define a service

#### Instruction
Define a service in a `.proto` file using the **Interface Definition Language (IDL)** from **Protocol Buffers**.

#### Example: [Sample service](protos/sample_grpc.proto)
```protobuf
syntax = "proto3";

option java_package = "sample_grpc.grpc";

package sample_grpc;

service SampleGRPCService {
    rpc Method (Request) returns (Response) {}
}

message Request {
    string request_field = 1;
}

message Response {
    string response_field = 1;
}
```

#### Example: [Calculator service](protos/calculator.proto)

#### Note

### How to generate gRPC code

#### Instruction
Use the protocol buffer compiler `protoc` to generate client and server code:
```bash
$ protoc -I=$SRC_DIR --cpp_out=$DST_DIR $SRC_DIR/sample_grpc.proto
$ protoc -I=$SRC_DIR --grpc_out=$DST_DIR --plugin=protoc-gen-grpc=/usr/local/bin/grpc_cpp_plugin $SRC_DIR/sample_grpc.proto
```
where:
* `SRC_DIR`: The source directory, or the directory contains the `.proto` file.
* `DST_DIR`: The destination directory, or the directory contains the `.pb.h`, `.pb.cc`, `.grpc.pb.h` and `.grpc.pb.cc` files.

#### Example: Sample
With `SRC_DIR = protos/` and `DST_DIR = sample_grpc/`:
```bash
$ protoc -I=protos/ --cpp_out=sample_grpc/ protos/sample_grpc.proto
$ protoc -I=protos/ --grpc_out=sample_grpc/ --plugin=protoc-gen-grpc=/usr/local/bin/grpc_cpp_plugin protos/sample_grpc.proto
```

#### Example: Calculator

With `SRC_DIR = protos/` and `DST_DIR = calculator/`:

```bash
$ protoc -I=protos/ --cpp_out=calculator/ protos/calculator.proto
$ protoc -I=protos/ --grpc_out=calculator/ --plugin=protoc-gen-grpc=/usr/local/bin/grpc_cpp_plugin protos/calculator.proto
```

#### Note

The `.pb.h`, `.pb.cc`, `.grpc.pb.h` and `.grpc.pb.cc` files could be generated automatically by the CMake's `add_custom_command` command and should not be included in the actual project. See also: [Sample_GRPC CMakeLists.txt](src/sample_grpc/CMakeLists.txt), [Calculator CMakeLists.txt](src/calculator/CMakeLists.txt) and [Greetings CMakeLists.txt](src/greetings/CMakeLists.txt).

### How to write a client

#### Instruction
1. Create a channel.
2. Create a stub.
3. Make a unary RPC.
4. Check returned status and response.

#### Example: [Sample client](src/sample_grpc/sample_grpc_client.cpp)
#### Example: [Calculator client](src/calculator/calculator_client.cpp)
#### Example: [Greetings client](src/greetings/greetings_client.cpp)

#### Note

### How to write a server

#### Instruction
1. Implement the service interface.
2. Build a server exporting the service.

#### Example: [Sample server](src/sample_grpc/sample_grpc_server.cpp)

#### Example: [Calculator server](src/calculator/calculator_server.cpp)

#### Example: [Greetings server](src/greetings/greetings_server.cpp)

#### Note

### How to write an async client

#### Instruction

1. Create a channel.
2. Create a stub.
3. Initiate the RPC and bind it to a `CompletionQueue`.
4. Request to update the response and the call status upon completion of the RPC with a unique tag.
5. Wait for the completion queue to return the next tag.

#### Example: [Sample async client](sample_grpc/sample_grpc_async_client.cpp)

#### Example: [Calculator async client](calculator/calculator_async_client.cpp)

#### Note

### How to write an async server

#### Instruction

1. Build a server exporting the async service.
2. Request an RPC with a unique tag.
3. Wait for the completion queue to return the next tag.

#### Example: [Sample async server](sample_grpc/sample_grpc_async_server.cpp)

#### Example: [Calculator async server](calculator/calculator_async_server.cpp)

#### Note

## Usages

### Build Docker Image

```bash
$ docker build -f docker/grpc.Dockerfile --build-arg GPRC_VERSION=1.44.0 --build-arg NUM_JOBS=8 --tag grpc-examples:1.44.0 .
```

To build for different gRPC versions and use different number of CPU threads, please pass values accordingly.


### Run Docker Container

Docker container should be started for the gRPC server and the gRPC client.

```bash
$ docker container run --network host --rm --mount src=`pwd`,target=/root/examples,type=bind -it grpc-examples:1.44.0 /bin/bash
```

### Build Examples

```bash
$ cmake -B build
$ cmake --build build --config Release --parallel 8
```

All the executable files would be generated in `build` directory.

### Run Examples

#### Calculator

In one terminal, we start the gRPC server.

```bash
$ ./build/src/calculator/calculator_server
Server listening on 0.0.0.0:2510
```

In another terminal, we start the gRPC client.

```bash
$ ./build/src/calculator/calculator_client 
25 + 10 = 35
25 - 10 = 15
25 * 10 = 250
25 / 10 = 2
25 % 10 = 5
```

#### Greetings Server

In one terminal, we start the gRPC server.

```bash
$ ./build/src/greetings/greetings_server 
Server listening on 0.0.0.0:50051
```

In another terminal, we start the gRPC client.

```bash
$ ./build/src/greetings/greetings_client 
Please enter your user name:
harendra
gRPC returned: 
Hello harendra!
Please enter your user name:
hsingh
gRPC returned: 
Hello hsingh!
Please enter your user name:
```

#### Hello World

In one terminal, we start the gRPC server.

```bash
$ ./build/src/sample_grpc/sample_grpc_server 
Server listening on 0.0.0.0:2510
```

In another terminal, we start the gRPC client.

```bash
$ ./build/src/sample_grpc/sample_grpc_client 
Client received: Hello world
```

### References
