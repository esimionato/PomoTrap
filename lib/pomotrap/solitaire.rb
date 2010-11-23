module Pomotrap

  module Solitaire

    class PomodoroTechnique
      
      def initialize
        Pomotrap::Solitaire::FileOperations.create_to_do_today unless Pomotrap::Solitaire::FileOperations.to_do_today_exist?
      end
      
      def find_or_create_to_do_today
        sheet = Pomotrap::Solitaire::FileOperations.retrieve_to_do_today
      end

      def create_activity(description)
        Pomotrap::Solitaire::FileOperations.create_activity(description)
      end
      
      def fire_pomodoro(priority)
        Pomotrap::Solitaire::FileOperations.fire_pomodoro(priority)
      end

      def activities
        # [["ds123dsdsd", "0", "0"], ["456abcdef", "0", "0"], ["dsds789dsd", "0", "0"]]
        activities = Pomotrap::Solitaire::FileOperations.retrieve_activities
        activities
      end


    end

  end

end

