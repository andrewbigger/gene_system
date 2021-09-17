module GeneSystem
  module Commands
    # Gem version command
    class PrintVersion
      def initialize(options)
        @options = options
      end

      ##
      # Prints version to STDOUT
      #
      def run
        puts(GeneSystem::VERSION)
      end
    end
  end
end
