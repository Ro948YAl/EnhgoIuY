# 代码生成时间: 2025-08-01 09:57:45
#!/usr/bin/env ruby

# database_migration_tool.rb
# A simple database migration tool using RUBY and CUBA framework

require 'cuba'
require 'cuba/plugins/middleware/flash'
require 'sequel'
require 'logger'
require 'pathname'
require 'yaml'

# Configuration
CONFIG = YAML.load_file('config/database.yml')

# Database connection setup
DB = Sequel.connect(CONFIG['development'])

# Logger setup
logger = Logger.new(STDOUT)
logger.level = Logger::INFO

# Migration directory path
MIGRATION_DIR = Pathname.new('./migrations')

class Migration
  attr_reader :version, :name, :path

  def initialize(version, name)
    @version = version
    @name = name
    @path = File.join(MIGRATION_DIR, "#{version}_#{name}.rb")
  end

  def exists?
    File.exist?(path)
  end

  def run(direction = :up)
    raise "Migration file does not exist" unless exists?
    require path
    migration_class = Object.const_get(name.split('_').map(&:capitalize).join)
    migration_class.new.run(direction)
  end
end

# Cuba app setup
Cuba.define do
  # Flash middleware for displaying messages
  use Cuba::Flash
  
  on get do
    on "migrate" do
      status 200
      if MIGRATION_DIR.exist?
        migrations = Dir.glob(MIGRATION_DIR + "*.rb\)
          .sort_by { |file| File.basename(file).split('_').first }
        
        begin
          # Load and run all migrations
          migrations.each do |migration_file|
            version, name = File.basename(migration_file).split('_').first, File.basename(migration_file).split('_')[1..-1].join('_')
            migration = Migration.new(version, name)
            migration.run(:up)
          end
          flash[:success] = "All migrations completed successfully."
        rescue => e
          flash[:error] = "Migration failed: #{e.message}"
        end
      else
        flash[:error] = "Migration directory does not exist."
      end
      res.write "Migrations have been processed."
    end
  end
end

# Start the Cuba app
run Cuba.app