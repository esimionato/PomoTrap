require 'fastercsv'
require 'csv-mapper'
require 'colored'
require 'rufus/scheduler'

module Pomotrap
  APPLICATION_NAME = "Pomotrap"

  module Solitaire

    class FileOperations

      def self.create_to_do_today
        FileUtils.mkdir_p(base_today_path)
        FileUtils.touch(csv_file_path)
        FileUtils.touch(interruptions_file)
      end

      def self.to_do_today_exist?
        File.exist?(csv_file_path)
      end

      def self.create_activity(description)
        description = description.gsub(',', '') # TODO fixme there would be a lot more to do?
        FileUtils.mkdir_p(File.join(base_today_path, 'activities')) # TODO fixme make a more generic method
        FileUtils.touch(File.join(base_today_path, 'activities', "#{description}.csv"))
        FileUtils.mkdir_p(File.join(base_today_path, 'pomodoro')) # TODO fixme make a more generic method
        FileUtils.touch(File.join(base_today_path, 'pomodoro', "#{description}.csv"))
        todays = FasterCSV.read(csv_file_path)
        FasterCSV.open(csv_file_path, "w") do |csv|
          todays.each do |today| 
            csv << today
          end
          csv << description
        end
      end

      def self.update_task(description, data = {}) 


      end

      def self.fire_pomodoro(activity)
        currents = FasterCSV.read(pomodoro_file(activity))
        FasterCSV.open(pomodoro_file(activity), "w") do |csv|
          currents.each do |current|
            csv << current
          end
          csv << "#{activity},#{DateTime.now}"
        end
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

        puts ""
      end
      
      def self.notify_about(message)
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

      def self.register_interruption(reason)
        header = 'description,datetime'
        currents = FasterCSV.read(interruptions_file)
        FasterCSV.open(interruptions_file, "w") do |csv|
          currents.each do |current|
            csv << header
            csv << current
          end
          csv << reason + ',' + DateTime.now.to_s
        end

      end

      def self.retrieve_activities
        activities = FasterCSV.read(csv_file_path)
        acts = Array.new
        activities.each do |activity|
          description = activity[0].split(',')[0]
          pomodoros = FasterCSV.read(pomodoro_file(description))
          interruptions = FasterCSV.read(interruptions_file)
          values = { "description" =>  activity[0].split(',')[0], "pomodoros" => pomodoros.size, "interruptions" => interruptions.size }
          acts.push values
        end
        acts
      end

      def self.activity_file(description)
        File.join(base_today_path, 'activities', "#{description}.csv")
      end

      def self.pomodoro_file(description)
        File.join(base_today_path, 'pomodoro', "#{description}.csv")
      end

      def self.csv_file_path
        File.join(base_today_path, 'todotoday.csv')
      end

      def self.interruptions_file
        File.join(base_today_path, 'interruptions.csv')
      end

      def self.base_today_path
        File.join(ENV['HOME'], Pomotrap::APPLICATION_NAME.downcase, Date.today.year.to_s, Date::MONTHNAMES[Date.today.month].downcase, Date.today.mday.to_s)
      end

    end

  end

end