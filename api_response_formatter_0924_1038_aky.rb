# 代码生成时间: 2025-09-24 10:38:10
# api_response_formatter.rb
# This module provides a set of utility methods for formatting API responses in a Ruby application using CUBA framework.

module ApiResponseFormatter
  # Formats a successful API response with a given status message and data
  #
  # @param [String] status_message The status message to be included in the response
  # @param [Object] data The data to be included in the response
  # @return [Hash] A formatted API response hash
  def self.success(status_message, data)
    {
      "status" => "success",
      "message" => status_message,
      "data" => data
    }
  end

  # Formats an error API response with a given error code, status message, and error details
  #
  # @param [String] error_code The error code to be included in the response
  # @param [String] status_message The status message to be included in the response
  # @param [String] error_details Additional error details to be included in the response
  # @return [Hash] A formatted API error response hash
  def self.error(error_code, status_message, error_details)
    {
      "status" => "error",
      "error_code" => error_code,
      "message" => status_message,
      "error_details" => error_details
    }
  end

  # Catches and formats exceptions that occur during API processing
  #
  # @param [Exception] e The exception that occurred
  # @return [Hash] A formatted API error response hash
  def self.handle_exception(e)
    # Log the exception details for debugging purposes
    puts "Exception occurred: #{e.message}"
    puts e.backtrace.join("
")

    # Format the error response with a generic error code and message
    error("GENERIC_ERROR", "An unexpected error occurred.", e.message)
  end

  # Private: Checks if the provided response is a successful API response
  #
  # @param [Hash] response The response to check
  # @return [Boolean] True if the response is a successful API response, false otherwise
  private_class_method
  def self.is_success?(response)
    response && response["status"] == "success"
  end
end