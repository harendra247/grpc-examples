cmake_minimum_required(VERSION 3.15)
project(grpc-examples)

# define library version (update: apparently you can also do it in project()!)
set(MY_LIBRARY_VERSION_MAJOR 1 CACHE STRING "major version" FORCE)
set(MY_LIBRARY_VERSION_MINOR 0 CACHE STRING "minor version" FORCE)
set(MY_LIBRARY_VERSION ${MY_LIBRARY_VERSION_MAJOR}.${MY_LIBRARY_VERSION_MINOR} CACHE STRING "version" FORCE)

# some options
option(MY_LIBRARY_USE_FANCY_NEW_CLASS "whether or not to use fancy new class" ON)
option(MY_LIBRARY_DEBUG_MODE "whether or not debug mode is activated" OFF)

set(CMAKE_CXX_STANDARD 17)

find_package(Threads)

set(protobuf_MODULE_COMPATIBLE TRUE)
find_package(Protobuf CONFIG REQUIRED)
message(STATUS "Using protobuf ${Protobuf_VERSION}")

set(_PROTOBUF_LIBPROTOBUF protobuf::libprotobuf)
set(_REFLECTION gRPC::grpc++_reflection)
if(CMAKE_CROSSCOMPILING)
    find_program(_PROTOBUF_PROTOC protoc)
else()
    set(_PROTOBUF_PROTOC $<TARGET_FILE:protobuf::protoc>)
endif()

find_package(gRPC CONFIG REQUIRED)
message(STATUS "Using gRPC ${gRPC_VERSION}")

set(_GRPC_GRPCPP gRPC::grpc++)
if(CMAKE_CROSSCOMPILING)
    find_program(_GRPC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin)
else()
    set(_GRPC_CPP_PLUGIN_EXECUTABLE $<TARGET_FILE:gRPC::grpc_cpp_plugin>)
endif()


#set(include_dest "include/my_library-${MY_LIBRARY_VERSION}")
#set(main_lib_dest "lib/my_library-${MY_LIBRARY_VERSION}")
set(main_bin_dest "bin/")

add_subdirectory(sample_grpc)

add_subdirectory(calculator)

add_subdirectory(greetings)
