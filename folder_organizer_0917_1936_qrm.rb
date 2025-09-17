# 代码生成时间: 2025-09-17 19:36:54
# folder_organizer.rb
#
# This script is a simple folder organizer using RUBY.
# It helps to structure the directories in a specified path.

require 'find'
require 'fileutils'

# FolderOrganizer class
class FolderOrganizer
  # Initialize with a root directory path
  def initialize(root_path)
    @root_path = root_path
  end

  # Organize the directories within the root path
  def organize
    return unless Dir.exist?(@root_path)

    # Find all files and directories within the root path
    Find.find(@root_path) do |path|
      # Skip directories and handle files only
      next if File.directory?(path)

      # Define the file types and their respective target directories
      target_dir = determine_target_directory(path)
      next unless target_dir

      # Move file to the target directory
      move_file_to_directory(path, target_dir)
    end
  rescue => e
    puts "An error occurred: #{e.message}"
  end

  # Determine the target directory for a given file
  def determine_target_directory(file_path)
    # Define file extensions and their corresponding directories
    extensions = {
      '.jpg' => 'Images',
      '.png' => 'Images',
      '.txt' => 'Documents',
      '.pdf' => 'Documents',
      '.mp3' => 'Music',
      '.mp4' => 'Videos'
    }

    # Get the file extension and find the corresponding directory
    file_extension = File.extname(file_path).downcase
    extensions[file_extension]
  end

  # Move a file to a specific directory
  def move_file_to_directory(file_path, target_dir)
    target_path = File.join(target_dir, File.basename(file_path))
    FileUtils.mv(file_path, target_path)
    puts "Moved #{file_path} to #{target_dir}"
  rescue => e
    puts "Failed to move #{file_path}: #{e.message}"
  end
end

# Example usage
if __FILE__ == $0
  root_path = '/path/to/your/directory' # Replace with your directory path
  organizer = FolderOrganizer.new(root_path)
  organizer.organize
end