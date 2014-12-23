require 'rspec'
require 'stl_parser'

describe STLParser do

  let(:parser) do
    STLParser.new('./spec/cube.stl')
  end

  describe '#initialize' do
    it 'initializes with an stl file' do
      expect(parser.file).to eq('./spec/cube.stl')
    end
  end

  describe '#readline' do
    it 'reads the first line on initialization' do
      expect(parser.send(:readline)).to eq('solid OpenSCAD_Model44')
    end
    it 'reads consecutive lines' do
      parser.send(:readline)
      expect(parser.send(:readline)).to eq('facet normal -1.000000 -0.000000 -0.000000')
    end
  end

  describe '#reopen' do
    it 'reopens a file' do
      parser.send(:readline)
      parser.send(:readline)
      expect(parser.send(:reopen)).to eq('solid OpenSCAD_Model44')
    end
  end

  describe '#parse' do
    it 'parses a file and returns the correct results' do
      expect(parser.parse).to eq([44, 22])
    end

    it 'calculates the correct number of faces' do
      parser.parse
      expect(parser.num_faces).to eq(44)
    end

    it 'calculates the correct number of vertexes' do
      parser.parse
      expect(parser.num_vertices).to eq(22)
    end
  end

end
