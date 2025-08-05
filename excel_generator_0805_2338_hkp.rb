# 代码生成时间: 2025-08-05 23:38:16
# Excel表格自动生成器
class ExcelGenerator
  attr_accessor :workbook, :sheet
  
  # 初始化方法，接受文件名和工作表名称
  def initialize(filename, sheet_name = 'Sheet1')
    @workbook = Roo::Excelx.new(filename)
    @sheet = @workbook.sheet(sheet_name)
  end

  # 添加数据到工作表
  def add_data(row, data)
    raise 'Row must be an integer' unless row.is_a?(Integer)
    raise 'Data must be an array' unless data.is_a?(Array)
    
    data.each_with_index do |value, col|
      @sheet.cell(row, col + 1, value)
    end
  end

  # 保存工作簿
  def save
    @workbook.save
  end

  # 读取单元格数据
  def get_cell(row, col)
    @sheet.cell(row, col)
  end
end

# Cuba路由设置
Cuba.define do
  on get: '/generate' do
    # 提取请求参数
    params = request.params
    filename = params['filename']
    sheet_name = params['sheet_name']
    data = params['data']
    
    # 实例化Excel生成器
    generator = ExcelGenerator.new(filename, sheet_name)
    
    begin
      # 将数据添加到工作表
      data.each do |row_data|
        generator.add_data(data.index(row_data) + 2, row_data) # +2 因为第一行为标题行，第二行为表头
      end
      
      # 保存工作簿
      generator.save
      response.write("Excel file generated successfully.")
    rescue => e
      # 错误处理
      response.write("Error generating Excel file: #{e.message}")
    end
  end
end
