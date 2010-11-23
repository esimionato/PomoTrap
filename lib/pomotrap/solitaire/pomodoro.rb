module Pomotrap

  module Solitaire

    class Pomodoro

      def initialize(activity_description)
        @description = activity_description
        puts "new pomodoro initialized"
      end
      
      def call(job)
        debugger
        puts "call called :p"
      end

    end

  end

end
