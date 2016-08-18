require 'spec_helper'

describe Svgeez::SpriteBuilder do
  context '#build' do
    let(:file) { double(File) }

    before do
      allow(File).to receive(:open).and_yield(file)
      allow(file).to receive(:write)
    end

    it 'logs an error when @source and @destination are the same.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './foo',
        'destination' => './foo'
      )

      expect(Svgeez.logger).to receive(:error).with(%(Setting `source` and `destination` to the same path isn't allowed!))
      sprite_builder.build
    end

    it 'logs a warning when @source contains no SVG files.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './foo'
      )

      expect(Svgeez.logger).to receive(:warn).with(%(No SVGs were found in `#{File.expand_path('./foo')}`.))
      sprite_builder.build
    end

    it 'writes a file when @source contains SVG files.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './spec/fixtures/icons'
      )

      expect(Svgeez.logger).to receive(:info).at_least(1).times
      sprite_builder.build
    end
  end

  context '#build_destination_file_contents' do
    it 'returns a string representation of combined SVG files.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './spec/fixtures/icons',
        'destination' => './spec/fixtures/icons.svg'
      )

      expect(sprite_builder.send(:build_destination_file_contents)).to eq IO.read('./spec/fixtures/icons.svg')
    end
  end

  context '#destination_file_id' do
    it 'returns a string when @destination is not specified.' do
      sprite_builder = Svgeez::SpriteBuilder.new({})

      expect(sprite_builder.send(:destination_file_id)).to eq 'svgeez'
    end

    it 'returns a string when @destination is specified.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo.svg'
      )

      expect(sprite_builder.send(:destination_file_id)).to eq 'foo'
    end
  end

  context '#destination_file_name' do
    it 'returns a string when @destination quacks like a folder.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo'
      )

      expect(sprite_builder.send(:destination_file_name)).to eq 'svgeez.svg'
    end

    it 'returns a string when @destination quacks like a file.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo/bar.svg'
      )

      expect(sprite_builder.send(:destination_file_name)).to eq 'bar.svg'
    end
  end

  context '#destination_file_path' do
    it 'returns a path when @destination is not specified.' do
      sprite_builder = Svgeez::SpriteBuilder.new({})

      expect(sprite_builder.send(:destination_file_path)).to eq "#{Dir.pwd}/_svgeez/svgeez.svg"
    end

    it 'returns a path when @destination quacks like a folder.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo'
      )

      expect(sprite_builder.send(:destination_file_path)).to eq "#{Dir.pwd}/foo/svgeez.svg"
    end

    it 'returns a path when @destination quacks like a file.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo.svg'
      )

      expect(sprite_builder.send(:destination_file_path)).to eq "#{Dir.pwd}/foo.svg"
    end
  end

  context '#destination_folder_path' do
    it 'returns a path when @destination is not specified.' do
      sprite_builder = Svgeez::SpriteBuilder.new({})

      expect(sprite_builder.send(:destination_folder_path)).to eq "#{Dir.pwd}/_svgeez"
    end

    it 'returns a path when @destination quacks like a folder.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo'
      )

      expect(sprite_builder.send(:destination_folder_path)).to eq "#{Dir.pwd}/foo"
    end

    it 'returns a path when @destination quacks like a file.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo/bar.svg'
      )

      expect(sprite_builder.send(:destination_folder_path)).to eq "#{Dir.pwd}/foo"
    end
  end

  context '#source_file_paths' do
    it 'returns an array of @source_file_paths.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './spec/fixtures/icons'
      )

      file_paths = %w(facebook github heart skull twitter).collect do |i|
        File.expand_path("./spec/fixtures/icons/#{i}.svg")
      end

      expect(sprite_builder.send(:source_file_paths)).to eq file_paths
    end
  end

  context '#source_is_destination?' do
    it 'returns true if @source and @destination are the same.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './foo',
        'destination' => './foo'
      )

      expect(sprite_builder.send(:source_is_destination?)).to be_truthy
    end

    it 'returns true if @destination is within @source.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './foo',
        'destination' => './foo/bar'
      )

      expect(sprite_builder.send(:source_is_destination?)).to be_truthy
    end

    it 'returns false if @destination is not within or the same as @source.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './foo',
        'destination' => './bar'
      )

      expect(sprite_builder.send(:source_is_destination?)).to be_falsy
    end
  end
end
