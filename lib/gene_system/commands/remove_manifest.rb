module GeneSystem
  module Commands
    # Remove manifest command
    class RemoveManifest
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
      # Applies remove instructions from a manifest
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

        puts("REMOVE #{@manifest.name_and_version}")

        steps.each do |step|
          next if skip?(:remove, step, platform)

          vars = ask(step.remove.prompts)

          platform.execute_commands(
            step.remove.cmd,
            vars
          )
        end

        puts(
          "✔ Manifest #{@manifest.name_and_version} successfully removed"
        )
      end
    end
  end
end
