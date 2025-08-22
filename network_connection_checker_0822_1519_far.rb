# 代码生成时间: 2025-08-22 15:19:31
#!/usr/bin/env ruby
# encoding: UTF-8

# NetworkConnectionChecker is a Ruby script using the CUBA framework to check network connection status.
# It checks if a given host is reachable over the network.

require 'cuba'
require 'socket'
require 'resolv'

# Initialize the Cuba app
Cuba.define do
  # Set the root to a proc that will check the network connection
  on get do
    on "check" do
      # Extract the host parameter from the query string
      host = params['host']
      
      # Error handling for empty host parameter
      unless host
        halt 400, "Missing 'host' parameter"
      end
      
      # Check network connection status
      respond_to do |f|
        f.html do
          begin
            # Check if the host is reachable using TCP socket
            if tcp_socket_reachable?(host)
              "Connection to #{host} is successful!"
            else
              "Connection to #{host} failed. Host is unreachable."
            end
          rescue StandardError => e
            "An error occurred: #{e.message}"
          end
        end
      end
    end
  end
end

def tcp_socket_reachable?(host)
  # Try to connect to the host using TCP socket
  begin
    TCPSocket.new(host, 80).close
    true
  rescue StandardError
    false
  end
end

# Run the Cuba app
run Cuba
