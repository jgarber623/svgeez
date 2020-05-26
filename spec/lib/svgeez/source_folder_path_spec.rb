RSpec.describe Svgeez::Source, '#folder_path' do
  context 'when @source is not specified' do
    let(:source) { described_class.new }

    it 'returns the default folder path' do
      expect(source.folder_path).to eq(File.expand_path('./_svgeez'))
    end
  end

  context 'when @source is specified' do
    let(:source) do
      described_class.new(
        'source' => './foo'
      )
    end

    it 'returns the specified folder path' do
      expect(source.folder_path).to eq(File.expand_path('./foo'))
    end
  end
end
