require 'spec_helper'

RSpec.describe GeneSystem::StepCollection do
  let(:step_name) { 'step-name' }
  let(:step) do
    double(GeneSystem::Step, name: step_name)
  end

  let(:steps) { [step, step] }
  subject { described_class.new(steps) }

  describe 'DEFAULT_QUERY' do
    it 'returns true' do
      expect(
        described_class::DEFAULT_QUERY.call(step)
      ).to be true
    end
  end

  describe 'STEP_INCLUDE_ANY_TAG' do
    let(:tag) { 'foo' }

    context 'when query does not include tags' do
      it 'raises runtime error' do
        expect do
          described_class::STEP_INCLUDE_ANY_TAG.call(step)
        end.to raise_error(
          RuntimeError,
          'query must include tags'
        )
      end
    end

    context 'when step has tag' do
      let(:step) do
        double(GeneSystem::Step, tags: [tag, 'bar', 'biz'])
      end

      before do
        @result = described_class::STEP_INCLUDE_ANY_TAG.call(
          step,
          tags: [tag]
        )
      end

      it 'returns true' do
        expect(@result).to be true
      end
    end

    context 'when step does not have tag' do
      let(:step) do
        double(GeneSystem::Step, tags: %w[bar biz])
      end

      before do
        @result = described_class::STEP_INCLUDE_ANY_TAG.call(
          step,
          tags: [tag]
        )
      end

      it 'returns false' do
        expect(@result).to be false
      end
    end
  end

  describe 'STEP_EXCLUDE_ANY_TAG' do
    let(:tag) { 'foo' }

    context 'when query does not include tags' do
      it 'raises runtime error' do
        expect do
          described_class::STEP_EXCLUDE_ANY_TAG.call(step)
        end.to raise_error(
          RuntimeError,
          'query must include tags'
        )
      end
    end

    context 'when step has tag' do
      let(:step) do
        double(GeneSystem::Step, tags: [tag, 'bar', 'biz'])
      end

      before do
        @result = described_class::STEP_EXCLUDE_ANY_TAG.call(
          step,
          tags: [tag]
        )
      end

      it 'returns false' do
        expect(@result).to be false
      end
    end

    context 'when step does not have tag' do
      let(:step) do
        double(GeneSystem::Step, tags: %w[bar biz])
      end

      before do
        @result = described_class::STEP_EXCLUDE_ANY_TAG.call(
          step,
          tags: [tag]
        )
      end

      it 'returns true' do
        expect(@result).to be true
      end
    end
  end

  describe '#count' do
    it 'returns step count' do
      expect(subject.count).to eq steps.count
    end
  end

  describe '#map' do
    before do
      @result = subject.map(&:name)
    end

    it 'maps step names' do
      expect(@result).to eq [step_name, step_name]
    end
  end

  describe '#each' do
    before do
      @result = []

      subject.each do |step|
        @result << step.name
      end
    end

    it 'can iterate through steps' do
      expect(@result).to eq [step_name, step_name]
    end
  end

  describe '#filter' do
    let(:matching_step) do
      double(GeneSystem::Step, tags: %w[target foo])
    end

    let(:steps) do
      [step, step, matching_step]
    end

    before do
      allow(matching_step)
        .to receive(:tags)
        .and_return(%w[target foo])

      allow(step)
        .to receive(:tags)
        .and_return([])

      @steps = subject
               .filter(
                 described_class::STEP_INCLUDE_ANY_TAG,
                 tags: ['target']
               )
    end

    it 'returns a step collection' do
      expect(@steps).to be_a(GeneSystem::StepCollection)
    end

    it 'only returns matching step' do
      expect(@steps.steps.count).to be 1
      expect(@steps.steps.first).to eq matching_step
    end
  end

  describe '#merge' do
    let(:another_collection) { described_class.new(steps) }

    before do
      @merged = subject.merge(another_collection)
    end

    it 'returns a new step collection' do
      expect(@merged).not_to eq subject
      expect(@merged).not_to eq another_collection
    end

    it 'is a union of the 2 collections' do
      expect(@merged.count).to eq 2 * subject.count
    end
  end
end
