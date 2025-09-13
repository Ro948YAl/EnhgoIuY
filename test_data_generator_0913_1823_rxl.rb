# 代码生成时间: 2025-09-13 18:23:53
# TestDataGenerator is a Cuba app that generates test data
class TestDataGenerator < Cuba
  # Define the root route
  define do
    on get do
      res.write generate_test_data
    end
  end

  # Method to generate test data
  def generate_test_data
    # Array to hold generated data
    test_data = []
    
    # Define the number of test data entries to generate
    num_entries = 5
    
    # Generate test data entries
    num_entries.times do |i|
      # Use Faker to generate fake data
      fake_data = {
        "id" => i + 1,
        "name" => Faker::Name.name,
        "email" => Faker::Internet.email,
        "address" => Faker::Address.street_address
      }
      
      # Add the generated data to the test data array
      test_data << fake_data
    end
    
    # Return the test data as JSON
    JSON.pretty_generate(test_data)
  end
end

# Run the Cuba application
run TestDataGenerator