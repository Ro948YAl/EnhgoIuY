# 代码生成时间: 2025-09-14 20:34:03
# URLValidator module responsible for checking the validity of URLs
module URLValidator
  # Validates the given URL
  #
  # @param url [String] the URL to be validated
  # @return [Boolean] true if the URL is valid, false otherwise
  def self.validate_url(url)
    uri = URI.parse(url)
    return false unless valid_scheme?(uri)
    return false unless valid_host?(uri)
    return false unless valid_port?(uri)
    return false unless http_response_ok?(uri)
    true
  rescue URI::InvalidURIError
    false
  end

  private
  # Checks if the URI scheme is valid (http or https)
  def self.valid_scheme?(uri)
    %w[http https].include?(uri.scheme)
  end

  # Checks if the URI host is valid
  def self.valid_host?(uri)
    !uri.host.nil? && !uri.host.empty?
  end

  # Checks if the URI port is valid
  def self.valid_port?(uri)
    !uri.port.nil? && (uri.port == 80 || uri.port == 443)
  end

  # Checks if the HTTP response code is OK (200)
  def self.http_response_ok?(uri)
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      response.is_a?(Net::HTTPSuccess)
    end
  rescue StandardError
    false
  end
end

# Cuba app setup for URL validation
Cuba.define do
  # Define the root route to trigger URL validation
  on get do
    on "validate_url" do
      # Extract the URL from the query parameters
      url = params['url']
      # Validate the URL using the URLValidator module
      if URLValidator.validate_url(url)
        res.write "URL is valid"
      else
        res.status = 400
        res.write "Invalid URL"
      end
    end
  end
end

# Run the Cuba app on port 8080
run Cuba.app