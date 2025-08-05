# 代码生成时间: 2025-08-06 06:00:38
# ExcelGenerator is a service class for generating Excel files.
class ExcelGenerator
  include Roo::Excel# Use Roo::Excel to handle Excel operations

  # Initialize a new instance of ExcelGenerator
  #
  # @param filename [String] The name of the Excel file to be generated
  # @param data [Array] The data to be written into the Excel file
  def initialize(filename, data)
    @filename = filename
    @data = data
  end

  # Generate an Excel file with the provided data
  #
  # @return [String] The path to the generated Excel file
  def generate
    file = File.new(@filename, 'w')
    spreadsheet = Excelx.new(file)
    sheet = spreadsheet.add_sheet('Sheet 1')

    @data.each_with_index do |row, index|
      sheet.add_row(row, index)
    end

    spreadsheet.close
    file.close
    return @filename
  rescue => e
    puts "An error occurred while generating the Excel file: #{e.message}"
  end
end

# Define the root route for the Cuba app
Cuba.define do
  on get do
    on 'generate_excel' do
      # Handle the GET request to generate Excel file
      #
      # Read the parameters from the query string
      filename = params['filename'] || 'default_excel.xlsx'
      data = params['data'] || []
      
      # Generate the Excel file
      begin
        generator = ExcelGenerator.new(filename, data)
        excel_path = generator.generate
        puts "Excel file generated at: #{excel_path}"
        res.write "Excel file generated successfully."
      rescue => e
        res.write "Failed to generate Excel file: #{e.message}"
      end
    end
  end
end

# Start the Cuba app
Rack::Handler.get(:puma).run(Cuba) { |cuba| cuba.run! }