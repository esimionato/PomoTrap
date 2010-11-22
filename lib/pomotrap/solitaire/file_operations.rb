require 'fastercsv'
require 'csv-mapper'

module Pomotrap
  APPLICATION_NAME = "Pomotrap"

  module Solitaire

    class FileOperations

      def self.create_to_do_today
        FileUtils.mkdir_p(File.join(ENV['HOME'], Pomotrap::APPLICATION_NAME.downcase, Date.today.year.to_s, Date::MONTHNAMES[Date.today.month].downcase, Date.today.mday.to_s))
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
        description = description.gsub(' ', '') # TODO fixme there would be a lot more to do!
        FileUtils.mkdir_p(File.join(ENV['HOME'], Pomotrap::APPLICATION_NAME.downcase, Date.today.year.to_s, Date::MONTHNAMES[Date.today.month].downcase, Date.today.mday.to_s, 'activities')) # TODO fixme make a more generic method
        FileUtils.touch(File.join(ENV['HOME'], Pomotrap::APPLICATION_NAME.downcase, Date.today.year.to_s, Date::MONTHNAMES[Date.today.month].downcase, Date.today.mday.to_s, 'activities', "#{description}.csv"))
        # ~/2010/november/22/pomodoro/description.csv # Got it??? :P
        FileUtils.mkdir_p(File.join(ENV['HOME'], Pomotrap::APPLICATION_NAME.downcase, Date.today.year.to_s, Date::MONTHNAMES[Date.today.month].downcase, Date.today.mday.to_s, 'pomodoro')) # TODO fixme make a more generic method
        FileUtils.touch(File.join(ENV['HOME'], Pomotrap::APPLICATION_NAME.downcase, Date.today.year.to_s, Date::MONTHNAMES[Date.today.month].downcase, Date.today.mday.to_s, 'pomodoro', "#{description}.csv"))
        todays = FasterCSV.read(csv_file_path)
        FasterCSV.open(csv_file_path, "w") do |csv|
           todays.each do |today| 
             csv << today
           end
           csv << "#{description},0,0"
        end
      end

      def self.update_task(description, data = {}) 

      end
      
      def self.fire_pomodoro(description)
        
        
      end

      def self.retrieve_activities
        activities = FasterCSV.read(csv_file_path)
        acts = Array.new
        activities.each do |activity|
          acts.push "description" =>  activity[0].split(',')[0]
          # acts.push "pomodoros" =>  activity[0].split(',')[1]
          # acts.push "interruptions" =>  activity[0].split(',')[2]
        end
        acts
      end

      def self.csv_file_path(today = Date.today)
        File.join(ENV['HOME'], Pomotrap::APPLICATION_NAME.downcase, today.year.to_s, Date::MONTHNAMES[today.month].downcase, today.mday.to_s, 'todotoday.csv')
      end

    end


  end

end