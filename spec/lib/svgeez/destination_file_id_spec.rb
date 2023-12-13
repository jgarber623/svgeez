# frozen_string_literal: true

RSpec.describe Svgeez::Destination, "#file_id" do
  context "when @destination is not specified" do
    let(:destination) { described_class.new }

    it "returns the default file ID" do
      expect(destination.file_id).to eq("svgeez")
    end
  end

  context "when @destination is specified" do
    let(:destination) do
      described_class.new(
        "destination" => "./foo.svg"
      )
    end

    it "returns the specified file ID" do
      expect(destination.file_id).to eq("foo")
    end
  end
end
