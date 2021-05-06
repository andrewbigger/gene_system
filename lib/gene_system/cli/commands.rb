module GeneSystem
  module CLI
    # CLI Actions
    module Commands
      class <<self
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
        def new(args = [])
          manifest_name = args.shift

          raise 'no manifest name provided' unless manifest_name

          GeneSystem::Generators.render_empty_manifest(
            manifest_name,
            Dir.pwd
          )
        end

        ##
        # Applies install instructions from a manifest to the host system
        #
        # @param args [Array]
        #
        def install(args = [])
          manifest = load_manifest(args)
          platform = GeneSystem::Platform.new

          manifest.steps.each do |step|
            next if skip?(step)

            platform.execute_commands(step.install.cmd)
          end

          GeneSystem::CLI.print_message("\nmanifest successfully installed")
        end

        ##
        # Applies remove instructions from a manifest to the host system
        #
        # @param args [Array]
        #
        def remove(args = [])
          manifest = load_manifest(args)
          platform = GeneSystem::Platform.new

          manifest.steps.each do |step|
            platform.execute_commands(step.remove.cmd)
          end

          GeneSystem::CLI.print_message("\nmanifest successfully removed")
        end

        private

        def load_manifest(args)
          manifest_rel = args.shift
          raise 'no manifest path provided' unless manifest_rel

          manifest_path = File.join(Dir.pwd, manifest_rel)

          unless File.exist?(manifest_path)
            raise "cannot find manifest at #{manifest_path}"
          end

          GeneSystem::Manifest.new_from_file(manifest_path)
        end

        def skip?(step)
          return false if step.install.skip.empty?

          platform.execute_command(step.install.skip).zero?
        end
      end
    end
  end
end
