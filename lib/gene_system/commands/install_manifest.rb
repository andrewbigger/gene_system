module GeneSystem
  module Commands
    # Install manifest command
    class InstallManifest
      include GeneSystem::Commands::Helpers

      ##
      # Default name of gene system manifest
      #
      DEFAULT_MANIFEST_NAME = 'manifest.json'.freeze

      def initialize(options)
        @options = options
        @prompt = TTY::Prompt.new
        @manifest = nil
      end

      ##
      # Applies install instructions from a manifest
      # to the host system.
      #
      def run
        manifest_path = @options.manifest
        manifest_path ||= @prompt.ask(
          'Please enter the path to the configuration manifest',
          default: DEFAULT_MANIFEST_NAME
        )

        @manifest = GeneSystem::Manifest.new_from_file(manifest_path)
        platform = GeneSystem::Platform.new

        puts("INSTALL #{@manifest.name_and_version}")

        steps.each do |step|
          next if skip?(:install, step, platform)

          vars = ask(step.install.prompts)

          platform.execute_commands(
            step.install.cmd,
            vars
          )
        end

        puts(
          "✔ Manifest #{@manifest.name_and_version} successfully installed"
        )
      end
    end
  end
end
