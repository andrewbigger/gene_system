require 'spec_helper'

RSpec.describe GeneSystem::Generators do
  describe '::TEMPLATE_MANIFEST' do
    let(:name) { 'my_dev_setup' }

    before do
      @manifest = Hashie::Mash.new(
        described_class::TEMPLATE_MANIFEST.call(name)
      )
    end

    it 'has expected name' do
      expect(@manifest.name).to eq name
    end

    it 'has expected version' do
      expect(@manifest.version).to eq '0.0.1'
    end

    it 'has gene system metadata' do
      expect(@manifest.metadata.gene_system).not_to be nil
    end

    it 'renders app version into gene system metadata' do
      expect(@manifest.metadata.gene_system.version)
        .to eq GeneSystem::VERSION
    end

    it 'has default step' do
      expect(@manifest.steps.first).to eq described_class::DEFAULT_STEP
    end
  end

  describe '.render_empty_manifest' do
    let(:name) { 'new_dev_setup' }
    let(:path) { 'path/to/manifests' }

    let(:manifest_path) { File.join(path, "#{name}.json") }
    let(:manifest_file) { double }

    let(:manifest) { 'manifest' }

    before do
      allow(File).to receive(:open)
        .with(manifest_path, 'w')
        .and_yield(manifest_file)
      allow(manifest_file).to receive(:write)

      allow(described_class::TEMPLATE_MANIFEST)
        .to receive(:call).and_return(manifest)

      described_class.render_empty_manifest(
        name,
        path
      )
    end

    it 'renders blank manifest' do
      expect(manifest_file)
        .to have_received(:write)
        .with("\"#{manifest}\"")
    end
  end
end
