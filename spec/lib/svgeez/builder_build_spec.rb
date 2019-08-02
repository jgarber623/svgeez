describe Svgeez::Builder, '#build' do
  let(:file) { class_double(File) }
  let(:logger) { Svgeez.logger }
  let(:error_message) { "Setting `source` and `destination` to the same path isn't allowed!" }
  let(:warning_message) { 'No SVGs were found in `source` folder.' }

  before do
    allow(File).to receive(:directory?).and_return(true)

    allow(logger).to receive(:error)
    allow(logger).to receive(:info)
    allow(logger).to receive(:warn)
  end

  context 'when @source does not exist' do
    let(:builder) { described_class.new }
    let(:error_message) { 'Provided `source` folder does not exist.' }

    before do
      allow(File).to receive(:directory?).and_return(false)
    end

    it 'logs an error' do
      expect { builder.build }.to raise_error(SystemExit)
      expect(logger).to have_received(:error).with(error_message)
    end
  end

  context 'when @source and @destination are the same' do
    let(:builder) do
      described_class.new(
        'source' => './foo',
        'destination' => './foo'
      )
    end

    it 'logs an error' do
      expect { builder.build }.to raise_error(SystemExit)
      expect(logger).to have_received(:error).with(error_message)
    end
  end

  context 'when @destination is nested within @source' do
    let(:builder) do
      described_class.new(
        'source' => './foo',
        'destination' => './foo/bar.svg'
      )
    end

    it 'logs an error' do
      expect { builder.build }.to raise_error(SystemExit)
      expect(logger).to have_received(:error).with(error_message)
    end
  end

  context 'when @source contains no SVG files' do
    let(:builder) { described_class.new }

    it 'logs a warning' do
      builder.build

      expect(logger).to have_received(:warn).with(warning_message)
    end
  end

  context 'when @source contains SVG files' do
    let(:source) { instance_double(Svgeez::Source) }
    let(:source_folder_path) { './spec/fixtures/icons' }

    let(:file_paths) do
      %w[facebook github heart skull twitter].map { |i| "./spec/fixtures/icons/#{i}.svg" }
    end

    before do
      allow(FileUtils).to receive(:mkdir_p)
      allow(File).to receive(:open).and_yield(file)
      allow(SecureRandom).to receive(:uuid).and_return('1234-abcd-5678-efgh')

      allow(Svgeez::Source).to receive(:new).and_return(source)

      allow(file).to receive(:write)

      allow(source).to receive(:file_paths).and_return(file_paths)
      allow(source).to receive(:folder_path).and_return(File.expand_path(source_folder_path))
    end

    context 'when @svgo is not specified' do
      let(:builder) do
        described_class.new(
          'source' => source_folder_path,
          'destination' => './spec/fixtures/icons.svg'
        )
      end

      it 'writes a file' do
        builder.build

        expect(file).to have_received(:write).with(IO.read('./spec/fixtures/icons.svg'))
        expect(logger).to have_received(:info).exactly(:twice)
      end
    end

    context 'when @svgo is specified' do
      let(:builder) do
        described_class.new(
          'source' => source_folder_path,
          'destination' => './spec/fixtures/icons-svgo.svg',
          'svgo' => true
        )
      end

      it 'writes a file' do
        builder.build

        expect(file).to have_received(:write).with(%(#{IO.read('./spec/fixtures/icons-svgo.svg')}\n))
        expect(logger).to have_received(:info).exactly(:twice)
      end
    end
  end
end
