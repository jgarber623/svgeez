describe Svgeez::SpriteBuilder do
  describe '#build' do
    let(:logger) { Svgeez.logger }

    context 'when @source and @destination are the same' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'source' => './foo',
          'destination' => './foo'
        )
      end

      let(:error_message) { %(Setting `source` and `destination` to the same path isn't allowed!) }

      it 'logs an error.' do
        expect(logger).to receive(:error).with(error_message)
        sprite_builder.build
      end
    end

    context 'when @source contains no SVG files' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'source' => './foo'
        )
      end

      let(:warning_message) { %(No SVGs were found in `#{File.expand_path('./foo')}`.) }

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

      let(:file_utils) { double(FileUtils) }
      let(:file) { double(File) }

      before do
        allow(FileUtils).to receive(:mkdir_p)
        allow(File).to receive(:open).and_yield(file)
        allow(file).to receive(:write)
      end

      it 'writes a file.' do
        expect(logger).to receive(:info).at_least(1).times
        sprite_builder.build
      end
    end
  end

  describe '#build_destination_file_contents' do
    let :sprite_builder do
      Svgeez::SpriteBuilder.new(
        'source' => './spec/fixtures/icons',
        'destination' => './spec/fixtures/icons.svg'
      )
    end

    it 'returns a string representation of combined SVG files.' do
      expect(sprite_builder.send(:build_destination_file_contents)).to eq IO.read('./spec/fixtures/icons.svg')
    end
  end

  describe '#destination_file_id' do
    context 'when @destination is not specified' do
      let(:sprite_builder) { Svgeez::SpriteBuilder.new({}) }

      it 'returns a string.' do
        expect(sprite_builder.send(:destination_file_id)).to eq 'svgeez'
      end
    end

    context 'when @destination is specified' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo.svg'
        )
      end

      it 'returns a string.' do
        expect(sprite_builder.send(:destination_file_id)).to eq 'foo'
      end
    end
  end

  describe '#destination_file_name' do
    context 'when @destination quacks like a folder' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo'
        )
      end

      it 'returns a string.' do
        expect(sprite_builder.send(:destination_file_name)).to eq 'svgeez.svg'
      end
    end

    context 'when @destination quacks like a file' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo/bar.svg'
        )
      end

      it 'returns a string.' do
        expect(sprite_builder.send(:destination_file_name)).to eq 'bar.svg'
      end
    end
  end

  describe '#destination_file_path' do
    context 'when @destination is not specified' do
      let(:sprite_builder) { Svgeez::SpriteBuilder.new({}) }

      it 'returns a path.' do
        expect(sprite_builder.send(:destination_file_path)).to eq "#{Dir.pwd}/_svgeez/svgeez.svg"
      end
    end

    context 'when @destination quacks like a folder' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo'
        )
      end

      it 'returns a path.' do
        expect(sprite_builder.send(:destination_file_path)).to eq "#{Dir.pwd}/foo/svgeez.svg"
      end
    end

    context 'when @destination quacks like a file' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo.svg'
        )
      end

      it 'returns a path.' do
        expect(sprite_builder.send(:destination_file_path)).to eq "#{Dir.pwd}/foo.svg"
      end
    end
  end

  describe '#destination_folder_path' do
    context 'when @destination is not specified' do
      let(:sprite_builder) { Svgeez::SpriteBuilder.new({}) }

      it 'returns a path.' do
        expect(sprite_builder.send(:destination_folder_path)).to eq "#{Dir.pwd}/_svgeez"
      end
    end

    context 'when @destination quacks like a folder' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo'
        )
      end

      it 'returns a path.' do
        expect(sprite_builder.send(:destination_folder_path)).to eq "#{Dir.pwd}/foo"
      end
    end

    context 'when @destination quacks like a file' do
      let :sprite_builder do
        Svgeez::SpriteBuilder.new(
          'destination' => './foo/bar.svg'
        )
      end

      it 'returns a path.' do
        expect(sprite_builder.send(:destination_folder_path)).to eq "#{Dir.pwd}/foo"
      end
    end
  end

  describe '#source_file_paths' do
    let :sprite_builder do
      Svgeez::SpriteBuilder.new(
        'source' => './spec/fixtures/icons'
      )
    end

    let :file_paths do
      %w(facebook github heart skull twitter).collect do |i|
        File.expand_path("./spec/fixtures/icons/#{i}.svg")
      end
    end

    it 'returns an array of of file paths.' do
      expect(sprite_builder.send(:source_file_paths)).to eq file_paths
    end
  end

  describe '#source_is_destination?' do
    context 'when @source and @destination are the same' do
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
          'destination' => './foo/bar'
        )
      end

      it 'returns true.' do
        expect(sprite_builder.send(:source_is_destination?)).to be_truthy
      end
    end

    context 'when @destination is different from @source' do
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
