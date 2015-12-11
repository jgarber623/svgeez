require 'spec_helper'

describe Svgeez::SpriteBuilder do
  context '#build_destination_file_contents' do
    it 'should return a string representation of combined SVG files.' do
      sprite_builder = Svgeez::SpriteBuilder.new({
        'source' => './spec/fixtures/icons'
      })

      expect(sprite_builder.build_destination_file_contents).to eq(IO.read('./spec/fixtures/icons.svg'))
    end
  end
end
