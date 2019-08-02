describe Svgeez, '.logger' do
  it 'returns an instance of Logger.' do
    expect(described_class.logger).to be_an_instance_of(Logger)
  end
end
