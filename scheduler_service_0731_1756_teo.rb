# 代码生成时间: 2025-07-31 17:56:51
#!/usr/bin/env ruby

# scheduler_service.rb
# A simple scheduler service using Ruby and CUBA framework.

require 'cuba'
require 'rufus-scheduler'

# SchedulerApp class
class SchedulerApp < Cuba
  # Configuration for Rufus scheduler
  config do
    # Define the scheduler
    set :scheduler, Rufus::Scheduler.new
  end

  # Root route to show the current jobs
  define do
    on get do
      res.write("Current jobs: " + settings.scheduler.jobs.map(&:to_s).join(
"))
    end
  end

  # Helper method to schedule a job
  helpers do
    def schedule_job(job_name, interval, &block)
      settings.scheduler.every(interval) do
        begin
          block.call
        rescue => e
          puts "Error in job #{job_name}: #{e.message}"
        end
      end
    end
  end

  # Route to schedule a job
  on "schedule" do
    on post do
      req = request
      job_name = req.params['job_name']
      interval = req.params['interval']
      if job_name && interval
        schedule_job(job_name, interval.to_i) do
          # Call the job logic here
          puts "Executing job: #{job_name}"
        end
        res.write("Job '#{job_name}' scheduled every #{interval} seconds.")
      else
        res.write("Job name and interval are required.")
        res.status = 400
      end
    end
  end
end

# Run the scheduler service
run SchedulerApp