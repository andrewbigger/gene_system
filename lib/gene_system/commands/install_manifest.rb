module GeneSystem
  module Commands
    # Install manifest command
    class InstallManifest
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

        @manifest.steps.each do |step|
          next if skip?(step, platform)

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

      private

      ##
      # Asks for user input when given prompts
      #
      # @param prompts [Array]
      #
      # @return Hashie::Mash
      #
      def ask(prompts = [])
        answers = @manifest.variables
        return answers if prompts.nil? || prompts.empty?

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
        return false if step.install.skip.nil?

        platform.execute_command(
          step.install.skip
        ).zero?
      end
    end
  end
end
