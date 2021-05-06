require 'os'
require 'ruby-handlebars'

module GeneSystem
  # Platform is a class to handle command execution on host system
  class Platform
    ##
    # Platform constructor. Raises unsupported platform RuntimeError
    # when the host system is not a posix system.
    #
    def initialize
      raise 'unsupported platform' unless posix?
    end

    ##
    # Takes an array of commands for the host and executes each one
    #
    # If command returns non zero status code, then a command failed
    # RuntimeError will be raised
    #
    # @param[Array] cmds
    #
    def execute_commands(cmds = [], vars = {})
      cmds.each do |cmd|
        status = execute_command(cmd, vars)
        raise "command `#{cmd}` failed - returned #{status}" unless status.zero?
      end
    end

    ##
    # Executes a command on a host system and returns command exit code
    #
    # @param [String] cmd
    #
    # @return [Integer]
    def execute_command(cmd, vars = {})
      hbs = Handlebars::Handlebars.new

      pid = Process.spawn(hbs.compile(cmd).call(vars))
      _, status = Process.waitpid2(pid)

      status.exitstatus
    end

    ##
    # Posix platform check. Returns true if host is a posix system
    # i.e. Mac/Linux etc.
    #
    # @return [Boolean]
    #
    def posix?
      OS.posix?
    end
  end
end
