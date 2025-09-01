# 代码生成时间: 2025-09-01 09:23:15
# image_resizer.rb
# This script is designed to adjust the size of multiple images using the RUBY and CUBA framework.

require 'cuba'
require 'mini_magick'
require 'fileutils'
require 'logger'

# Create a new Cuba application
Cuba.define do
  # Logger instance
  log = Logger.new(STDOUT)
  set :root, File.dirname(__FILE__)

  # Configuration for image resizing
  IMAGE_SIZES = {
    small: '100x100',
    medium: '200x200',
    large: '300x300'
  }

  # Root endpoint to upload images
  on get do
    # Render a simple form to upload images
    res.write <<-HTML
      <html>
        <body>
          <form action="/upload" method="post" enctype="multipart/form-data">
            <input type="file" name="image" multiple />
            <input type="submit" value="Upload" />
          </form>
        </body>
      </html>
    HTML
  end

  # Endpoint to handle image uploads and resizing
  on post, 'upload' do
    # Check if the uploaded file is an image
    image = params[:image]
    if image && image[:filename]
      # Extract file extension
      extension = File.extname(image[:filename])
      # Define the output directory for resized images
      output_dir = File.join(settings.root, 'resized_images')
      FileUtils.mkdir_p(output_dir)
      
      # Process each size and resize the image
      IMAGE_SIZES.each do |size, dimensions|
        resized_image_path = File.join(output_dir, "#{File.basename(image[:filename], extension)}_#{size}#{extension}")
        
        # Use MiniMagick to resize the image
        image = MiniMagick::Image.new(image[:tempfile].path)
        image.resize(dimensions)
        image.write(resized_image_path)
        log.info("Resized image saved to #{resized_image_path}")
      end
      
      # Redirect to the root endpoint with a success message
      res.redirect("/?status=success")
    else
      # Handle the case where no image was uploaded
      res.redirect("/?status=error")
    end
  end

  # Endpoint to handle success and error messages
  on get, params do |status|
    if status == 'success'
      res.write "Images uploaded and resized successfully!"
    elsif status == 'error'
      res.write "Error: No image uploaded."
    else
      res.redirect('/')
    end
  end
end