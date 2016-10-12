describe Svgeez::SpriteBuilder do
  # Public methods

  describe '#build' do
    let(:logger) { Svgeez.logger }

    context 'when @source and @destination are the same' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'source' => './foo',
          'destination' => './foo'
        )
      end

      let(:error_message) { "Setting `source` and `destination` to the same path isn't allowed!" }

      it 'logs an error.' do
        expect(logger).to receive(:error).with(error_message)
        sprite_builder.build
      end
    end

    context 'when @source contains no SVG files' do
      let(:sprite_builder) { Svgeez::SpriteBuilder.new }

      let(:warning_message) { "No SVGs were found in `#{File.expand_path('./_svgeez')}`." }

      it 'logs a warning.' do
        expect(logger).to receive(:warn).with(warning_message)
        sprite_builder.build
      end
    end

    context 'when @source contains SVG files' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'source' => './spec/fixtures/icons'
        )
      end

      let(:file) { double(File) }

      before do
        allow(FileUtils).to receive(:mkdir_p)
        allow(File).to receive(:open).and_yield(file)
        allow(file).to receive(:write)
      end

      it 'writes a file.' do
        expect(logger).to receive(:info).exactly(:twice)
        sprite_builder.build
      end
    end
  end

  describe '#destination' do
    context 'when @destination is not specified' do
      let(:sprite_builder) { Svgeez::SpriteBuilder.new }

      it 'returns the default path.' do
        expect(sprite_builder.destination).to eq(File.expand_path('./svgeez.svg'))
      end
    end

    context 'when @destination is specified' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo.svg'
        )
      end

      it 'returns the specified path' do
        expect(sprite_builder.destination).to eq(File.expand_path('./foo.svg'))
      end
    end
  end

  describe '#source' do
    context 'when @source is not specified' do
      let(:sprite_builder) { Svgeez::SpriteBuilder.new }

      it 'returns the default path.' do
        expect(sprite_builder.source).to eq(File.expand_path('./_svgeez'))
      end
    end

    context 'when @source is specified' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'source' => './foo'
        )
      end

      it 'returns the specified path.' do
        expect(sprite_builder.source).to eq(File.expand_path('./foo'))
      end
    end
  end

  # Private methods

  describe '#build_destination_file_contents' do
    context 'when @svgo is not specified' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'source' => './spec/fixtures/icons',
          'destination' => './spec/fixtures/icons.svg'
        )
      end

      it 'returns a string representation of combined SVG files.' do
        expect(sprite_builder.send(:build_destination_file_contents)).to eq(IO.read('./spec/fixtures/icons.svg'))
      end
    end

    context 'when @svgo is specified' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'source' => './spec/fixtures/icons',
          'svgo' => true
        )
      end

      context 'and SVGO is not found' do
        let(:logger) { Svgeez.logger }

        let(:warning_message) { 'Unable to find `svgo` in your PATH. Continuing with standard sprite generation...' }

        before do
          allow(sprite_builder).to receive(:svgo_installed?).and_return(false)
        end

        it 'logs a warning.' do
          expect(logger).to receive(:warn).with(warning_message)
          sprite_builder.send(:build_destination_file_contents)
        end
      end

      context 'and SVGO executable is found' do
        it 'returns a string representation of combined SVG files.' do
          expect(sprite_builder.send(:build_destination_file_contents)).to eq(IO.read('./spec/fixtures/svgeez.svg'))
        end
      end
    end
  end

  describe '#collect_source_files_contents' do
    let(:sprite_builder) { Svgeez::SpriteBuilder.new }

    let(:file_paths) { [File.expand_path('./spec/fixtures/icons/skull.svg')] }

    before do
      allow(sprite_builder).to receive(:source_file_paths).and_return(file_paths)
    end

    it 'returns an array of strings.' do
      expect(sprite_builder.send(:collect_source_files_contents)).to match_array([%(<symbol id="svgeez-skull" viewBox="0 0 32 32">\n  <path d="M16 0 C6 0 2 4 2 14 L2 22 L6 24 L6 30 L26 30 L26 24 L30 22 L30 14 C30 4 26 0 16 0 M9 12 A4.5 4.5 0 0 1 9 21 A4.5 4.5 0 0 1 9 12 M23 12 A4.5 4.5 0 0 1 23 21 A4.5 4.5 0 0 1 23 12"></path>\n</symbol>)])
    end
  end

  describe '#destination_file_id' do
    context 'when @destination is not specified' do
      let(:sprite_builder) { Svgeez::SpriteBuilder.new }

      it 'returns a string.' do
        expect(sprite_builder.send(:destination_file_id)).to eq('svgeez')
      end
    end

    context 'when @destination is specified' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo.svg'
        )
      end

      it 'returns a string.' do
        expect(sprite_builder.send(:destination_file_id)).to eq('foo')
      end
    end
  end

  describe '#destination_file_name' do
    context 'when @destination is a path to a file' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo.svg'
        )
      end

      it 'returns the specified file name.' do
        expect(sprite_builder.send(:destination_file_name)).to eq('foo.svg')
      end
    end

    context 'when @destination is a path to a folder' do
      let(:sprite_builder) { Svgeez::SpriteBuilder.new }

      it 'returns the default file name.' do
        expect(sprite_builder.send(:destination_file_name)).to eq('svgeez.svg')
      end
    end
  end

  describe '#destination_file_path' do
    let(:sprite_builder) { Svgeez::SpriteBuilder.new }

    it 'returns a file path.' do
      expect(sprite_builder.send(:destination_file_path)).to eq(File.expand_path('./svgeez.svg'))
    end
  end

  describe '#destination_folder_path' do
    let(:expected_destination_folder_path) { File.expand_path('./foo') }

    context 'when @destination is a path to a file' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo/bar.svg'
        )
      end

      it 'returns a path to a folder.' do
        expect(sprite_builder.send(:destination_folder_path)).to eq(expected_destination_folder_path)
      end
    end

    context 'when @destination is a path to a folder' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo'
        )
      end

      it 'returns a path to a folder.' do
        expect(sprite_builder.send(:destination_folder_path)).to eq(expected_destination_folder_path)
      end
    end
  end

  describe '#source_file_paths' do
    let(:sprite_builder) { Svgeez::SpriteBuilder.new }

    let :file_paths do
      %w(facebook github heart skull twitter).collect do |i|
        File.expand_path("./_svgeez/#{i}.svg")
      end
    end

    before do
      allow(Dir).to receive(:glob).and_return(file_paths)
    end

    it 'returns an array of file paths.' do
      expect(sprite_builder.send(:source_file_paths)).to eq(file_paths)
    end
  end

  describe '#source_is_destination?' do
    context 'when @source and @desination are the same' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'source' => './foo',
          'destination' => './foo'
        )
      end

      it 'returns true.' do
        expect(sprite_builder.send(:source_is_destination?)).to be_truthy
      end
    end

    context 'when @destination is nested within @source' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'source' => './foo',
          'destination' => './foo/bar.svg'
        )
      end

      it 'returns true.' do
        expect(sprite_builder.send(:source_is_destination?)).to be_truthy
      end
    end

    context 'when @source is nested within @destination' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'source' => './foo/bar',
          'destination' => './foo'
        )
      end

      it 'returns false.' do
        expect(sprite_builder.send(:source_is_destination?)).to be_falsy
      end
    end

    context 'when @source and @destination are different' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'source' => './foo',
          'destination' => './bar'
        )
      end

      it 'returns false.' do
        expect(sprite_builder.send(:source_is_destination?)).to be_falsy
      end
    end
  end
end
