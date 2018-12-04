describe Svgeez::Destination, '#file_path' do
  context 'when @destination is not specified' do
    let(:destination) { described_class.new }

    it 'returns the default file path' do
      expect(destination.file_path).to eq(File.expand_path('./svgeez.svg'))
    end
  end

  context 'when @destination is specified' do
    context 'when @destination is a folder path' do
      let :destination do
        described_class.new(
          'destination' => './foo'
        )
      end

      it 'returns the specified file path' do
        expect(destination.file_path).to eq(File.expand_path('./foo/svgeez.svg'))
      end
    end

    context 'when @destination is a file name' do
      let :destination do
        described_class.new(
          'destination' => './foo/bar.svg'
        )
      end

      it 'returns the specified file path' do
        expect(destination.file_path).to eq(File.expand_path('./foo/bar.svg'))
      end
    end
  end
end
