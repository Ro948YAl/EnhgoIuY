# 代码生成时间: 2025-09-10 13:32:11
# theme_switcher.rb

# 引入Cuba框架
require 'cuba'

# 定义Cuba应用程序
Cuba.define do

  # 路由到主题切换页面
  on get do
    on "theme" do
      # 调用主题切换的处理方法
      run ThemeSwitcherHandler.new
    end
  end

  # 重定向到首页
  on get do
    on root do
      res.redirect("/theme")
    end
  end
end

# 定义主题切换处理器
class ThemeSwitcherHandler
  # 初始化方法，接收请求和响应对象
  def initialize(req, res=nil)
    @req = req
    @res = res
  end

  # 处理主题切换的逻辑
  def call
    # 获取请求参数中的主题名称
    theme_name = @req.params['theme']

    # 错误处理：如果主题名称无效或未提供，则返回错误信息
    if theme_name.nil? || !['light', 'dark'].include?(theme_name)
      @res['Content-Type'] = 'text/plain'
      @res.body = "Error: Invalid theme name. Please choose 'light' or 'dark'."
      return
    end

    # 存储主题信息到会话
    session = @req.env['rack.session']
    session[:theme] = theme_name

    # 渲染主题切换成功的响应
    @res['Content-Type'] = 'text/plain'
    @res.body = "Theme switched to #{theme_name} successfully."
  end
end

# 运行Cuba应用程序
Rack::Handler::WEBrick.run Cuba
