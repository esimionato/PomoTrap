require 'ruby-debug'

module Pomotrap

  module Cmd

    class Runner

      def self.run(args)
        settings = YAML::load_file("#{ENV['HOME']}/pomotrap.yml")
        cli = Pomotrap::Client.new(settings["token"], settings["debug"])
        options = ::Pomotrap::Cmd::RunnerOptions.new(args)
        if options[:now]
          display(cli.activities["to_do_today"]["activities"])
        elsif options[:activity]  
          cli.create_task(options[:activity])
          display(cli.activities["to_do_today"]["activities"])
        elsif options[:pomodoro]
          puts "Prioritizing task #{options[:pomodoro]}"
          cli.fire_pomodoro(options[:pomodoro])
          display(cli.activities["to_do_today"]["activities"])
          puts "work in progress.."
        elsif options[:kill]
          puts "Finishing task #{options[:kill]}"
          puts "work in progress.."
        else
          puts options.opts
        end
      end
      
      
      def self.display(activities)
        puts "To Do Today : #{Date.today.strftime("%d/%m/%Y")}"
        prettify_tasks(activities)
      end

      TASK_FIELDS = %w(priority id description pomodoros interruptions) # TODO remove ID column in future

      def self.prettify_tasks(values)
        values = [values] unless values.is_a?(Array)
        values.each do |value|
          value["pomodoros"] =  value["pomodoros"].size
          #value["interruptions"] = 1 
        end
        values.view(:class => :table, :fields => TASK_FIELDS)
      end

    end

  end

end
