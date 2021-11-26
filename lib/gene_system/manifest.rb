require 'jsonnet'
require 'hashie'

module GeneSystem
  # Manifest is an in memory representation of a manifest file
  class Manifest
    DEFAULT_QUERY = ->(_step) { return true }

    class <<self
      ##
      # Creates a [GeneSystem::Manifest] from a manifest json so long as the
      # manifest is compatible with this version of GeneSystem.
      #
      # @param [String] file_path
      #
      def new_from_file(file_path)
        manifest = Jsonnet.evaluate(
          File.read(file_path)
        )

        if missing_required?(manifest)
          raise 'manifest is missing required attributes name, '\
          'version and/or metadata'
        end

        if incompatible?(manifest)
          raise 'provided manifest is invalid or incompatible with '\
          'this version of gene_system'
        end

        new(
          file_path,
          manifest
        )
      end

      ##
      # Determines whether there are missing
      # attributes in given manifest.
      #
      # Manifests require name, version and
      # metadata attributes.
      #
      # If these are not present in the given manifest
      # then this method returns true, indicating
      # that the manifest does not have all required
      # attributes and is therefore not valid.
      #
      # If they are present, then false will be returned
      # indicating that the manifest has required
      # attributes
      #
      # @param [GeneSystem::Manifest] manifest
      #
      # @return [Boolean]
      #
      def missing_required?(manifest)
        return true unless manifest['name']
        return true unless manifest['version']
        return true unless manifest['metadata']

        false
      end

      ##
      # Incompatible returns true if the current manifest is not compatible
      # with this version of GeneSystem.
      #
      # A manifest is not compatible if it was created with a version greater
      # than this the installed version.
      #
      # @param [Hash] manifest
      #
      # @return [Boolean]
      #
      def incompatible?(manifest)
        manifest_version = manifest['metadata']['gene_system']['version']
        manifest_version > GeneSystem::VERSION
      rescue NoMethodError
        true
      end
    end

    # list of supported platforms
    SUPPORTED_PLATFORMS = %w[macos debian].freeze

    def initialize(path, data)
      @path = path
      @data = Hashie::Mash.new(data)
      @steps = GeneSystem::Step.load_steps(@data.steps)
    end

    ##
    # Manifest name and version getter
    #
    # @return [String]
    #
    def name_and_version
      "#{name} v#{version}"
    end

    ##
    # Manifest name getter
    #
    # @return [String]
    #
    def name
      @data.name
    end

    ##
    # Manifest version getter
    #
    # @return [String]
    #
    def version
      @data.version
    end

    ##
    # Manifest metadata getter
    #
    # @return[String]
    #
    def metadata
      @data.metadata
    end

    ##
    # Platform metadata getter
    #
    # Prints a warning when the platform is not recognized
    #
    # @return[String]
    #
    def platform
      platform = @data.platform

      unless SUPPORTED_PLATFORMS.include?(platform)
        CLI.print_warning("WARN: unrecognized platform: #{@data.platform}")
      end

      platform
    end

    ##
    # Returns a steps as a step collection
    #
    # @return [GeneSystem::StepCollection]
    #
    def steps
      GeneSystem::StepCollection.new(@steps)
    end

    ##
    # Returns manifest information and variables
    #
    # @return [Hashie::Mash]
    #
    def variables
      Hashie::Mash.new(
        'manifest' => {
          'name' => name,
          'version' => version,
          'metadata' => metadata
        }
      )
    end
  end
end
