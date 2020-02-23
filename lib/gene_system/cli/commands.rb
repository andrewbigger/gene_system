module GeneSystem
  module CLI
    # CLI Actions
    module Commands
      ##
      # An example command
      #
      def self.cmd(
        vars = []
      )
        GeneSystem::CLI.logger.info('does something')
        GeneSystem::CLI.logger.info(vars)
      end
    end
  end
end
