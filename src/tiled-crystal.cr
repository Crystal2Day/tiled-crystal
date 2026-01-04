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

  module Macros
    macro parse_node_of_class(node, class_name)
      # Main routine to parse an XML node into a class
      %new_obj = Tiled::Macros.generate_object_with_default_args({{node}}, {{class_name}})
      Tiled::Macros.fill_object_with_basic_properties(%new_obj, {{node}}, {{class_name}})
      Tiled::Macros.fill_arrays_and_optionals(%new_obj, {{node}}, {{class_name}})
      %new_obj
    end

    macro cast_string_to_appropriate_value(str, type_name)
      # Cast the string of an XML node into a trivial value
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
        # We actually need these special cases so the macro interpreter doesn't complain
        raise "This should not happen (Error code 1)"
      {% end %}
    end

    macro cast_node_to_appropriate_value(node, type_name)
      # General routine to cast an XML node into a value
      {% if type_name.stringify.starts_with?("Array") %}
        raise "This should not happen (Error code 2)"
      {% elsif type_name.stringify == "String" || type_name.stringify == "UInt32" || type_name.stringify == "Int32" || type_name.stringify == "Float32" || type_name.stringify == "Bool" %}
        # Handle trivial types
        Tiled::Macros.cast_string_to_appropriate_value({{node}}.content, {{type_name}})
      {% elsif type_name.is_a?(Expressions) %}
        # Treat nilable unions properly
        {% reduced_type_name = type_name.expressions[0].receiver %}
        {% if reduced_type_name.stringify == "String" || reduced_type_name.stringify == "UInt32" || reduced_type_name.stringify == "Int32" || reduced_type_name.stringify == "Float32" || reduced_type_name.stringify == "Bool" %}
          Tiled::Macros.cast_string_to_appropriate_value({{node}}.content, {{reduced_type_name}})
        {% elsif reduced_type_name.stringify.starts_with?("Array") %}
          raise "This should not happen (Error code 3)"
        {% else %}
          {{reduced_type_name}}.parse_from_node({{node}})
        {% end %}
      {% else %}
        # We could technically call the current routine once more, but that would lead to infinite recursion, so the actual method is safer
        {{type_name}}.parse_from_node({{node}})
      {% end %}
    end

    macro generate_object_with_default_args(node, class_name)
      # Initialize the object with its required arguments
      {{class_name}}.new(
        {% for ivar in class_name.resolve.instance_vars %}
          {% unless ivar.has_default_value? %}
            Tiled::Macros.cast_string_to_appropriate_value({{node}}[{{ivar.name.stringify}}], {{ivar.type}}),
          {% end %}
        {% end %}
      )
    end

    macro fill_object_with_basic_properties(obj, node, class_name)
      # Add the optional basic properties
      {% for ivar in class_name.resolve.instance_vars %}
        {% if ivar.has_default_value? && !ivar.name.starts_with?("array_") %}
          if {{node}}[{{ivar.name.stringify}}]?
            {{obj}}.{{ivar.name}} = Tiled::Macros.cast_string_to_appropriate_value({{node}}[{{ivar.name.stringify}}], {{ivar.type}})
          else
            {{obj}}.{{ivar.name}} = ({{ivar.default_value}})
          end
        {% end %}
      {% end %}
    end

    macro fill_arrays_and_optionals(obj, node, class_name)
      # Finally, add optional child nodes and arrays
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
        # Check all potential array properties
        {% for component_name in components %}
          if %child_node.name == {{component_name}}
            %new_value = Tiled::Macros.cast_node_to_appropriate_value(%child_node, {{component_types[component_name]}})
            {{obj}}.array_{{component_name.id}}.push(%new_value)
          end
        {% end %}

        # Check all potential nilable properties
        {% for ivar in class_name.resolve.instance_vars %}
          if %child_node.name == {{ivar.name.stringify}}
            {{obj}}.{{ivar.name}} = Tiled::Macros.cast_node_to_appropriate_value(%child_node, {{ivar.type}})
          end
        {% end %}
      end
    end
  end
end
