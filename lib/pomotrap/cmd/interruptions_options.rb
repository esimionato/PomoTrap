require "optparse"

module Pomotrap

  module Cmd

    class InterruptionsOptions < Hash
      attr_reader :opts

      def initialize(args)
        super()

        @opts = OptionParser.new do |o|
          o.banner = "Usage: #{File.basename($0)} [options]"
          
          o.on('-r', '--reason DESCRIPTION', 'Register interruption due...') do |reason|
            self[:reason] = reason
          end
          
          o.on('-a', '--activity DESCRIPTION', 'Register interruption on activity...') do |activity|
            self[:activity] = activity
          end

          o.on_tail('-h', '--help', 'Display this help and exit') do
            puts @opts
            exit
          end

        end

        begin
          @opts.parse!(args)
        rescue OptionParser::InvalidOption => e
          self[:invalid_argument] = e.message
        end
      end
      
    end
    
  end
  
end
