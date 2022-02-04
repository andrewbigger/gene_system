require 'tty-prompt'
require 'gene_system'

GENE_SYSTEM_CLI_COMMANDS = File.join(__dir__, 'commands', '*.rb')

Dir[GENE_SYSTEM_CLI_COMMANDS].sort.each do |file|
  require file
end

module GeneSystem
  # Gem command module
  module Commands
  end
end
