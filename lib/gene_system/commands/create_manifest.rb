module GeneSystem
  module Commands
    # Create manifest command
    class CreateManifest
      ##
      # Default name of gene system manifest
      #
      DEFAULT_MANIFEST_NAME = 'manifest.json'
      
      def initialize(options)
        @options = options
        @prompt = TTY::Prompt.new
      end

      ##
      # Creates a new, blank manifest with at the specified
      # destination with the specified name.
      #
      # If the options are not provided the user will be prompted
      # for the manifest name and location.
      #
      # If the output location is not a directory then a 
      # RuntimeError will be raised.
      #
      # When successfully rendered a success message will be
      # printed to STDOUT.
      #
      def run
        manifest_name = @options.name
        manifest_name ||= @prompt.ask(
          'Please enter the name of the manifest',
          default: DEFAULT_MANIFEST_NAME
        )

        output_location = @options.out
        output_location ||= @prompt.ask(
          'Please specify output location',
          default: Dir.pwd
        )

        unless File.directory?(output_location)
          raise 'output location must be a folder'
        end

        GeneSystem::Generators.render_empty_manifest(
          manifest_name,
          output_location
        )

        puts "✔ manifest successfully created in #{output_location}"
      end
    end
  end
end
