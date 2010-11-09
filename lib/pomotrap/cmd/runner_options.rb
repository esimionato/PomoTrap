require "optparse"

module Pomotrap

  module Cmd

    class RunnerOptions < Hash
      attr_reader :opts

      def initialize(args)
        super()

        @opts = OptionParser.new do |o|
          o.banner = "Usage: #{File.basename($0)} [options]"
          
          o.on( '-n', '--now', "Retrieve To Do Today sheet." ) do |n|
            self[:now] = true
          end
          
          o.on('-a', '--add [DESCRIPTION]', 'Add a new Task to To Do Today sheet') do |task|
            self[:task] = task || "a task"
          end

          o.on('-t', '--task [NUMBER]', 'Start pomodoro on prioritized Task') do |task|
            self[:pomodoro] = task || 1
          end

          o.on_tail('-h', '--help', 'Display this help and exit') do
            puts @opts
            exit
          end

        end

        # puts @opts.inspect

        begin
          @opts.parse!(args)
        rescue OptionParser::InvalidOption => e
          self[:invalid_argument] = e.message
        end
      end
      
    end
    
  end
  
end
