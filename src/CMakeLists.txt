# Minimum CMake required
cmake_minimum_required(VERSION 3.15)

###project(gRPC_CPP_Examples VERSION 0.0.1 LANGUAGES CXX)
project(gRPC_Examples_CPP VERSION ${MY_LIBRARY_VERSION} LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_BUILD_TYPE RelWithDebInfo)

# Set examples list
###add_subdirectory(sample_grpc)
###
###add_subdirectory(calculator)
###
###add_subdirectory(greetings)
set(examples greetings calculator sample_grpc)

foreach(example ${examples})
    add_subdirectory(${example})
endforeach()
