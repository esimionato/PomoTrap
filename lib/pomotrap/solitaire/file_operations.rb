module Pomotrap
  APPLICATION_NAME = "Pomotrap"

  module Solitaire

    class FileOperations

      def self.create_to_do_today
        FileUtils.mkdir_p(base_today_path)
        FileUtils.touch(csv_file_path)
        FileUtils.touch(interruptions_file) # (?)
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
        
        CSV.append(csv_file_path, description)
        
      end

      def self.update_task(description, data = {}) 


      end

      def self.fire_pomodoro(activity)
        
        CSV.append(pomodoro_file(activity), "#{activity},#{DateTime.now}")
        Pomotrap::Solitaire::Pomodoro.new
        puts ""
      end
      


      def self.register_interruption(reason)
        CSV.append(interruptions_file, reason + ',' + DateTime.now.to_s)
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