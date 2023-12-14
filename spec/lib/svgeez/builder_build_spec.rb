# frozen_string_literal: true

RSpec.describe Svgeez::Builder, "#build" do
  let(:file) { class_double(File) }
  let(:logger) { Svgeez.logger }
  let(:error_message) { "Setting `source` and `destination` to the same path isn't allowed!" }
  let(:warning_message) { "No SVGs were found in `source` folder." }

  before do
    allow(File).to receive(:directory?).and_return(true)

    allow(logger).to receive(:error)
    allow(logger).to receive(:info)
    allow(logger).to receive(:warn)
  end

  context "when @source does not exist" do
    before do
      allow(File).to receive(:directory?).and_return(false)
    end

    it "logs an error", :aggregate_failures do
      expect { described_class.new.build }.to raise_error(SystemExit)
      expect(logger).to have_received(:error).with("Provided `source` folder does not exist.")
    end
  end

  context "when @source and @destination are the same" do
    it "logs an error", :aggregate_failures do
      builder = described_class.new(
        "source" => "./foo",
        "destination" => "./foo"
      )

      expect { builder.build }.to raise_error(SystemExit)
      expect(logger).to have_received(:error).with(error_message)
    end
  end

  context "when @destination is nested within @source", :aggregate_failures do
    it "logs an error" do
      builder = described_class.new(
        "source" => "./foo",
        "destination" => "./foo/bar.svg"
      )

      expect { builder.build }.to raise_error(SystemExit)
      expect(logger).to have_received(:error).with(error_message)
    end
  end

  context "when @source contains no SVG files" do
    it "logs a warning" do
      described_class.new.build

      expect(logger).to have_received(:warn).with(warning_message)
    end
  end

  context "when @source contains SVG files" do
    let(:source) { instance_double(Svgeez::Source) }
    let(:source_folder_path) { "./spec/fixtures/icons" }

    before do
      allow(FileUtils).to receive(:mkdir_p)
      allow(File).to receive(:open).and_yield(file)
      allow(SecureRandom).to receive(:uuid).and_return("1234-abcd-5678-efgh")

      allow(Svgeez::Source).to receive(:new).and_return(source)

      allow(file).to receive(:write)

      file_paths = %w[facebook github heart skull twitter].map { |i| "./spec/fixtures/icons/#{i}.svg" }

      allow(source).to receive(:file_paths).and_return(file_paths)
      allow(source).to receive(:folder_path).and_return(File.expand_path(source_folder_path))
    end

    context "when @svgo is not specified" do
      it "writes a file", :aggregate_failures do
        described_class.new(
          "source" => source_folder_path,
          "destination" => "./spec/fixtures/icons.svg"
        ).build

        expect(file).to have_received(:write).with(File.read("./spec/fixtures/icons.svg"))
        expect(logger).to have_received(:info).exactly(:twice)
      end
    end

    context "when @svgo is specified" do
      it "writes a file", :aggregate_failures do
        described_class.new(
          "source" => source_folder_path,
          "destination" => "./spec/fixtures/icons-svgo.svg",
          "svgo" => true
        ).build

        expect(file).to have_received(:write).with(%(#{File.read("./spec/fixtures/icons-svgo.svg")}\n))
        expect(logger).to have_received(:info).exactly(:twice)
      end
    end
  end

  describe "--prefix option" do
    context "when --prefix option is not used" do
      it "assigns destination file_id as @prefix" do
        builder = described_class.new

        expect(builder.prefix).to eq(builder.destination.file_id)
      end
    end

    context "when --prefix option is used" do
      it "assigns provided value as @prefix" do
        builder = described_class.new("prefix" => "icon")

        expect(builder.prefix).to eq("icon")
      end
    end
  end
end
