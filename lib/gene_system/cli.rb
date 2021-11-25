require 'thor'
require 'gene_system'
require 'gene_system/commands'

require 'hashie'

module GeneSystem
  # Command line interface helpers and actions
  class CLI < Thor
    package_name 'GeneSystem'

    desc 'version', 'Print gem version'

    def version
      cmd = GeneSystem::Commands::PrintVersion.new(options)
      cmd.run
    end

    desc 'new', 'Create new manifest'

    method_option(
      :out,
      type: :string,
      desc: 'Path to folder for manifest'
    )

    method_option(
      :name,
      type: :string,
      desc: 'Name of manifest (i.e. manifest.json)'
    )

    def new
      cmd = GeneSystem::Commands::CreateManifest.new(options)
      cmd.run
    end

    desc 'install', 'Applies install instructions from given manifest'

    method_option(
      :manifest,
      type: :string,
      desc: 'Path to manifest (i.e. manifest.json)'
    )

    def install
      cmd = GeneSystem::Commands::InstallManifest.new(options)
      cmd.run
    end

    desc 'remove', 'Applies remove instructions from given manifest'

    method_option(
      :manifest,
      type: :string,
      desc: 'Path to manifest (i.e. manifest.json)'
    )

    def remove
      cmd = GeneSystem::Commands::RemoveManifest.new(options)
      cmd.run
    end
  end
end
