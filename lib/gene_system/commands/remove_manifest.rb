module GeneSystem
  module Commands
    # Remove manifest command
    class RemoveManifest
      ##
      # Default name of gene system manifest
      #
      DEFAULT_MANIFEST_NAME = 'manifest.json'.freeze

      def initialize(options)
        @options = options
        @prompt = TTY::Prompt.new
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

        manifest = GeneSystem::Manifest.new_from_file(manifest_path)
        platform = GeneSystem::Platform.new

        puts("REMOVE #{manifest.name} v#{manifest.version}")

        manifest.steps.each do |step|
          next if skip?(step, platform)

          vars = ask(step.remove.prompts)

          platform.execute_commands(
            step.remove.cmd,
            vars
          )
        end

        puts("✔ Manifest #{manifest.name} successfully removed")
      end

      private

      ##
      # Asks for user input when given prompts
      #
      # @param prompts [Array]
      #
      # @return Hashie::Mash
      #
      def ask(prompts = [])
        answers = Hashie::Mash.new
        return answers if prompts.nil?

        prompts.each do |prompt|
          resp = @prompt.ask(prompt.prompt)
          answers[prompt.var] = resp
        end

        answers
      end

      ##
      # Determines whether to skip a step
      #
      # @param [GeneSystem::Step] step
      # @param [GeneSystem::Platform] platform
      #
      # @return [Boolean]
      #
      def skip?(step, platform)
        return false if step.remove.skip.nil?

        platform.execute_command(
          step.remove.skip
        ).zero?
      end
    end
  end
end
