require 'json'
require 'linkeddata'

# Read JSON data from file
file_path = './dumps/entities.json'
json_data = File.read(file_path)
graph = RDF::Graph.new
base_url = "https://www.laval.ca"
replace_blank_nodes_sparql_file = File.read('./sparql/replace-blank-nodes.sparql')
add_derived_from_sparql_file = File.read('./sparql/add-derived-from.sparql')

# Parse JSON
data = JSON.parse(json_data)

# Initialize a hash to store key-value pairs
location_info = {}

# Iterate through each object in the JSON data
data.each do |event|
  if event['Locations'].length != 0
    event['Locations'].each do |location|
      # Extract Id and TargetUrl and store as key-value pairs
      location_info[location['Id']] = location['TargetUrl']
    end
  end
end

location_info.each do |key, value|
  url = base_url + value
  id = "https://www.laval.ca/" + key
  puts id
  place_graph = RDF::Graph.load(url)
  replace_blank_node_sparql_file_with_id = replace_blank_nodes_sparql_file.gsub("place_url", id)
  place_graph.query(SPARQL.parse(replace_blank_node_sparql_file_with_id, update: true))
  add_derived_from_sparql_file_with_id = add_derived_from_sparql_file.gsub("subject_url", url)
  place_graph.query(SPARQL.parse(add_derived_from_sparql_file_with_id, update: true))
  graph << place_graph
  rescue StandardError => e
    puts "Error loading RDF from #{url}: #{e.message}"
    break
end

File.write('./dumps/places.ttl', graph.dump(:ttl))

file1 = RDF::Turtle::Reader.open("./dumps/entities.ttl")
file2 = RDF::Turtle::Reader.open("./dumps/places.ttl")

combined_statements = file1.to_a + file2.to_a

RDF::Turtle::Writer.open("./dumps/entities.ttl") do |writer|
  combined_statements.each do |statement|
    writer << statement
  end
end
