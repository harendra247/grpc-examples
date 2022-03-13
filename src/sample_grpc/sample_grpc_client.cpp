#include "sample_grpc.grpc.pb.h"
#include <grpc++/grpc++.h>
#include <memory>
#include <iostream>

using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;
using sample_grpc::Request;
using sample_grpc::Response;
using sample_grpc::SampleGRPCService;

class SampleClient {
public:
    SampleClient(std::shared_ptr<Channel> channel) : _stub{SampleGRPCService::NewStub(channel)} {}

    std::string Method(const std::string& request_field) {
        // Prepare request
        Request request;
        request.set_request_field(request_field);

        // Send request
        Response response;
        ClientContext context;
        Status status;
        status = _stub->Method(&context, request, &response);

        // Handle response
        if (status.ok()) {
            return response.response_field();
        } else {
            std::cerr << status.error_code() << ": " << status.error_message() << std::endl;
            return "RPC failed";
        }
    }

private:
    std::unique_ptr<SampleGRPCService::Stub> _stub;
};

int main(int argc, char** argv) {
    std::string server_address{"localhost:2510"};
    SampleClient client{grpc::CreateChannel(server_address, grpc::InsecureChannelCredentials())};
    std::string request_field{"world"};
    std::string response_field = client.Method(request_field);
    std::cout << "Client received: " << response_field << std::endl;
    return 0;
}
