require 'tty-table'

module GeneSystem
  module Commands
    # Describe Manifest
    class DescribeManifest
      ##
      # Default name of gene system manifest
      #
      DEFAULT_MANIFEST_NAME = 'manifest.json'.freeze

      def initialize(options)
        @options = options
        @prompt = TTY::Prompt.new
        @manifest = nil
      end

      STEP_HEADER = ['CMD'].freeze

      ##
      # Prints manifest summary to STDOUT
      #
      def run
        manifest_path = @options.manifest
        manifest_path ||= @prompt.ask(
          'Please enter the name of the manifest',
          default: DEFAULT_MANIFEST_NAME
        )

        @manifest = GeneSystem::Manifest.new_from_file(manifest_path)

        puts <<~DESCRIPTION
          NAME: #{@manifest.name}
          VERSION: #{@manifest.version}
        DESCRIPTION

        puts 'INSTALL STEPS:'

        @manifest.steps.each do |step|
          print_step_commands(step, 'install', install_commands(step))
        end

        puts 'REMOVE STEPS:'
        @manifest.steps.each do |step|
          print_step_commands(step, 'remove', remove_commands(step))
        end
      end

      private

      def print_step_commands(step, direction, cmds)
        puts <<~STEP

          \s\s+ #{step.name} UNLESS #{send("#{direction}_skip_command", step)}

          \s\s\s\s #{cmds}

        STEP
      end

      def install_skip_command(step)
        return '' unless step.install.skip

        step.install.skip
      end

      def install_commands(step)
        return '# no op' unless step.install.cmd.any?

        step.install&.cmd&.join("\n\s\s\s\s ")
      end

      def remove_skip_command(step)
        return '' unless step.remove.skip

        step.remove.skip
      end

      def remove_commands(step)
        return 'no op' unless step.remove&.cmd&.any?

        step.remove&.cmd
      end
    end
  end
end
