require 'hashie'

module GeneSystem
  # Step is an in memory representation of a manifest step
  class Step
    class <<self
      ##
      # Loads steps from an array of steps
      #
      # @param [Array] steps
      #
      # @return [Array]
      #
      def load_steps(steps)
        steps.map do |data|
          new(data)
        end
      end
    end

    attr_reader :tags

    def initialize(data)
      @data = Hashie::Mash.new(data)
      @tags = []
      @tags = @data.tags.split("\s") if @data.tags
    end

    ##
    # Step name getter
    #
    # @return [String]
    #
    def name
      @data.name
    end

    ##
    # Step execution instructions getter
    #
    # @return [Hash]
    #
    def exe
      @data.exe
    end

    ##
    # Installation instructions getter
    #
    # @return [Array]
    #
    def install
      exe.install
    end

    ##
    # Removal instructions getter
    #
    # @return [Array]
    #
    def remove
      exe.remove
    end
  end
end
