require 'fastercsv'

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
        todays = FasterCSV.read(csv_file_path)
        debugger
        FasterCSV.open(csv_file_path, "w") do |csv|
          csv << ['description', 'pomodoros', 'interruptions']
          csv << [description, '0', '0']
          # ...
        end
        
              
        puts "foobar"
        
      end

      def self.update_task(description, data = {}) 

      end

      def self.read
        task_lines = []
        i = 0
        begin
          FasterCSV.foreach(csv_file_path) do |row|
            description, firstname, iq = *row
            i += 1
          end

        rescue

        end
        task_lines
      end


      def self.csv_file_path(today = Date.today)
        File.join(ENV['HOME'], Pomotrap::APPLICATION_NAME.downcase, today.year.to_s, Date::MONTHNAMES[today.month].downcase, today.mday.to_s, 'todotoday.csv')
      end

    end


  end

end