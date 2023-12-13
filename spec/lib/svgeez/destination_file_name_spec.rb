# frozen_string_literal: true

RSpec.describe Svgeez::Destination, "#file_name" do
  context "when @destination is not specified" do
    let(:destination) { described_class.new }

    it "returns the default file name" do
      expect(destination.file_name).to eq("svgeez.svg")
    end
  end

  context "when @destination is specified" do
    context "when @destination is a folder path" do
      let(:destination) do
        described_class.new(
          "destination" => "./foo"
        )
      end

      it "returns the default file name" do
        expect(destination.file_name).to eq("svgeez.svg")
      end
    end

    context "when @destination is a file name" do
      let(:destination) do
        described_class.new(
          "destination" => "./foo.svg"
        )
      end

      it "returns the specified file name" do
        expect(destination.file_name).to eq("foo.svg")
      end
    end
  end
end
