describe Svgeez::Commands::Build do
  describe '.init_with_program' do
    let(:program) { Mercenary::Program.new(:svgeez) }

    let(:command) { Svgeez::Commands::Build.init_with_program(program) }

    it 'sets a description' do
      expect(command.description).to eq('Builds an SVG sprite from a folder of SVG icons')
    end

    it 'sets a syntax' do
      expect(command.syntax).to eq('svgeez build [options]')
    end
  end
end
