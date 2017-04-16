describe Svgeez::Source do
  describe '#file_paths' do
    let(:source) { Svgeez::Source.new }

    let :file_paths do
      %w(facebook github heart skull twitter).collect do |i|
        File.expand_path("./_svgeez/#{i}.svg")
      end
    end

    before do
      allow(Dir).to receive(:glob).and_return(file_paths)
    end

    it 'returns an array of file paths' do
      expect(source.file_paths).to eq(file_paths)
    end
  end

  describe '#folder_path' do
    context 'when @source is not specified' do
      let(:source) { Svgeez::Source.new }

      it 'returns the default folder path' do
        expect(source.folder_path).to eq(File.expand_path('./_svgeez'))
      end
    end

    context 'when @source is specified' do
      let :source do
        Svgeez::Source.new(
          'source' => './foo'
        )
      end

      it 'returns the specified folder path' do
        expect(source.folder_path).to eq(File.expand_path('./foo'))
      end
    end
  end
end
