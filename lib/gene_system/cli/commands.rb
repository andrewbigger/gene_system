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
    end
  end
end
