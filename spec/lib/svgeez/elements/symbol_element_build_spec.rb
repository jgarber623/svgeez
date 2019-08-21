describe Svgeez::Elements::SymbolElement, '#build' do
  let(:uuid) { '1234-abcd-5678-efgh' }
  let(:file_path) { File.expand_path('./spec/fixtures/icons/facebook.svg') }
  let(:file_id) { 'foo' }
  let(:symbol_element) { described_class.new(file_path, file_id) }

  before do
    allow(SecureRandom).to receive(:uuid).and_return(uuid)
  end

  it 'returns a string' do
    expect(symbol_element.build).to eq(%(<symbol id="foo-facebook" viewBox="0 0 10 18" xmlns:xlink="http://www.w3.org/1999/xlink">\n<g>\n\s\s<use xlink:href="#Path_1-#{uuid}" fill="#626262"/>\n</g>\n\n</symbol>))
  end
end
