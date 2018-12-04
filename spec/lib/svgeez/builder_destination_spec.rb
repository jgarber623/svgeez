describe Svgeez::Builder, '#destination' do
  let(:builder) { described_class.new }

  it 'returns an instance of Svgeez::Destination' do
    expect(builder.destination).to be_instance_of(Svgeez::Destination)
  end
end
