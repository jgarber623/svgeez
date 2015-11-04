require 'spec_helper'

describe Svgeez::SpriteBuilder do
  let :options do
    {
      'source' => './spec/fixtures/icons',
      'destination' => './spec/fixtures'
    }
  end

  let(:sprite_builder) { Svgeez::SpriteBuilder.new(options) }

  context '#build_output_file_contents' do
    it 'should return a string representation of combined SVG files.' do
      expect(sprite_builder.build_output_file_contents).to eq(IO.read('./spec/fixtures/icons.svg'))
    end
  end
end
