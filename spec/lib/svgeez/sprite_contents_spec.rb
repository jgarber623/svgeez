# frozen_string_literal: true

RSpec.describe Svgeez::Sprite, "#contents" do
  let(:data) { File.read(File.expand_path("../../fixtures/icons/facebook.svg", __dir__)) }
  let(:uuid) { "1234-abcd-5678-efgh" }

  before do
    allow(SecureRandom).to receive(:uuid).and_return(uuid)
  end

  context "with no prefix" do
    it "returns a String" do
      expect(described_class.new(data, basename: "facebook").contents).to eq(
        # rubocop:disable Layout/LineLength
        %(<symbol id="facebook" viewBox="0 0 10 18" xmlns:xlink="http://www.w3.org/1999/xlink">\n<g>\n\s\s<use xlink:href="#Path_1-#{uuid}" fill="#626262"/>\n</g>\n<defs>\n\s\s<path id="Path_1-#{uuid}" filter="url(#blurMe-#{uuid})" d="M0.896,6.12h1.758V4.411c0-0.754,0.019-1.916,0.567-2.635c0.576-0.762,1.368-1.28,2.729-1.28\n\s\s\s\sc2.22,0,3.153,0.316,3.153,0.316l-0.44,2.605c0,0-0.732-0.212-1.416-0.212S5.95,3.45,5.95,4.134V6.12h2.805L8.56,8.665H5.95v8.839\n\s\s\s\sH2.654V8.665H0.896V6.12z"/>\n\s\s<filter id="blurMe-#{uuid}">\n\s\s\s\s<feGaussianBlur in="SourceGraphic" stdDeviation="5"/>\n\s\s</filter>\n</defs>\n</symbol>)
        # rubocop:enable Layout/LineLength
      )
    end
  end

  context "with prefix" do
    it "returns a String" do
      expect(described_class.new(data, basename: "facebook", prefix: "foo").contents).to eq(
        # rubocop:disable Layout/LineLength
        %(<symbol id="foo-facebook" viewBox="0 0 10 18" xmlns:xlink="http://www.w3.org/1999/xlink">\n<g>\n\s\s<use xlink:href="#Path_1-#{uuid}" fill="#626262"/>\n</g>\n<defs>\n\s\s<path id="Path_1-#{uuid}" filter="url(#blurMe-#{uuid})" d="M0.896,6.12h1.758V4.411c0-0.754,0.019-1.916,0.567-2.635c0.576-0.762,1.368-1.28,2.729-1.28\n\s\s\s\sc2.22,0,3.153,0.316,3.153,0.316l-0.44,2.605c0,0-0.732-0.212-1.416-0.212S5.95,3.45,5.95,4.134V6.12h2.805L8.56,8.665H5.95v8.839\n\s\s\s\sH2.654V8.665H0.896V6.12z"/>\n\s\s<filter id="blurMe-#{uuid}">\n\s\s\s\s<feGaussianBlur in="SourceGraphic" stdDeviation="5"/>\n\s\s</filter>\n</defs>\n</symbol>)
        # rubocop:enable Layout/LineLength
      )
    end
  end
end
