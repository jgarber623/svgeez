# frozen_string_literal: true

RSpec.describe Svgeez, ".build_sprite_sheet" do
  subject(:svgeez) { described_class }

  before do
    allow(File).to receive(:write)
    allow(FileUtils).to receive(:mkdir_p)
    allow(SecureRandom).to receive(:uuid).and_return("1234-abcd-5678-efgh")
  end

  context "with no arguments" do
    # Note that this spec passes because the default argument value for
    # `input_path` (`./_svgeez`) does not exist in $PWD and the call to `Dir[]`
    # returns an empty Array.
    it "writes a file" do
      svgeez.build_sprite_sheet

      expect(File).to have_received(:write).with(
        File.expand_path("svgeez.svg"),
        %(<svg id="svgeez" style="display: none;" xmlns="http://www.w3.org/2000/svg"></svg>)
      )
    end
  end

  context "when output directory does not exist" do
    it "writes a file", :aggregate_failures do
      described_class.build_sprite_sheet("./_svgeez", "./foo/bar/biz")

      expect(FileUtils).to have_received(:mkdir_p).with(File.expand_path("./foo/bar/biz"))

      expect(File).to have_received(:write).with(
        File.expand_path("./foo/bar/biz/svgeez.svg"),
        %(<svg id="svgeez" style="display: none;" xmlns="http://www.w3.org/2000/svg"></svg>)
      )
    end
  end

  context "with no prefix argument" do
    it "writes a file" do
      svgeez.build_sprite_sheet("./spec/fixtures/icons", "./tmp/icons.svg")

      expect(File).to have_received(:write).with(
        File.expand_path("./tmp/icons.svg"),
        File.read("./spec/fixtures/icons.svg")
      )
    end
  end

  context "with prefix argument" do
    it "writes a file" do
      svgeez.build_sprite_sheet("./spec/fixtures/icons", "./tmp/icons.svg", prefix: "foo")

      expect(File).to have_received(:write).with(
        File.expand_path("./tmp/icons.svg"),
        File.read("./spec/fixtures/icons-prefix.svg")
      )
    end
  end
end
