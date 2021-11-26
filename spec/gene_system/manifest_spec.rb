require 'spec_helper'

RSpec.describe GeneSystem::Manifest do
  describe '.new_from_file' do
    let(:file_path) { 'path/to/manifest' }
    let(:exist) { true }
    let(:manifest_name) { 'manifest name' }

    let(:gene_system_meta) do
      {
        'gene_system' => {
          'version' => GeneSystem::VERSION
        }
      }
    end

    let(:version) { '0.0.1' }
    let(:platform) { 'macos' }
    let(:content) do
      {
        'name' => manifest_name,
        'version' => version,
        'platform' => platform,
        'metadata' => gene_system_meta,
        'steps' => []
      }.to_json
    end

    before do
      allow(File).to receive(:exist?).and_return(exist)
      allow(File).to receive(:read).and_return(content)
      allow(Jsonnet).to receive(:evaluate).and_call_original
    end

    context 'when file exists' do
      before do
        @parsed = described_class.new_from_file(file_path)
      end

      it 'reads file' do
        expect(File).to have_received(:read).with(file_path)
      end

      it 'parses json' do
        expect(Jsonnet).to have_received(:evaluate).with(content)
      end

      it 'returns manifest' do
        expect(@parsed).to be_a GeneSystem::Manifest
      end

      it 'has name' do
        expect(@parsed.name).to eq manifest_name
      end

      it 'has version' do
        expect(@parsed.version).to eq version
      end

      it 'has platform' do
        expect(@parsed.platform).to eq platform
      end

      it 'has metadata' do
        expect(@parsed.metadata).to eq gene_system_meta
      end
    end

    context 'when manifest is missing required attributes' do
      let(:content) do
        {
          "steps": []
        }.to_json
      end

      it 'raises missing required error' do
        expect do
          described_class.new_from_file(file_path)
        end.to raise_error(
          RuntimeError,
          'manifest is missing required attributes name, '\
          'version and/or metadata'
        )
      end
    end

    context 'when manifest is from a later version of gene_system' do
      let(:gene_system_meta) do
        {
          'gene_system' => {
            'version' => '999.999.999'
          }
        }
      end

      it 'raises incompatibility error' do
        expect do
          described_class.new_from_file(file_path)
        end.to raise_error 'provided manifest is invalid or incompatible with '\
        'this version of gene_system'
      end
    end

    context 'when gene_system metadata is missing' do
      let(:gene_system_meta) { {} }
      it 'raises incompatibility error' do
        expect do
          described_class.new_from_file(file_path)
        end.to raise_error 'provided manifest is invalid or incompatible with '\
        'this version of gene_system'
      end
    end
  end

  describe '#name' do
    let(:path) { 'path/to/manifest.json' }

    let(:data) do
      {
        'name' => 'test_manifest',
        'version' => '0.1.0',
        'steps' => []
      }
    end

    before do
      @manifest = described_class.new(path, data)
    end

    it 'returns name' do
      expect(@manifest.name).to eq 'test_manifest'
    end
  end

  describe '#name_and_version' do
    let(:path) { 'path/to/manifest.json' }

    let(:data) do
      {
        'name' => 'test_manifest',
        'version' => '0.1.0',
        'steps' => []
      }
    end

    before do
      @manifest = described_class.new(path, data)
    end

    it 'returns name and version' do
      expect(@manifest.name_and_version).to eq 'test_manifest v0.1.0'
    end
  end

  describe '#version' do
    let(:path) { 'path/to/manifest.json' }

    let(:data) do
      {
        'name' => 'test_manifest',
        'version' => '0.1.0',
        'steps' => []
      }
    end

    before do
      @manifest = described_class.new(path, data)
    end

    it 'returns version' do
      expect(@manifest.version).to eq '0.1.0'
    end
  end

  describe '#metadata' do
    let(:path) { 'path/to/manifest.json' }
    let(:meta) { { 'foo' => 'bar' } }

    let(:data) do
      {
        'name' => 'test_manifest',
        'version' => '0.1.0',
        'metadata' => meta,
        'steps' => []
      }
    end

    before do
      @manifest = described_class.new(path, data)
    end

    it 'returns metadata' do
      expect(@manifest.metadata).to eq meta
    end
  end

  describe '#platform' do
    let(:path) { 'path/to/manifest.json' }
    let(:platform) { 'macos' }

    let(:data) do
      {
        'name' => 'test_manifest',
        'version' => '0.1.0',
        'metadata' => { 'foo' => 'bar' },
        'platform' => platform,
        'steps' => []
      }
    end

    before do
      allow(GeneSystem::CLI).to receive(:print_warning)
      @manifest = described_class.new(path, data)
    end

    it 'returns platform' do
      expect(@manifest.platform).to eq platform
    end

    context 'when platform is unrecognized' do
      let(:platform) { 'yolosys' }

      before do
        @platform = @manifest.platform
      end

      it 'returns platform' do
        expect(@platform).to eq platform
      end

      it 'prints unrecognised platform warning' do
        expect(GeneSystem::CLI)
          .to have_received(:print_warning)
          .with("WARN: unrecognized platform: #{platform}")
      end
    end
  end

  describe '#steps' do
    let(:path) { 'path/to/manifest.json' }
    let(:data) do
      {
        'name' => 'test_manifest',
        'version' => '0.1.0',
        'steps' => []
      }
    end

    let(:step) { double(GeneSystem::Step) }
    let(:steps) { [step, step] }

    before do
      @manifest = described_class.new(path, data)
      @manifest.instance_variable_set(:@steps, steps)
    end

    it 'returns all steps by defualt' do
      expect(@manifest.steps).to eq steps
    end

    context 'when given a query' do
      let(:target_step) { double(GeneSystem::Step) }
      let(:steps) { [step, target_step, step] }

      before do
        query = ->(step) { step == target_step }
        @manifest.instance_variable_set(:@steps, steps)

        @result = @manifest.steps(query)
      end

      it 'returns steps responding to query' do
        expect(@result).to eq [target_step]
      end
    end
  end

  describe '#variables' do
    let(:path) { 'path/to/manifest.json' }
    let(:metadata) do
      {
        'gene_system' => {
          'version' => '0.3.2'
        }
      }
    end

    let(:data) do
      {
        'name' => 'test_manifest',
        'version' => '0.1.0',
        'metadata' => metadata,
        'steps' => []
      }
    end

    before do
      @manifest = described_class.new(path, data)
    end

    it 'returns hashie mash with manifest information' do
      expect(@manifest.variables.manifest.name).to eq 'test_manifest'
      expect(@manifest.variables.manifest.version).to eq '0.1.0'
      expect(@manifest.variables.manifest.metadata).to eq metadata
    end
  end
end
