# frozen_string_literal: true

RSpec.describe Svgeez::Destination, '#folder_path' do
  context 'when @destination is not specified' do
    let(:destination) { described_class.new }

    it 'returns the default folder path' do
      expect(destination.folder_path).to eq(File.expand_path('.'))
    end
  end

  context 'when @destination is specified' do
    context 'when @destination is a folder path' do
      let(:destination) do
        described_class.new(
          'destination' => './foo'
        )
      end

      it 'returns the specified folder path' do
        expect(destination.folder_path).to eq(File.expand_path('./foo'))
      end
    end

    context 'when @destination is a file name' do
      let(:destination) do
        described_class.new(
          'destination' => './foo/bar.svg'
        )
      end

      it 'returns the specified folder path' do
        expect(destination.folder_path).to eq(File.expand_path('./foo'))
      end
    end
  end
end
