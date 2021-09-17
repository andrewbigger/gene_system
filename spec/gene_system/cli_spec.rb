require 'spec_helper'

RSpec.describe GeneSystem::CLI do
  subject { described_class.new }

  describe '#version' do
    let(:version) { double(GeneSystem::Commands::Version) }
    let(:options) { double }

    before do
      allow(subject).to receive(:options).and_return(options)
      allow(GeneSystem::Commands::Version)
        .to receive(:new)
        .and_return(version)

      allow(version).to receive(:run)
      subject.version
    end

    it 'creates a new version command' do
      expect(GeneSystem::Commands::Version)
        .to have_received(:new)
        .with(options)
    end

    it 'calls run' do
      expect(version).to have_received(:run)
    end
  end
end
