# frozen_string_literal: true

RSpec.describe Svgeez::SpriteSheet, "#contents" do
  context "with sprites" do
    it "returns a String" do
      expect(described_class.new("foo", "bar").contents).to eq(
        %(<svg id="svgeez" style="display: none;" xmlns="http://www.w3.org/2000/svg">foobar</svg>)
      )
    end
  end

  context "with no id" do
    it "returns a String" do
      expect(described_class.new.contents).to eq(
        %(<svg id="svgeez" style="display: none;" xmlns="http://www.w3.org/2000/svg"></svg>)
      )
    end
  end

  context "with id" do
    it "returns a String" do
      expect(described_class.new([], id: "foo").contents).to eq(
        %(<svg id="foo" style="display: none;" xmlns="http://www.w3.org/2000/svg"></svg>)
      )
    end
  end
end
