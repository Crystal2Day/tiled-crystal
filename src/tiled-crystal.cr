require "xml"

require "./Map.cr"
require "./Tileset.cr"
require "./Layer.cr"
require "./ObjectGroup.cr"
require "./ImageLayer.cr"
require "./Group.cr"
require "./Properties.cr"
require "./Template.cr"

module Tiled
  macro parse_basic_properties(node, class_name)
    puts "Parsing {{class_name}}"
    {% for ivar in class_name.resolve.instance_vars %}
      if {{node}}[{{ivar.name.stringify}}]? 
        puts "> Given: {{ivar.name}} ({{ivar.type}}) -> #{{{node}}[{{ivar.name.stringify}}].inspect}"
      else
        {% if ivar.has_default_value? %}
          "> Default: {{ivar.name}} ({{ivar.type}}) -> #{({{ivar.default_value}}).inspect}"
        {% else %}
          "> ERROR: {{ivar.name}} not specified in file."
        {% end %}
      end
      # TODO: Generate object
    {% end %}

    # TODO: Process arrays and objects
    {{node}}.children.each do |child_node|
      next if child_node.text?
      puts "Child node: #{child_node.name}"
    end
  end

  def self.parse_map_from_file(filename : String)
    File.open(filename, "r") do |f|
      parser = XML.parse(f)
      map_xml = parser.first_element_child

      if map_xml && map_xml.name == "map"
        return Map.parse_from_node(map_xml)
      else
        raise "Content of file #{filename} is not a map"
      end
    end
  end

   def self.parse_tileset_from_file(filename : String)
    File.open(filename, "r") do |f|
      parser = XML.parse(f)
      tileset_xml = parser.first_element_child

      if tileset_xml && tileset_xml.name == "tileset"
        return Tileset.parse_from_node(tileset_xml)
      else
        raise "Content of file #{filename} is not a tileset"
      end
    end
  end
end

Tiled.parse_map_from_file("ExampleMap.tmx")
Tiled.parse_tileset_from_file("ExampleTileset.tsx")
