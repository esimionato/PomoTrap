require 'fastercsv'
require 'csv-mapper'
require 'rufus/scheduler'

module Pomotrap
  APPLICATION_NAME = "Pomotrap"

  module Solitaire

    class FileOperations

      def self.create_to_do_today
        FileUtils.mkdir_p(base_today_path)
        FileUtils.touch(csv_file_path)
      end

      def self.to_do_today_exist?
        File.exist?(csv_file_path)
      end

      def self.retrieve_to_do_today(today= Date.today)
        arr = Pomotrap::Solitaire::FileOperations.read
      end

      def self.create_task(description)
        # ~/2010/november/22/activities/description.csv
        description = description.gsub(',', '') # TODO fixme there would be a lot more to do?
        FileUtils.mkdir_p(File.join(base_today_path, 'activities')) # TODO fixme make a more generic method
        FileUtils.touch(File.join(base_today_path, 'activities', "#{description}.csv"))
        # ~/2010/november/22/pomodoro/description.csv # Got it??? :P
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
          csv << "activity #{DateTime.now}"
        end
        pomodoro = Pomotrap::Solitaire::Pomodoro.new(activity)

        scheduler = Rufus::Scheduler::PlainScheduler.start_new(:thread_name => 'pomodoroscheduler')
        
        scheduler.in '10s' do
          puts 'pomodoro ended'
        end
        # and so on...
        scheduler.at DateTime.now do
          puts 'Try to focus for 25 minutes now.'
        end
        scheduler.join
        return
        puts "yeah"
      end

      def self.retrieve_activities
        activities = FasterCSV.read(csv_file_path)
        acts = Array.new
        activities.each do |activity|
          description = activity[0].split(',')[0]
          pomodoros = FasterCSV.read(pomodoro_file(description))
          values = { "description" =>  activity[0].split(',')[0], "pomodoros" => pomodoros.size }
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

      def self.base_today_path
        File.join(ENV['HOME'], Pomotrap::APPLICATION_NAME.downcase, Date.today.year.to_s, Date::MONTHNAMES[Date.today.month].downcase, Date.today.mday.to_s)
      end

    end


  end

end