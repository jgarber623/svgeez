describe Svgeez::Builder, '#source' do
  let(:builder) { described_class.new }

  it 'returns an instance of Svgeez::Source' do
    expect(builder.source).to be_instance_of(Svgeez::Source)
  end
end
