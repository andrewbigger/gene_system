require 'gene_system/version'

module GeneSystem
  module Commands
    # Gem version command
    class Version
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
