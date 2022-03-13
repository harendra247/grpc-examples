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
