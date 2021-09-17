require 'spec_helper'

RSpec.describe GeneSystem::Commands::PrintVersion do
  let(:options) { double }

  subject { described_class.new(options) }

  describe '#run' do
    before do
      allow(subject).to receive(:puts)
      subject.run
    end

    it 'prints version' do
      expect(subject)
        .to have_received(:puts)
        .with(GeneSystem::VERSION)
    end
  end
end
