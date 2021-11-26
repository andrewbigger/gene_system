require 'spec_helper'

RSpec.describe GeneSystem::Commands::Helpers do
  let(:manifest) { double(GeneSystem::Manifest) }
  let(:step) { double(GeneSystem::Step) }
  let(:steps) { [step, step] }
  let(:options) { Hashie::Mash.new }

  subject { GeneSystem::Commands::RemoveManifest.new(options) }

  before do
    subject.instance_variable_set(:@manifest, manifest)
    allow(manifest).to receive(:steps).and_return(steps)
  end

  describe '#steps' do
    context 'when there are no filters' do
      it 'returns all manifest steps' do
        expect(subject.steps).to eq steps
      end
    end

    context 'when there are filters' do
      let(:options) do
        Hashie::Mash.new(exclude_tags: %w[bags of tags])
      end

      before do
        allow(steps).to receive(:filter)
        subject.steps
      end

      it 'filters steps' do
        expect(steps)
          .to have_received(:filter)
          .with(
            GeneSystem::StepCollection::STEP_EXCLUDE_ANY_TAG,
            tags: %w[bags of tags]
          )
      end
    end
  end

  describe '#filters' do
    context 'when include_tags is enabled' do
      let(:options) do
        Hashie::Mash.new(include_tags: %w[bags of tags])
      end

      it 'has STEP_INCLUDE_ANY_TAG function and tags' do
        expect(subject.filters).to eq(
          GeneSystem::StepCollection::STEP_INCLUDE_ANY_TAG => %w[bags of tags]
        )
      end
    end

    context 'when exclude_tags is enabled' do
      let(:options) do
        Hashie::Mash.new(exclude_tags: %w[bags of tags])
      end

      it 'has STEP_EXCLUDE_ANY_TAG function and tags' do
        expect(subject.filters).to eq(
          GeneSystem::StepCollection::STEP_EXCLUDE_ANY_TAG => %w[bags of tags]
        )
      end
    end
  end

  describe '#filters?' do
    context 'when neither include_tags or exclude_tags' do
      it 'returns false' do
        expect(subject.filters?).to be false
      end
    end

    context 'when include_tags is enabled' do
      let(:options) do
        Hashie::Mash.new(include_tags: 'true')
      end

      it 'returns true' do
        expect(subject.filters?).to be true
      end
    end

    context 'when exclude_tags is enabled' do
      let(:options) do
        Hashie::Mash.new(exclude_tags: 'true')
      end

      it 'returns true' do
        expect(subject.filters?).to be true
      end
    end
  end
end
