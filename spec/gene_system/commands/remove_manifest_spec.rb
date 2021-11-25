require 'spec_helper'

RSpec.describe GeneSystem::Commands::RemoveManifest do
  let(:options) { Hashie::Mash.new }
  let(:prompt) { double(TTY::Prompt) }
  let(:execute_command_result) { 0 }
  let(:manifest_name) { 'some manifest' }

  subject { described_class.new(options) }

  before do
    subject.instance_variable_set(:@prompt, prompt)
  end

  describe '#run' do
    let(:platform) { double(GeneSystem::Platform) }

    let(:manifest) do
      double(GeneSystem::Manifest, name: manifest_name)
    end

    let(:skip_command) { 'false' }
    let(:prompts) { [prompt_definition, prompt_definition] }
    let(:prompt_definition) do
      {
        "prompt": 'Please enter your name',
        "var": 'name'
      }
    end
    let(:cmd) { 'echo {{name}}' }
    let(:cmds) do
      [
        cmd
      ]
    end

    let(:step_definition) do
      {
        "name": 'some step',
        "exe": {
          "remove": {
            "skip": skip_command,
            "prompts": prompts,
            "cmd": cmds
          }
        }
      }
    end

    let(:step) do
      GeneSystem::Step.new(step_definition)
    end

    before do
      allow(GeneSystem::Manifest)
        .to receive(:new_from_file)
        .and_return(manifest)

      allow(GeneSystem::Platform)
        .to receive(:new)
        .and_return(platform)

      allow(manifest)
        .to receive(:steps)
        .and_return([step, step])

      allow(platform)
        .to receive(:execute_commands)

      allow(platform)
        .to receive(:execute_command)
        .and_return(execute_command_result)

      allow(prompt).to receive(:ask).and_return(prompt_response)
      allow(subject).to receive(:puts)
    end

    context 'when manifest path is provided' do
      let(:manifest_path) { 'provided/path/to/manifest.json' }
      let(:execute_command_result) { 1 }
      let(:prompt_response) { 'Jon' }
      let(:options) do
        Hashie::Mash.new(
          manifest: manifest_path
        )
      end

      before do
        subject.run
      end

      it 'loads manifest from expected file' do
        expect(GeneSystem::Manifest)
          .to have_received(:new_from_file)
          .with(manifest_path)
      end

      describe 'skip steps' do
        context 'when there is a skip command defined' do
          it 'checks whether it should skip any steps' do
            expect(platform)
              .to have_received(:execute_command)
              .with(skip_command).twice
          end
        end

        context 'when there is no skip command defined' do
          let(:step_definition) do
            {
              "name": 'some step',
              "exe": {
                "remove": {
                  "skip": nil,
                  "cmd": []
                }
              }
            }
          end

          it 'does not try to run nil command' do
            expect(platform)
              .not_to have_received(:execute_command)
          end
        end

        context 'when the skip command returns non zero' do
          let(:execute_command_result) { 1 }
          let(:prompts) { [] }

          it 'does not execute step' do
            expect(platform)
              .not_to have_received(:execute_command)
              .with(cmd)
          end
        end
      end

      describe 'prompting user for input' do
        context 'when there are no prompts' do
          let(:prompts) { [] }

          it 'does not ask user for input' do
            expect(prompt)
              .not_to have_received(:ask)
          end
        end

        context 'when there are prompts' do
          it 'asks user for input' do
            expect(prompt)
              .to have_received(:ask)
              .with('Please enter your name').exactly(4).times
          end
        end
      end

      it 'executes step commands' do
        expect(platform)
          .to have_received(:execute_commands)
          .with(cmds, 'name' => prompt_response).twice
      end

      it 'prints success message' do
        expect(subject)
          .to have_received(:puts)
          .with("✔ Manifest #{manifest_name} successfully removed")
      end
    end

    context 'when the manifest name is not provided' do
      let(:prompt_response) { '/path/to/manifest.json' }

      before do
        allow(prompt)
          .to receive(:ask)
          .and_return(prompt_response)

        subject.run
      end

      describe 'prompting user for manifest path' do
        it 'prompts user for manifest path' do
          expect(prompt)
            .to have_received(:ask)
            .with(
              'Please enter the path to the configuration manifest',
              default: 'manifest.json'
            )
        end
      end

      describe 'skipping steps' do
        context 'when there is a skip command defined' do
          it 'checks whether it should skip any steps' do
            expect(platform)
              .to have_received(:execute_command)
              .with(skip_command).twice
          end
        end

        context 'when there is no skip command defined' do
          let(:step_definition) do
            {
              "name": 'some step',
              "exe": {
                "remove": {
                  "skip": nil,
                  "cmd": []
                }
              }
            }
          end

          it 'does not try to run nil command' do
            expect(platform)
              .not_to have_received(:execute_command)
          end
        end

        context 'when the skip command returns non zero' do
          let(:execute_command_result) { 1 }
          let(:prompts) { [] }

          it 'does not execute step' do
            expect(platform)
              .not_to have_received(:execute_command)
              .with(cmd)
          end
        end
      end

      it 'prints success message' do
        expect(subject)
          .to have_received(:puts)
          .with("✔ Manifest #{manifest_name} successfully removed")
      end
    end
  end
end
