# frozen_string_literal: true

RSpec.describe Svgeez::Source, "#file_paths" do
  let(:source) { described_class.new }

  let(:file_paths) do
    %w[facebook github heart skull twitter].map { |i| File.expand_path("./_svgeez/#{i}.svg") }
  end

  before do
    allow(Dir).to receive(:glob).and_return(file_paths)
  end

  it "returns an array of file paths" do
    expect(source.file_paths).to eq(file_paths)
  end
end
