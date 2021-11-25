require 'spec_helper'

RSpec.describe GeneSystem::CLI do
  subject { described_class.new }

  describe '#version' do
    let(:version) { double(GeneSystem::Commands::PrintVersion) }
    let(:options) { double }

    before do
      allow(subject).to receive(:options).and_return(options)
      allow(GeneSystem::Commands::PrintVersion)
        .to receive(:new)
        .and_return(version)

      allow(version).to receive(:run)
      subject.version
    end

    it 'creates a new version command' do
      expect(GeneSystem::Commands::PrintVersion)
        .to have_received(:new)
        .with(options)
    end

    it 'calls run' do
      expect(version).to have_received(:run)
    end
  end

  describe '#new' do
    let(:new) { double(GeneSystem::Commands::CreateManifest) }
    let(:options) { double }

    before do
      allow(subject).to receive(:options).and_return(options)
      allow(GeneSystem::Commands::CreateManifest)
        .to receive(:new)
        .and_return(new)

      allow(new).to receive(:run)
      subject.new
    end

    it 'creates a new new command' do
      expect(GeneSystem::Commands::CreateManifest)
        .to have_received(:new)
        .with(options)
    end

    it 'calls run' do
      expect(new).to have_received(:run)
    end
  end

  describe '#install' do
    let(:install) { double(GeneSystem::Commands::InstallManifest) }
    let(:options) { double }

    before do
      allow(subject).to receive(:options).and_return(options)
      allow(GeneSystem::Commands::InstallManifest)
        .to receive(:new)
        .and_return(install)

      allow(install).to receive(:run)
      subject.install
    end

    it 'creates a new install command' do
      expect(GeneSystem::Commands::InstallManifest)
        .to have_received(:new)
        .with(options)
    end

    it 'calls run' do
      expect(install).to have_received(:run)
    end
  end

  describe '#remove' do
    let(:remove) { double(GeneSystem::Commands::RemoveManifest) }
    let(:options) { double }

    before do
      allow(subject).to receive(:options).and_return(options)
      allow(GeneSystem::Commands::RemoveManifest)
        .to receive(:new)
        .and_return(remove)

      allow(remove).to receive(:run)
      subject.remove
    end

    it 'creates a new remove command' do
      expect(GeneSystem::Commands::RemoveManifest)
        .to have_received(:new)
        .with(options)
    end

    it 'calls run' do
      expect(remove).to have_received(:run)
    end
  end
end
