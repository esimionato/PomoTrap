module Pomotrap

  module Solitaire

    class Pomodoro
      
      ICON = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'img', 'tomato.jpeg'))

      def initialize
        puts "new pomodoro initialized"
        scheduler = Rufus::Scheduler::PlainScheduler.start_new(:thread_name => 'pomodoroscheduler')

        scheduler.in '10s' do
          # update CSV with the time the pomodoro ended
          puts 'pomodoro ended'
        end
        scheduler.in '11s' do
          scheduler.stop
        end
        # HAH! :P
        scheduler.at DateTime.now do
          notify_about("pomodoro started!")
          puts "Try to focus for 25 minutes now.".red_on_white
        end
        scheduler.join
        puts "..."
      end
      
      def call(job)
        puts "call called :p"        
      end
      
      def notify_about(message)
        title = 'Pomotrap'
        case RUBY_PLATFORM
        when /linux/
          system "notify-send '#{title}' '#{message}' "
        when /darwin/
          system "growlnotify -t '#{title}' -m '#{message}' --image #{Pomotrap::Client::ICON}"
        when /mswin|mingw|win32/
          # Snarl.show_message title, message, nil
        end
      end

    end

  end

end
