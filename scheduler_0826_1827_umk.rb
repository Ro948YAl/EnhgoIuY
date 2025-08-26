# 代码生成时间: 2025-08-26 18:27:17
# 定时任务调度器
#
# 这个Ruby程序使用Cuba框架和Rufus-Scheduler库来实现一个简单的定时任务调度器。
# 它允许用户定义定时任务并在指定的时间执行。

require 'cuba'
require 'rufus-scheduler'

# 初始化Cuba应用程序
Cuba.define do
  # 设置定时任务调度器
  scheduler = Rufus::Scheduler.singleton

  # 定义定时任务的路由和执行逻辑
  on get do
    on 'tasks' do
      # 显示当前定义的所有定时任务
      scheduler.jobs.each do |job|
        puts "Job: #{job}, schedule: #{job.schedule}, next time: #{job.next_time}"
      end
    end

    on 'add_task' do |task_name, schedule|
      # 添加一个新的定时任务
      begin
        job = scheduler.every(schedule) do
          # 这里定义任务执行的代码
          puts "Running task: #{task_name}"
        end
        puts "Task added: #{task_name}, schedule: #{schedule}"
      rescue Rufus::Scheduler::InvalidIntervalError => e
        # 错误处理：无效的时间间隔
        puts "Error: #{e.message}"
      end
    end
  end
end

# 启动Cuba应用程序
Cuba.use Rack::CommonLogger
Rack::Server.start(app: Cuba, Port: 3000)
