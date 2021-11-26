require 'forwardable'

module GeneSystem
  # Filterable and mergable collection of steps
  class StepCollection
    attr_reader :steps
    extend Forwardable

    ##
    # Default filter will match each step
    #
    DEFAULT_QUERY = lambda do |_step, _query = {}|
      true
    end

    ##
    # Function that returns true if step has
    # any of the provided tags
    #
    # @param [GeneSystem::Step] step
    # @param [Hash] query
    #
    # @return [Boolean]
    #
    STEP_INCLUDE_ANY_TAG = lambda do |step, query = {}|
      raise 'query must include tags' unless query[:tags]&.is_a?(Array)

      results = query[:tags].map do |tag|
        step.tags.include?(tag)
      end

      results.any?(true)
    end

    ##
    # Function that returns true if step does
    # not have any of the provided tags
    #
    # @param [GeneSystem::Step] step
    # @param [Hash] query
    #
    # @return [Boolean]
    #
    STEP_EXCLUDE_ANY_TAG = lambda do |step, query = {}|
      raise 'query must include tags' unless query[:tags]&.is_a?(Array)

      results = query[:tags].map do |tag|
        step.tags.include?(tag)
      end

      results.all?(false)
    end

    def initialize(steps = [])
      @steps = steps
    end

    def_delegators(:@steps, :count, :map, :each)

    ##
    # Filters steps by given matcher function
    #
    # The matcher function must take a step as an
    # argument and return true or false as to whether
    # it should be in the returned collection.
    #
    # @param [Proc] matcher
    # @param [Hash] query
    #
    # @returns [GeneSystem::StepCollection]
    #
    def filter(matcher = DEFAULT_FILTER, query = {})
      GeneSystem::StepCollection.new(
        @steps.select do |step|
          matcher.call(step, query)
        end
      )
    end

    ##
    # Creates a collection which is a union
    # of the given collection and this
    # collection.
    #
    # @param [GeneSystem::StepCollection] collection
    #
    # @return [GeneSystem::StepCollection]
    #
    def merge(collection)
      GeneSystem::StepCollection.new(
        @steps + collection.steps
      )
    end
  end
end
