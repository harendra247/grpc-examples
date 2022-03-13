#include "sample_grpc.grpc.pb.h"
#include <grpc++/grpc++.h>
#include <memory>
#include <iostream>

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;
using sample_grpc::Request;
using sample_grpc::Response;
using sample_grpc::SampleGRPCService;

class SampleGRPCServiceImpl final : public SampleGRPCService::Service {
    Status Method(ServerContext* context, const Request* request, Response* response) override {
        response->set_response_field("Hello " + request->request_field());
        return Status::OK;
    }
};

void RunServer() {
    std::string server_address{"localhost:2510"};
    SampleGRPCServiceImpl service;

    // Build server
    ServerBuilder builder;
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);
    std::unique_ptr<Server> server{builder.BuildAndStart()};

    // Run server
    std::cout << "Server listening on " << server_address << std::endl;
    server->Wait();
}

int main(int argc, char** argv) {
    RunServer();
    return 0;
}
