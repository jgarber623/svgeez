# frozen_string_literal: true

RSpec.describe Svgeez::Elements::SymbolElement, "#build" do
  let(:uuid) { "1234-abcd-5678-efgh" }
  let(:file_path) { File.expand_path("./spec/fixtures/icons/facebook.svg") }
  let(:file_id) { "foo" }

  before do
    allow(SecureRandom).to receive(:uuid).and_return(uuid)
  end

  it "returns a string" do
    symbol_element = described_class.new(file_path, file_id)
    expect(symbol_element.build).to eq(%(<symbol id="foo-facebook" viewBox="0 0 10 18" xmlns:xlink="http://www.w3.org/1999/xlink">\n<g>\n\s\s<use xlink:href="#Path_1-#{uuid}" fill="#626262"/>\n</g>\n<defs>\n\s\s<path id="Path_1-#{uuid}" filter="url(#blurMe-#{uuid})" d="M0.896,6.12h1.758V4.411c0-0.754,0.019-1.916,0.567-2.635c0.576-0.762,1.368-1.28,2.729-1.28\n\s\s\s\sc2.22,0,3.153,0.316,3.153,0.316l-0.44,2.605c0,0-0.732-0.212-1.416-0.212S5.95,3.45,5.95,4.134V6.12h2.805L8.56,8.665H5.95v8.839\n\s\s\s\sH2.654V8.665H0.896V6.12z"/>\n\s\s<filter id="blurMe-#{uuid}">\n\s\s\s\s<feGaussianBlur in="SourceGraphic" stdDeviation="5"/>\n\s\s</filter>\n</defs>\n</symbol>))
  end

  context "when file_id is blank" do
    it "only uses filename of file_path as id attribute" do
      symbol_element = described_class.new(file_path, "")
      expect(symbol_element.build).to match(/id="facebook"/)
    end
  end

  context "when file_id is provided" do
    it "includes file_id in id attribute" do
      symbol_element = described_class.new(file_path, "icon")
      expect(symbol_element.build).to match(/id="icon-facebook"/)
    end
  end
end
