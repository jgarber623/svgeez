describe Svgeez do
  describe '.logger' do
    it 'returns an instance of Logger.' do
      expect(Svgeez.logger).to be_an_instance_of(Logger)
    end
  end
end
