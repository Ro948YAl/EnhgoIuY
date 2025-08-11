# 代码生成时间: 2025-08-11 09:58:30
#!/usr/bin/env ruby

require 'cuba'
require 'rack/protection'
require 'htmlentities'

# XssProtection is a Cuba app that demonstrates XSS protection.
class XssProtection < Cuba
  # Use Rack::Protection for general protection against common attacks.
  use Rack::Protection::XSS, :method => [:block, :replace], :content_type => 'text/html'

  # Define the root route which will sanitize and display user input.
  define do
    # Route to handle GET requests to the root path.
    on get do
      # Display a form for user input.
      res.write "<html><body>
      <form action='/process' method='post'>
        <label for='user_input'>Enter your text:</label>
        <input type='text' id='user_input' name='user_input'>
        <button type='submit'>Submit</button>
      </form>
      </body></html>"
    end

    # Route to handle POST requests to '/process'.
    on post, 'process' do
      # Get the user input from the params.
      user_input = params['user_input']
      # Sanitize the input to prevent XSS attacks.
      sanitized_input = sanitize_input(user_input)
      # Display the sanitized input back to the user.
      res.write "<html><body>
      Your sanitized input: <strong>" + sanitized_input + "</strong>
      </body></html>"
    end
  end
end

# Sanitize the input to prevent XSS attacks.
# This method uses the HTMLEntities gem to encode HTML entities.
def sanitize_input(input)
  # Check if the input is nil or empty.
  return '' if input.nil? || input.empty?
  # Encode HTML entities in the input.
  HTMLEntities.new.encode(input)
end

# Run the Cuba app.
run XssProtection