require 'json'

module GeneSystem
  # Generators create empty projects for the gene_system gem
  module Generators
    # Default sample step
    DEFAULT_STEP = {
      'name' => 'say hello',
      'exe' => {
        'install' => {
          'cmd' => [
            'echo hello'
          ]
        },
        'remove' => {
          'cmd' => [
            'echo goodbye'
          ]
        }
      },
      'tags' => 'example step'
    }.freeze

    # Function that creates a named, empty manifest
    TEMPLATE_MANIFEST = lambda do |name|
      {
        'name' => name,
        'version' => '0.0.1',
        'metadata' => {
          'gene_system' => {
            'version' => GeneSystem::VERSION
          }
        },
        'steps' => [
          DEFAULT_STEP
        ]
      }
    end

    class <<self
      ##
      # Renders empty manifest at specified path
      #
      # @param [String] name
      # @param [String] path
      #
      def render_empty_manifest(name, path)
        manifest_path = File.join(path, "#{name}.json")

        File.open(manifest_path, 'w') do |f|
          f.write(
            TEMPLATE_MANIFEST.call(name).to_json
          )
        end
      end
    end
  end
end
