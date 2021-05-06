require 'spec_helper'

RSpec.describe GeneSystem::CLI::Commands do
  describe '.new' do
    let(:pwd) { 'path/to/current/dir' }
    let(:name) { 'manifest name' }
    let(:args) { [name] }

    before do
      allow(Dir).to receive(:pwd).and_return(pwd)
      allow(GeneSystem::Generators).to receive(:render_empty_manifest)
    end

    it 'renders empty manifest at current path with given name' do
      described_class.new(args)

      expect(GeneSystem::Generators).to have_received(:render_empty_manifest)
        .with(name, pwd)
    end

    context 'when name is not given' do
      it 'raises no manifest name provided runtime error' do
        expect { described_class.new([]) }.to raise_error(
          RuntimeError,
          'no manifest name provided'
        )
      end
    end
  end

  describe '.install' do
    let(:manifest_name) { 'manifest.json' }
    let(:pwd) { 'path/to/current/dir' }

    let(:args) { [manifest_name] }
    let(:file_exist) { true }

    let(:skip_cmd) { 'check something' }
    let(:skip_result) { 1 }

    let(:cmd) { 'do something' }
    let(:cmds) { [cmd, cmd] }

    let(:data) do
      {
        'name' => 'test_manifest',
        'version' => '0.1.0',
        'steps' => [
          {
            'name' => 'install',
            'exe' => {
              'install' => {
                'skip' => skip_cmd,
                'cmd' => cmds
              }
            }
          }
        ]
      }
    end

    let(:manifest) do
      GeneSystem::Manifest.new(
        File.join(pwd, manifest_name),
        data
      )
    end
    let(:platform) { double(GeneSystem::Platform) }

    before do
      allow(Dir).to receive(:pwd).and_return(pwd)
      allow(File).to receive(:exist?).and_return(file_exist)

      allow(GeneSystem::Manifest).to receive(:new_from_file)
        .and_return(manifest)

      allow(GeneSystem::Platform).to receive(:new)
        .and_return(platform)

      allow(platform).to receive(:execute_commands)
      allow(platform).to receive(:execute_command)
        .with(skip_cmd)
        .and_return(skip_result)

      allow(GeneSystem::CLI).to receive(:print_message)
    end

    describe 'installing manifest' do
      before { described_class.install(args) }

      it 'loads manifest' do
        expect(GeneSystem::Manifest)
          .to have_received(:new_from_file)
          .with(File.join(pwd, manifest_name))
      end

      it 'executes steps on platform' do
        expect(platform)
          .to have_received(:execute_commands)
          .with(cmds, {})
      end

      it 'prints success message' do
        expect(GeneSystem::CLI).to have_received(:print_message)
          .with("\nmanifest successfully installed")
      end

      context 'when skipping step' do
        let(:skip_result) { 0 }

        it 'does not execute steps' do
          expect(platform)
            .not_to have_received(:execute_commands)
        end
      end
    end

    context 'when path is not provided' do
      it 'raises no manifest path provided runtime error' do
        expect { described_class.install }.to raise_error(
          RuntimeError,
          'no manifest path provided'
        )
      end
    end

    context 'when manifest cannot be created at specified path' do
      let(:file_exist) { false }

      it 'raises cannot find manifest RuntimeError' do
        expect { described_class.install(args) }.to raise_error(
          RuntimeError,
          'cannot find manifest at path/to/current/dir/manifest.json'
        )
      end
    end
  end

  describe '.remove' do
    let(:manifest_name) { 'manifest.json' }
    let(:pwd) { 'path/to/current/dir' }

    let(:args) { [manifest_name] }
    let(:file_exist) { true }

    let(:cmd) { 'do something' }
    let(:cmds) { [cmd, cmd] }

    let(:data) do
      {
        'name' => 'test_manifest',
        'version' => '0.1.0',
        'steps' => [
          {
            'name' => 'remove',
            'exe' => {
              'remove' => {
                'cmd' => cmds
              }
            }
          }
        ]
      }
    end

    let(:manifest) do
      GeneSystem::Manifest.new(
        File.join(pwd, manifest_name),
        data
      )
    end
    let(:platform) { double(GeneSystem::Platform) }

    before do
      allow(Dir).to receive(:pwd).and_return(pwd)
      allow(File).to receive(:exist?).and_return(file_exist)

      allow(GeneSystem::Manifest).to receive(:new_from_file)
        .and_return(manifest)

      allow(GeneSystem::Platform).to receive(:new)
        .and_return(platform)

      allow(platform).to receive(:execute_commands)

      allow(GeneSystem::CLI).to receive(:print_message)
    end

    describe 'remooving manifest' do
      before { described_class.remove(args) }

      it 'loads manifest' do
        expect(GeneSystem::Manifest)
          .to have_received(:new_from_file)
          .with(File.join(pwd, manifest_name))
      end

      it 'executes remove on platform' do
        expect(platform)
          .to have_received(:execute_commands)
          .with(cmds)
      end

      it 'prints success message' do
        expect(GeneSystem::CLI).to have_received(:print_message)
          .with("\nmanifest successfully removed")
      end
    end

    context 'when path is not provided' do
      it 'raises no manifest path provided runtime error' do
        expect { described_class.install }.to raise_error(
          RuntimeError,
          'no manifest path provided'
        )
      end
    end

    context 'when manifest cannot be created at specified path' do
      let(:file_exist) { false }

      it 'raises cannot find manifest RuntimeError' do
        expect { described_class.install(args) }.to raise_error(
          RuntimeError,
          'cannot find manifest at path/to/current/dir/manifest.json'
        )
      end
    end
  end
end
