describe Svgeez::Builder, '#build' do
  let(:logger) { Svgeez.logger }
  let(:error_message) { "Setting `source` and `destination` to the same path isn't allowed!" }
  let(:warning_message) { 'No SVGs were found in `source` folder.' }

  context 'when @source and @destination are the same' do
    let :builder do
      described_class.new(
        'source' => './foo',
        'destination' => './foo'
      )
    end

    it 'logs an error' do
      expect(logger).to receive(:error).with(error_message)
      builder.build
    end
  end

  context 'when @destination is nested within @source' do
    let :builder do
      described_class.new(
        'source' => './foo',
        'destination' => './foo/bar.svg'
      )
    end

    it 'logs an error' do
      expect(logger).to receive(:error).with(error_message)
      builder.build
    end
  end

  context 'when @source contains no SVG files' do
    let(:builder) { described_class.new }

    it 'logs a warning' do
      expect(logger).to receive(:warn).with(warning_message)
      builder.build
    end
  end

  context 'when @source contains SVG files' do
    let :file_paths do
      %w[facebook github heart skull twitter].map { |i| "./spec/fixtures/icons/#{i}.svg" }
    end

    let(:file) { class_double(File) }

    before do
      allow_any_instance_of(Svgeez::Source).to receive(:file_paths).and_return(file_paths)

      allow(FileUtils).to receive(:mkdir_p)
      allow(File).to receive(:open).and_yield(file)
      allow(SecureRandom).to receive(:uuid).and_return('1234-abcd-5678-efgh')
    end

    context 'when @svgo is not specified' do
      let :builder do
        described_class.new(
          'source' => './spec/fixtures/icons',
          'destination' => './spec/fixtures/icons.svg'
        )
      end

      it 'writes a file' do
        expect(logger).to receive(:info).exactly(:twice)
        expect(file).to receive(:write).with(IO.read('./spec/fixtures/icons.svg'))

        builder.build
      end
    end

    context 'when @svgo is specified' do
      let :builder do
        described_class.new(
          'source' => './spec/fixtures/icons',
          'destination' => './spec/fixtures/icons-svgo.svg',
          'svgo' => true
        )
      end

      it 'writes a file' do
        expect(logger).to receive(:info).exactly(:twice)
        expect(file).to receive(:write).with(%(#{IO.read('./spec/fixtures/icons-svgo.svg')}\n))

        builder.build
      end
    end
  end
end
