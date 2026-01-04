require "xml"

require "./Map.cr"
require "./Tileset.cr"
require "./Layer.cr"
require "./ObjectGroup.cr"
require "./ImageLayer.cr"
require "./Group.cr"
require "./Properties.cr"
require "./Template.cr"

# TODO: Parse optional nilable objects

module Tiled
  module Macros
    macro parse_node_of_class(node, class_name)
      {% puts "Parsing #{class_name}" %}
      %new_obj = Tiled::Macros.generate_object_with_default_args({{node}}, {{class_name}})
      Tiled::Macros.fill_object_with_default_properties(%new_obj, {{node}}, {{class_name}})
      Tiled::Macros.fill_arrays(%new_obj, {{node}}, {{class_name}})
      return %new_obj
    end

    macro cast_string_to_appropriate_value(str, type_name)
      {% if type_name.stringify == "String" %}
        {{str}}
      {% elsif type_name.stringify == "UInt32" %}
        {{str}}.to_u32
      {% elsif type_name.stringify == "Int32" %}
        {{str}}.to_i32
      {% elsif type_name.stringify == "Float32" %}
        {{str}}.to_f32
      {% elsif type_name.stringify == "Bool" %}
        ({{str}} != "0" ? true : false)
      {% else %}
        raise "Issue 1 for {{type_name}}"
      {% end %}
    end

    macro cast_node_to_appropriate_value(node, type_name)
      {{type_name}}.parse_from_node({{node}})
    end

    macro generate_object_with_default_args(node, class_name)
      {{class_name}}.new(
        {% for ivar in class_name.resolve.instance_vars %}
          {% unless ivar.has_default_value? %}
            {% puts "Checking required #{ivar.name} from #{class_name}" %}
            Tiled::Macros.cast_string_to_appropriate_value({{node}}[{{ivar.name.stringify}}], {{ivar.type}}),
          {% end %}
        {% end %}
      )
    end

    macro fill_object_with_default_properties(obj, node, class_name)
      {% for ivar in class_name.resolve.instance_vars %}
        {% if ivar.has_default_value? && !ivar.name.starts_with?("array_") %}
          {% puts "Checking default #{ivar.name} from #{class_name}" %}
          if {{node}}[{{ivar.name.stringify}}]?
            {{obj}}.{{ivar.name}} = Tiled::Macros.cast_string_to_appropriate_value({{node}}[{{ivar.name.stringify}}], {{ivar.type}})
          else
            {{obj}}.{{ivar.name}} = ({{ivar.default_value}})
          end
        {% end %}
      {% end %}
    end

    macro fill_arrays(obj, node, class_name)
      {% components = [] of StringLiteral %}
      {% component_types = {} of StringLiteral => TypeNode %}

      {% for ivar in class_name.resolve.instance_vars %}
        {% if ivar.name.starts_with?("array_") %}
          {% component_name = ivar.name.gsub(/array_/, "") %}
          {% components.push(component_name.stringify) %}
          {% component_types[component_name.stringify] = ivar.type.type_vars[0] %}
        {% end %}
      {% end %}

      {{node}}.children.each do |%child_node|
        {% for component_name in components %}
          if %child_node.name == {{component_name}}
            %new_value = Tiled::Macros.cast_node_to_appropriate_value(%child_node, {{component_types[component_name]}})
            {{obj}}.array_{{component_name.id}}.push(%new_value)
          end
        {% end %}
      end
    end
  end

  def self.parse_map_from_file(filename : String)
    File.open(filename, "r") do |f|
      parser = XML.parse(f)
      map_xml = parser.first_element_child

      if map_xml && map_xml.name == "map"
        return Tiled::Map.parse_from_node(map_xml)
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
        return Tiled::Tileset.parse_from_node(tileset_xml)
      else
        raise "Content of file #{filename} is not a tileset"
      end
    end
  end
end

puts Tiled.parse_map_from_file("ExampleMap.tmx").inspect
puts Tiled.parse_tileset_from_file("ExampleTileset.tsx").inspect
