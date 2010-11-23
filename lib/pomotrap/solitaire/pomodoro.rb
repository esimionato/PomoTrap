module Pomotrap

  module Solitaire

    class Pomodoro
      
      ICON = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'img', 'tomato.jpeg'))

      def initialize(activity_description)
        @description = activity_description
        puts "new pomodoro initialized"
      end
      
      def call(job)
        puts "call called :p"
        scheduler = Rufus::Scheduler::PlainScheduler.start_new(:thread_name => 'pomodoroscheduler')
        
        scheduler.in '10s' do
          puts 'pomodoro ended'
        end
        scheduler.in '11s' do
          scheduler.stop
        end
        # HAH! :P
        scheduler.at DateTime.now do
          puts "Try to focus for 25 minutes now.".red_on_white
        end
        scheduler.join
        
        puts ""
        
      end

    end

  end

end
