module GeneSystem
  module Commands
    # Install/Remove shared helper functions
    module Helpers
      ##
      # Asks for user input when given prompts
      #
      # @param prompts [Array]
      #
      # @return Hashie::Mash
      #
      def ask(prompts = [])
        answers = @manifest.variables
        return answers if prompts.nil? || prompts.empty?

        prompts.each do |prompt|
          resp = @prompt.ask(prompt.prompt)
          answers[prompt.var] = resp
        end

        answers
      end

      ##
      # Determines whether to skip a step
      #
      # @param [GeneSystem::Step] step
      # @param [GeneSystem::Platform] platform
      #
      # @return [Boolean]
      #
      def skip?(direction, step, platform)
        return false if step.send(direction).skip.nil?

        platform.execute_command(
          step.send(direction).skip
        ).zero?
      end

      ##
      # Returns manifest steps that match command
      # options
      #
      # If there are no inclusions or exclusions then
      # all of the steps are returned.
      #
      # If there is an include and/or an exclude filter
      # then the steps are filtered
      #
      # @return [GeneSystem::StepCollection]
      #
      def steps
        steps = @manifest.steps
        return steps unless filters?

        filters.each do |matcher, tags|
          steps = steps.filter(
            matcher, tags: tags
          )
        end

        steps
      end

      ##
      # Constructs a filter function hash
      #
      # The key of the hash is the filter function
      # and the value is the tags to filter by
      #
      # If no inclusions or exclusions are specified
      # then an empty hash is returned
      #
      # @return [Hash]
      #
      def filters
        filters = {}

        filters[StepCollection::STEP_INCLUDE_ANY_TAG] = @options.include_tags if @options.include_tags

        filters[StepCollection::STEP_EXCLUDE_ANY_TAG] = @options.exclude_tags if @options.exclude_tags

        filters
      end

      ##
      # Returns true when an inclusion filter
      # and/or an exclusion filter is specified
      # in command options.
      #
      # Otherwise it returns false
      #
      # @return [Boolean]
      #
      def filters?
        return true if @options.include_tags
        return true if @options.exclude_tags

        false
      end
    end
  end
end
