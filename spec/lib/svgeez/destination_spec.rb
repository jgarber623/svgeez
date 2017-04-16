describe Svgeez::Destination do
  describe '#file_id' do
    context 'when @destination is not specified' do
      let(:destination) { Svgeez::Destination.new }

      it 'returns the default file ID' do
        expect(destination.file_id).to eq('svgeez')
      end
    end

    context 'when @destination is specified' do
      let :destination do
        Svgeez::Destination.new(
          'destination' => './foo.svg'
        )
      end

      it 'returns the specified file ID' do
        expect(destination.file_id).to eq('foo')
      end
    end
  end

  describe '#file_name' do
    context 'when @destination is not specified' do
      let(:destination) { Svgeez::Destination.new }

      it 'returns the default file name' do
        expect(destination.file_name).to eq('svgeez.svg')
      end
    end

    context 'when @destination is specified' do
      context 'when @destination is a folder path' do
        let :destination do
          Svgeez::Destination.new(
            'destination' => './foo'
          )
        end

        it 'returns the default file name' do
          expect(destination.file_name).to eq('svgeez.svg')
        end
      end

      context 'when @destination is a file name' do
        let :destination do
          Svgeez::Destination.new(
            'destination' => './foo.svg'
          )
        end

        it 'returns the specified file name' do
          expect(destination.file_name).to eq('foo.svg')
        end
      end
    end
  end

  describe '#file_path' do
    context 'when @destination is not specified' do
      let(:destination) { Svgeez::Destination.new }

      it 'returns the default file path' do
        expect(destination.file_path).to eq(File.expand_path('./svgeez.svg'))
      end
    end

    context 'when @destination is specified' do
      context 'when @destination is a folder path' do
        let :destination do
          Svgeez::Destination.new(
            'destination' => './foo'
          )
        end

        it 'returns the specified file path' do
          expect(destination.file_path).to eq(File.expand_path('./foo/svgeez.svg'))
        end
      end

      context 'when @destination is a file name' do
        let :destination do
          Svgeez::Destination.new(
            'destination' => './foo/bar.svg'
          )
        end

        it 'returns the specified file path' do
          expect(destination.file_path).to eq(File.expand_path('./foo/bar.svg'))
        end
      end
    end
  end

  describe '#folder_path' do
    context 'when @destination is not specified' do
      let(:destination) { Svgeez::Destination.new }

      it 'returns the default folder path' do
        expect(destination.folder_path).to eq(File.expand_path('.'))
      end
    end

    context 'when @destination is specified' do
      context 'when @destination is a folder path' do
        let :destination do
          Svgeez::Destination.new(
            'destination' => './foo'
          )
        end

        it 'returns the specified folder path' do
          expect(destination.folder_path).to eq(File.expand_path('./foo'))
        end
      end

      context 'when @destination is a file name' do
        let :destination do
          Svgeez::Destination.new(
            'destination' => './foo/bar.svg'
          )
        end

        it 'returns the specified folder path' do
          expect(destination.folder_path).to eq(File.expand_path('./foo'))
        end
      end
    end
  end
end
