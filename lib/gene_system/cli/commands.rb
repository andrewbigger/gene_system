module GeneSystem
  module CLI
    # CLI Actions
    module Commands
      ##
      # Creates a new, blank manifest with at the specified
      # destination with the given name
      #
      # It is expected that the first argument provided to the
      # command will be the name of the manifest. If this is not
      # provided then a RuntimeError will be raised.
      #
      # @param dest [String]
      # @param args [Array]
      #
      def self.new(dest, args = [])
        manifest_name = args.shift

        raise 'no manifest name provided' unless manifest_name

        GeneSystem::Generators.render_empty_manifest(
          manifest_name,
          dest
        )
      end

      ##
      # Applies a manifest to the host system
      #
      # @param dest [String]
      # @param args [Array]
      #
      def self.apply(dest, args = [])
        manifest_file_name = args.shift

        raise 'no manifest name provided' unless manifest_file_name

        manifest_path = File.join(dest, manifest_file_name)

        unless File.exist?(manifest_path)
          raise "cannot find manifest at #{manifest_path}"
        end

        manifest = GeneSystem::Manifest.new_from_file(manifest_path)
        puts manifest
      end
    end
  end
end
