require 'thor'
require 'gene_system/commands'

require 'hashie'

module GeneSystem
  # Command line interface helpers and actions
  class CLI < Thor
    package_name 'GeneSystem'

    desc 'version', 'Print gem version'

    def version
      cmd = GeneSystem::Commands::Version.new(options)
      cmd.run
    end
  end
end
