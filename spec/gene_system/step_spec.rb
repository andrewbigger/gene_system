require 'spec_helper'

RSpec.describe GeneSystem::Step do
  let(:name) { 'install stuff' }
  let(:exe) do
    {
      'install' => {
        'cmd' => [
          'do something'
        ]
      },
      'remove' => {
        'cmd' => [
          'do something'
        ]
      }
    }
  end

  let(:tags) { 'tags and stuff' }

  let(:step_data) do
    {
      'name' => name,
      'exe' => exe,
      'tags' => tags
    }
  end

  describe '.load_steps' do
    let(:steps_data) do
      [
        step_data,
        step_data
      ]
    end

    before do
      @steps = described_class.load_steps(steps_data)
    end

    it 'maps step data to steps' do
      expect(@steps.count).to eq steps_data.count
      expect(@steps).to all(
        be_a(GeneSystem::Step)
      )
    end

    context 'when tags are not present' do
      let(:step_data) do
        {
          'name' => name,
          'exe' => exe
        }
      end

      it 'returns empty array when tags are not set' do
        expect(@steps.first.tags).to be_empty
      end
    end
  end

  subject { described_class.new(step_data) }

  describe '#name' do
    it 'returns name' do
      expect(subject.name).to eq name
    end
  end

  describe '#exe' do
    it 'returns execution instructions' do
      expect(subject.exe).to eq exe
    end
  end

  describe '#install' do
    it 'returns install instructions' do
      expect(subject.install).to eq exe['install']
    end
  end

  describe '#remove' do
    it 'returns removal instructions' do
      expect(subject.remove).to eq exe['remove']
    end
  end
end
