describe Svgeez::SymbolElement do
  let(:uuid) { '1234-abcd-5678-efgh' }

  let(:file_id) { 'foo' }

  let(:symbol_element) { Svgeez::SymbolElement.new(file_path, file_id) }

  context '#build' do
    let(:file_path) { File.expand_path('./spec/fixtures/icons/facebook.svg') }

    before do
      allow(SecureRandom).to receive(:uuid).and_return(uuid)
    end

    it 'returns a string' do
      expect(symbol_element.build).to eq(%(<symbol id="foo-facebook" viewBox="0 0 10 18" xmlns:xlink="http://www.w3.org/1999/xlink">\n<g>\n\s\s<use xlink:href="#Path_1-#{uuid}" fill="#626262"/>\n</g>\n<defs>\n\s\s<path id="Path_1-#{uuid}" d="M0.896,6.12h1.758V4.411c0-0.754,0.019-1.916,0.567-2.635c0.576-0.762,1.368-1.28,2.729-1.28\n\s\s\s\sc2.22,0,3.153,0.316,3.153,0.316l-0.44,2.605c0,0-0.732-0.212-1.416-0.212S5.95,3.45,5.95,4.134V6.12h2.805L8.56,8.665H5.95v8.839\n\s\s\s\sH2.654V8.665H0.896V6.12z"/>\n</defs>\n</symbol>))
    end
  end

  context '#build with links' do
    let(:file_path) { File.expand_path('./spec/fixtures/icons/with_filter.svg') }

    before do
      allow(SecureRandom).to receive(:uuid).and_return(uuid)
    end

    it 'returns a string with substituted urls' do
      expect(symbol_element.build).to eq(%(<symbol id="foo-with_filter" viewBox="0 0 230 120" xmlns:xlink="http://www.w3.org/1999/xlink">\n\n <filter id="blurMe-1234-abcd-5678-efgh">\n  <feGaussianBlur in="SourceGraphic" stdDeviation="5"/>\n </filter>\n\n <circle cx="60"  cy="60" r="50" fill="green" />\n <circle cx="170" cy="60" r="50" fill="green" filter="url(#blurMe-1234-abcd-5678-efgh)" />\n</symbol>))
    end
  end
end
