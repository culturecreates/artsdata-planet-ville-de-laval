require 'minitest/autorun'
require 'linkeddata'

class ReplaceBlankNodesTest < Minitest::Test
  def setup
    sparql_file = './sparql/replace-blank-nodes.sparql'
    @sparql = SPARQL.parse(File.read(sparql_file).gsub('place_url','http://my_place.com'), update: true)
  end

  def test_blank_nodes_per_entity
    graph = RDF::Graph.load("./tests/fixtures/blank_nodes_2_entities.jsonld")
    # puts "before: #{graph.dump(:jsonld)}"
    graph.query(@sparql)
    puts "after: #{graph.dump(:jsonld)}"

    expected = false
    actual = graph.query([RDF::URI('http://my_place.com'), RDF::type, RDF::Vocab::SCHEMA.Place])&.first&.node?
    assert_equal expected, actual, "my_place.com should not be a blank node"

    expected = 1
    actual = graph.query([RDF::URI('http://my_place.com'), RDF::Vocab::SCHEMA.name, nil]).count
    assert_equal expected, actual, "Different entities should not be merged"



  end



end
