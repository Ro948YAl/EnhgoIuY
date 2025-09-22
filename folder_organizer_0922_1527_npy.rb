# 代码生成时间: 2025-09-22 15:27:13
# 文件夹结构整理器
# 使用RUBY和CUBA框架

require 'cuba'
require 'find'
require 'fileutils'

# 定义一个异常类，用于处理文件夹整理过程中的错误
class FolderOrganizerError < StandardError; end

class FolderOrganizer
  # 初始化方法，设置源目录和目标目录
  def initialize(source_dir, target_dir)
    @source_dir = source_dir
    @target_dir = target_dir
  end

  # 开始整理文件夹结构
  def organize
    raise FolderOrganizerError, '源目录不存在' unless Dir.exist?(@source_dir)
    raise FolderOrganizerError, '目标目录不存在' unless Dir.exist?(@target_dir)

    # 查找源目录下的所有文件
    Find.find(@source_dir) do |path|
      next if File.dirname(path) == @source_dir || File.directory?(path)

      # 构建目标路径
      relative_path = path.sub(@source_dir, '')
      target_path = File.join(@target_dir, relative_path)

      # 创建目标路径的目录结构
      FileUtils.mkdir_p(File.dirname(target_path))

      # 移动文件到目标路径
      FileUtils.mv(path, target_path)
    end
  rescue => e
    puts "发生错误: #{e.message}"
  end
end

# CUBA框架的路由设置
Cuba.define do
  on get do
    on "organize" do
      # 从请求参数中获取源目录和目标目录
      source_dir = params['source_dir']
      target_dir = params['target_dir']

      # 创建文件夹结构整理器实例
      organizer = FolderOrganizer.new(source_dir, target_dir)

      # 开始整理文件夹结构
      status 200
      res.write("正在整理文件夹结构...
")
      organizer.organize
      res.write("文件夹结构整理完成。
")
    end
  end
end

# 运行CUBA服务器
run Cuba
