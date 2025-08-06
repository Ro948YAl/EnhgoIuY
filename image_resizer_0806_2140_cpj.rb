# 代码生成时间: 2025-08-06 21:40:09
# image_resizer.rb

require 'cuba'
require 'mini_magick'
require 'pathname'

# 图片尺寸批量调整器
class ImageResizer
  # 构造函数，接收源文件夹和目标文件夹路径
# 添加错误处理
  def initialize(source_folder, target_folder)
    @source_folder = Pathname.new(source_folder)
    @target_folder = Pathname.new(target_folder)
  end

  # 调整图片尺寸
  def resize_images
# 优化算法效率
    # 遍历源文件夹中的所有图片文件
    @source_folder.each_child do |child|
      next unless child.file? && child.extname == '.jpg'

      # 获取目标文件路径
      target_file = @target_folder + child.basename('.jpg').to_s + '_resized.jpg'

      begin
        # 使用MiniMagick调整图片尺寸
# 扩展功能模块
        image = MiniMagick::Image.open(child)
        image.resize '300x300'
        image.write target_file
        puts "Resized: #{target_file}"
      rescue => e
        # 错误处理
# 扩展功能模块
        puts "Error resizing image #{child}: #{e.message}"
      end
    end
  end
end

# Cuba 路由设置
Cuba.define do
  # 定义根路径，启动图片尺寸调整器
  on root do
# 优化算法效率
    # 检查命令行参数
    if ARGV.empty?
# 扩展功能模块
      puts 'Usage: ruby image_resizer.rb <source_folder> <target_folder>'
      throw :halt, 1
    end

    source_folder = ARGV[0]
    target_folder = ARGV[1]

    # 创建并运行图片尺寸调整器
    resizer = ImageResizer.new(source_folder, target_folder)
    resizer.resize_images
# 扩展功能模块
  end
end
