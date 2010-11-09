module Pomotrap

  module Cmd

    class Runner

      def self.run(args)
        settings = YAML::load_file("/Users/kayaman/pomotrap.yml") #TODO fixme

        cli = Pomotrap::Client.new(settings[:token], settings[:debug])
        options = ::Pomotrap::Cmd::RunnerOptions.new(args)

        if options[:now]
          puts "To Do Today : #{Date.today.strftime("%d/%m/%Y")}" 
          tasks = cli.display_stubbed["tasks"]
          
          prettify_tasks(tasks)

          puts "work in progress......"
        elsif options[:task]  
          puts options[:task].inspect
          cli.create_task(options[:task])
          puts "work in progress.."
        elsif options[:pomodoro]
          puts "Prioritizing task #{options[:pomodoro]}"
          cli.fire_pomodoro(options[:pomodoro])
          puts "work in progress.."
        else
          puts options.opts
        end
      end
      
      TASK_FIELDS = %w(priority id description pomodoros interruptions)

      def self.prettify_tasks(values)
        values = [values] unless values.is_a?(Array)
        values.each do |value|
          # value["interruptions"] = 1 
        end
        values.view(:class => :table, :fields => TASK_FIELDS)
      end

    end

  end

end
