require 'spec_helper'

RSpec.describe GeneSystem::Platform do
  let(:is_posix) { true }
  before do
    allow(OS).to receive(:posix?).and_return(is_posix)
  end

  describe 'initialize' do
    it 'returns a new platform' do
      @platform = described_class.new
      expect(@platform).to be_a(described_class)
    end

    context 'when system is not posix' do
      let(:is_posix) { false }

      it 'raises unsuppoorted platform RuntimeError' do
        expect { described_class.new }.to raise_error(
          RuntimeError,
          'unsupported platform'
        )
      end
    end
  end

  describe '#execute_commands' do
    let(:cmd) { 'do something' }
    let(:cmds) { [cmd, cmd] }
    let(:result) { 0 }

    subject { described_class.new }

    before do
      allow(subject).to receive(:execute_command)
        .and_return(result)
    end

    it 'executes commands' do
      subject.execute_commands(cmds)

      expect(subject)
        .to have_received(:execute_command)
        .with(cmd)
        .twice
    end

    context 'when command fails' do
      let(:result) { 1 }

      it 'raises command failed runtime error' do
        expect { subject.execute_commands(cmds) }.to raise_error(
          RuntimeError,
          "command `#{cmd}` failed - returned #{result}"
        )
      end
    end
  end

  describe '#execute_command' do
    let(:cmd) { 'do something' }
    let(:pid) { 1234 }
    let(:result) { double(exitstatus: 999) }

    subject { described_class.new }

    before do
      allow(Process).to receive(:spawn).and_return(pid)
      allow(Process).to receive(:waitpid2).and_return([pid, result])

      @result = subject.execute_command(cmd)
    end

    it 'spawns process with command' do
      expect(Process).to have_received(:spawn).with(cmd)
    end

    it 'waits for processs to conclude' do
      expect(Process).to have_received(:waitpid2).with(pid)
    end

    it 'returns status' do
      expect(@result).to eq result.exitstatus
    end
  end

  describe '#posix?' do
    subject { described_class.new }

    it 'returns true if system is posix' do
      expect(subject.posix?).to be true
    end
  end
end
