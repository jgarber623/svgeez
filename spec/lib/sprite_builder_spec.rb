require 'spec_helper'

describe Svgeez::SpriteBuilder do
  context '#build' do
    context 'when the source directory and destination directory are the same' do
      let(:sprite_builder) do
        Svgeez::SpriteBuilder.new(
          'source' => './foo',
          'destination' => './foo'
        )
      end

      it 'logs an error' do
        expect(Svgeez.logger).to receive(:error).with(%(Setting `source` and `destination` to the same path isn't allowed!))
        sprite_builder.build
      end
    end

    context 'when the source directory and destination directory are different' do
      let(:sprite_builder) do
        Svgeez::SpriteBuilder.new(
          'source' => './spec/fixtures/icons',
          'destination' => './spec/fixtures'
        )
      end

      let(:file) { double(File) }

      before do
        allow(File).to receive(:open).and_yield(file)
        allow(file).to receive(:write)
      end

      it 'starts to generate the spritesheet' do
        expect(Svgeez.logger).to receive(:info).at_least(1).times
        sprite_builder.build
      end
    end
  end

  context '#build_destination_file_contents' do
    it 'should return a string representation of combined SVG files.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './spec/fixtures/icons',
        'destination' => './spec/fixtures/icons.svg'
      )

      expect(sprite_builder.send(:build_destination_file_contents)).to eq IO.read('./spec/fixtures/icons.svg')
    end
  end

  context '#destination_file_id' do
    it 'should return a string when @destination is not specified.' do
      sprite_builder = Svgeez::SpriteBuilder.new({})

      expect(sprite_builder.send(:destination_file_id)).to eq 'svgeez'
    end

    it 'should return a string when @destination is specified.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo.svg'
      )

      expect(sprite_builder.send(:destination_file_id)).to eq 'foo'
    end
  end

  context '#destination_file_name' do
    it 'should return a string when @destination quacks like a folder.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo'
      )

      expect(sprite_builder.send(:destination_file_name)).to eq 'svgeez.svg'
    end

    it 'should return a string when @destination quacks like a file.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo/bar.svg'
      )

      expect(sprite_builder.send(:destination_file_name)).to eq 'bar.svg'
    end
  end

  context '#destination_file_path' do
    it 'should return a path when @destination is not specified.' do
      sprite_builder = Svgeez::SpriteBuilder.new({})

      expect(sprite_builder.send(:destination_file_path)).to eq "#{Dir.pwd}/_svgeez/svgeez.svg"
    end

    it 'should return a path when @destination quacks like a folder.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo'
      )

      expect(sprite_builder.send(:destination_file_path)).to eq "#{Dir.pwd}/foo/svgeez.svg"
    end

    it 'should return a path when @destination quacks like a file.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo.svg'
      )

      expect(sprite_builder.send(:destination_file_path)).to eq "#{Dir.pwd}/foo.svg"
    end
  end

  context '#destination_folder_path' do
    it 'should return a path when @destination is not specified.' do
      sprite_builder = Svgeez::SpriteBuilder.new({})

      expect(sprite_builder.send(:destination_folder_path)).to eq "#{Dir.pwd}/_svgeez"
    end

    it 'should return a path when @destination quacks like a folder.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo'
      )

      expect(sprite_builder.send(:destination_folder_path)).to eq "#{Dir.pwd}/foo"
    end

    it 'should return a path when @destination quacks like a file.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'destination' => './foo/bar.svg'
      )

      expect(sprite_builder.send(:destination_folder_path)).to eq "#{Dir.pwd}/foo"
    end
  end

  context '#source_file_paths' do
    it 'should return an array of @source_file_paths.' do
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
    it 'should return true if @source and @destination are the same.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './foo',
        'destination' => './foo'
      )

      expect(sprite_builder.send(:source_is_destination?)).to be_truthy
    end

    it 'should return true if @destination is within @source.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './foo',
        'destination' => './foo/bar'
      )

      expect(sprite_builder.send(:source_is_destination?)).to be_truthy
    end

    it 'should return false if @destination is not within or the same as @source.' do
      sprite_builder = Svgeez::SpriteBuilder.new(
        'source' => './foo',
        'destination' => './bar'
      )

      expect(sprite_builder.send(:source_is_destination?)).to be_falsy
    end
  end
end
