module Pomotrap

  module Cmd

    class InterruptionsRunner

      def self.run(args)
        options = Pomotrap::Cmd::InterruptionsOptions.new(args)
        if options[:reason]  
          Pomotrap::Solitaire::FileOperations.register_interruption(options[:reason])
          debugger
          puts ""
        else
          puts options.opts
        end
      end

    

    end

  end

end
