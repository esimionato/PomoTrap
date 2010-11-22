module Pomotrap

  module Solitaire

    class PomodoroTechnique
      
      def initialize
        Pomotrap::Solitaire::FileOperations.create_to_do_today unless Pomotrap::Solitaire::FileOperations.to_do_today_exist?
        
      end
      
      def find_or_create_to_do_today
        sheet = Pomotrap::Solitaire::FileOperations.retrieve_to_do_today

      end

      def create_task(description)
        Pomotrap::Solitaire::FileOperations.create_task(description)
        activities
      end


      def activities
        
        
      end


    end

  end

end

