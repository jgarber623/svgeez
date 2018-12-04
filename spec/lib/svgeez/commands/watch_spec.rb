describe Svgeez::Commands::Watch do
  describe '.init_with_program' do
    let(:program) { Mercenary::Program.new(:svgeez) }
    let(:command) { described_class.init_with_program(program) }

    it 'sets a description' do
      expect(command.description).to eq('Watches a folder of SVG icons for changes')
    end

    it 'sets a syntax' do
      expect(command.syntax).to eq('svgeez watch [options]')
    end
  end
end
