# 代码生成时间: 2025-09-17 09:22:11
#!/usr/bin/env ruby

# api_response_formatter.rb
#
# This script provides a utility to format API responses.
# It follows Ruby best practices for clarity, maintainability, and extensibility.

require 'json'

# ApiResponseFormatter class responsible for formatting API responses.
class ApiResponseFormatter
  # Initializes a new instance of ApiResponseFormatter.
  def initialize
    # Any initialization logic can be placed here.
  end

  # Formats the API response.
  #
  # @param data [Object] The data to be formatted into an API response.
  # @param status [Integer] The HTTP status code for the response.
  # @param message [String] An optional message to include in the response.
  #
  # @return [String] A JSON-formatted API response.
  def format_response(data, status = 200, message = nil)
    # Construct the response hash.
    response = {}
    response['status'] = status
    response['data'] = data
    response['message'] = message if message

    # Handle any errors that might occur during JSON serialization.
    begin
      # Return the formatted response as a JSON string.
      JSON.pretty_generate(response)
    rescue JSON::GeneratorError => e
      # Return a formatted error response in case of serialization failure.
      {
        'status' => 500,
        'message' => 'Internal Server Error',
        'error' => e.message
      }.to_json
    end
  end
end

# Example usage of ApiResponseFormatter.
if __FILE__ == $0
  formatter = ApiResponseFormatter.new

  # Example of a successful response.
  puts formatter.format_response({ 'key' => 'value' }, 200, 'Operation successful.')

  # Example of an error response.
  puts formatter.format_response('Error data', 400, 'Bad Request')
end
