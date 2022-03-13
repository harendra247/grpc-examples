get_filename_component(sample_grpc_proto "../../protos/sample_grpc.proto" ABSOLUTE)
get_filename_component(sample_grpc_proto_path "${sample_grpc_proto}" PATH)

set(sample_grpc_proto_sources "${CMAKE_CURRENT_BINARY_DIR}/sample_grpc.pb.cc")
set(sample_grpc_proto_headers "${CMAKE_CURRENT_BINARY_DIR}/sample_grpc.pb.h")
set(sample_grpc_sources "${CMAKE_CURRENT_BINARY_DIR}/sample_grpc.grpc.pb.cc")
set(sample_grpc_headers "${CMAKE_CURRENT_BINARY_DIR}/sample_grpc.grpc.pb.h")
add_custom_command(
        OUTPUT "${sample_grpc_proto_sources}" "${sample_grpc_proto_headers}" "${sample_grpc_sources}" "${sample_grpc_headers}"
        COMMAND ${_PROTOBUF_PROTOC}
        ARGS --grpc_out "${CMAKE_CURRENT_BINARY_DIR}" --cpp_out "${CMAKE_CURRENT_BINARY_DIR}"
        -I "${sample_grpc_proto_path}"
        --plugin=protoc-gen-grpc="${_GRPC_CPP_PLUGIN_EXECUTABLE}"
        "${sample_grpc_proto}"
        DEPENDS "${sample_grpc_proto}")

include_directories("${CMAKE_CURRENT_BINARY_DIR}")

add_library(sample_grpc_proto
        ${sample_grpc_proto_sources}
        ${sample_grpc_proto_headers}
        ${sample_grpc_sources}
        ${sample_grpc_headers})
target_link_libraries(sample_grpc_proto
        ${_PROTOBUF_LIBPROTOBUF}
        ${_REFLECTION}
        ${_GRPC_GRPCPP})

foreach(_target sample_grpc_client sample_grpc_server sample_grpc_async_client sample_grpc_async_server)
    add_executable(${_target} "${_target}.cpp")
    target_link_libraries(${_target}
            sample_grpc_proto
            ${_PROTOBUF_LIBPROTOBUF}
            ${_REFLECTION}
            ${_GRPC_GRPCPP})
endforeach()
