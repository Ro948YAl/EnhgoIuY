# 代码生成时间: 2025-08-11 04:22:55
# hash_calculator.rb
# This Ruby program is a hash calculator tool using the CUBA framework.
# It calculates the hash value of a given input string.

require 'cuba'
require 'digest'
# 扩展功能模块

class HashCalculator
  # Calculates the hash of the input string using SHA256 algorithm
  def calculate_sha256(input)
    return Digest::SHA256.hexdigest(input)
  end

  # Main method to handle the input and output
  def run(input)
    begin
      hash_value = calculate_sha256(input)
      puts "Hash value: #{hash_value}"
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end

# Define the CUBA app
Cuba.define do
  # Define a route to handle GET requests with an input parameter
  on get, param('calculate') do
    input = params['calculate']
    hash_calculator = HashCalculator.new
    hash_calculator.run(input)
  end
end
# 扩展功能模块

# Run the CUBA app if the script is executed directly
if __FILE__ == $0
  run Cuba
end