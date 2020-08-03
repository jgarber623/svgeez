RSpec.describe Svgeez::Elements::SvgElement, '#build' do
  let(:source) { instance_double(Svgeez::Source) }
  let(:destination) { instance_double(Svgeez::Destination) }
  let(:symbol_element) { instance_double(Svgeez::Elements::SymbolElement) }

  let(:svg_element) { described_class.new(source, destination, destination.file_id) }

  before do
    allow(Svgeez::Source).to receive(:new).and_return(source)
    allow(Svgeez::Destination).to receive(:new).and_return(destination)
    allow(Svgeez::Elements::SymbolElement).to receive(:new).and_return(symbol_element)

    allow(source).to receive(:file_paths).and_return([File.expand_path('./spec/fixtures/icons/skull.svg')])
    allow(destination).to receive(:file_id).and_return('foo')
    allow(symbol_element).to receive(:build).and_return('<foo/>')
  end

  it 'returns a string' do
    expect(svg_element.build).to eq(%(<svg id="foo" xmlns="http://www.w3.org/2000/svg"><foo/></svg>))
  end
end
