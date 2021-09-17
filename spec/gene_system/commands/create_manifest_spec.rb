require 'spec_helper'

RSpec.describe GeneSystem::Commands::CreateManifest do
  let(:name_opt) { 'manifest.jsonnet' }
  let(:output_opt) { '/path/to/output' }

  let(:options) do
    Hashie::Mash.new(
      name: name_opt,
      out: output_opt
    )
  end

  subject { described_class.new(options) }

  describe '#run' do
    let(:prompt) { double }
    let(:prompt_response) { nil }

    let(:is_dir) { true }

    before do
      subject.instance_variable_set(:@prompt, prompt)

      allow(File).to receive(:directory?).and_return(is_dir)
      allow(subject).to receive(:puts)

      allow(prompt).to receive(:ask)
        .and_return(prompt_response)

      allow(GeneSystem::Generators)
        .to receive(:render_empty_manifest)
    end

    context 'when name and output prompt is provided' do
      before { subject.run }

      it 'does not ask for any input' do
        expect(prompt).not_to have_received(:ask)
      end

      it 'renders empty manifest' do
        expect(GeneSystem::Generators)
          .to have_received(:render_empty_manifest)
          .with(name_opt, output_opt)
      end

      it 'reports success' do
        expect(subject)
          .to have_received(:puts)
          .with('✔ manifest successfully created in /path/to/output')
      end
    end

    context 'when only name is provided' do
      let(:output_opt) { nil }
      let(:prompt_response) { '/path/to/given/output' }

      before { subject.run }

      it 'prompts for output location' do
        expect(prompt).to have_received(:ask)
          .with(
            'Please specify output location',
            default: Dir.pwd
          )
      end

      it 'renders empty manifest' do
        expect(GeneSystem::Generators)
          .to have_received(:render_empty_manifest)
          .with(name_opt, prompt_response)
      end

      it 'reports success' do
        expect(subject)
          .to have_received(:puts)
          .with('✔ manifest successfully created in /path/to/given/output')
      end
    end

    context 'when only output is provided' do
      let(:name_opt) { nil }
      let(:prompt_response) { 'abc.json' }

      before { subject.run }

      it 'prompts for manifest name' do
        expect(prompt).to have_received(:ask)
          .with(
            'Please enter the name of the manifest',
            default: described_class::DEFAULT_MANIFEST_NAME
          )
      end

      it 'renders empty manifest' do
        expect(GeneSystem::Generators)
          .to have_received(:render_empty_manifest)
          .with(prompt_response, output_opt)
      end

      it 'reports success' do
        expect(subject)
          .to have_received(:puts)
          .with('✔ manifest successfully created in /path/to/output')
      end
    end

    context 'when the output location is not a directory' do
      let(:is_dir) { false }

      it 'raises runtime error' do
        expect do
          subject.run
        end.to raise_error('output location must be a folder')
      end
    end
  end
end
