describe Svgeez::SvgElement do
  let(:source) { Svgeez::Source.new }

  let(:destination) { Svgeez::Destination.new }

  let(:svg_element) { Svgeez::SvgElement.new(source, destination) }

  context '#build' do
    before do
      allow_any_instance_of(Svgeez::SymbolElement).to receive(:build).and_return('<foo/>')

      allow(source).to receive(:file_paths).and_return([File.expand_path('./spec/fixtures/icons/skull.svg')])
      allow(destination).to receive(:file_id).and_return('foo')
    end

    it 'returns a string' do
      expect(svg_element.build).to eq(%(<svg id="foo" version="1.1" xmlns="http://www.w3.org/2000/svg"><foo/></svg>))
    end
  end
end
