require 'tty-prompt'
require 'gene_system'

COMMANDS = File.join(__dir__, 'commands', '*.rb')

Dir[COMMANDS].sort.each do |file|
  require file
end

module GeneSystem
  # Gem command module
  module Commands
  end
end
