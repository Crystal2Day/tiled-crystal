require "xml"

module Tiled
  struct ParsedTileset
    property image_file : String = ""
    property name : String
    property tile_width : UInt32
    property tile_height : UInt32
    property tile_count : UInt32
    property tile_properties : Array(TileProperties)
    property tile_animations : Array(Array(TileAnimationFrame)) = [] of Array(TileAnimationFrame)
  
    def initialize(@name : String, @tile_width : UInt32, @tile_height : UInt32, @tile_count : UInt32)
      @tile_properties = Array(TileProperties).new(size: @tile_count) {TileProperties.new}
      @tile_animations = Array(Array(TileAnimationFrame)).new(size: @tile_count) {Array(TileAnimationFrame).new}
    end
  end
  
  struct ParsedMap
    property width : UInt32
    property height : UInt32
    property tile_width : UInt32
    property tile_height : UInt32
    property tileset_file : String = ""
    property layers = [] of ParsedLayer
  
    def initialize(@width : UInt32, @height : UInt32, @tile_width : UInt32, @tile_height : UInt32)
    end
  end
  
  struct ParsedLayer
    property width : UInt32
    property height : UInt32
    property name : String
    property content : Array(UInt32)
  
    def initialize(@width : UInt32, @height : UInt32, @name : String)
      @content = Array(UInt32).new(initial_capacity: @width * @height)
    end
  end
  
  struct TileProperties
    property properties = {} of String => Bool | Int32 | String | Float32
  
    def initialize
    end
  
    def add(name, value)
      @properties[name] = value
    end
  end

  struct TileAnimationFrame
    property tile_id : UInt32
    property duration : UInt32

    def initialize(@tile_id : UInt32, @duration : UInt32)
    end
  end
  
  def self.parse_tileset(filename : String)
    File.open(filename, "r") do |f|
      parser = XML.parse(f)
      tileset_xml = parser.first_element_child

      if tileset_xml && tileset_xml.name == "tileset"
        tileset = ParsedTileset.new(tileset_xml["name"], tileset_xml["tilewidth"].to_u32, tileset_xml["tileheight"].to_u32, tileset_xml["tilecount"].to_u32)

        tileset_xml.children.each do |node|
          next if node.text?

          case node.name
          when "image" then
            tileset.image_file = node["source"]
          when "tile" then
            tile_id = node["id"].to_u32
            
            node.children.each do |node_child|
              if node_child.name == "properties"
                properties = node_child
                properties.children.each do |prop|
                  next if prop.text?

                  prop_name = prop["name"]
                  prop_type = prop["type"]?
                  prop_value = prop["value"]

                  case prop_type
                  when nil
                    tileset.tile_properties[tile_id].add(prop_name, prop_value)
                  when "bool"
                    tileset.tile_properties[tile_id].add(prop_name, prop_value == "true" ? true : false)
                  when "int"
                    tileset.tile_properties[tile_id].add(prop_name, prop_value.to_i32)
                  when "float"
                    tileset.tile_properties[tile_id].add(prop_name, prop_value.to_f32)
                  else
                    puts "Property type not supported: #{prop_type}"
                  end
                end
              elsif node_child.name == "animation"
                animations = node_child
                animations.children.each do |anim|
                  next if anim.text?
                  tileset.tile_animations[tile_id].push(TileAnimationFrame.new(anim["tileid"].to_u32, anim["duration"].to_u32))
                end
              end
            end
          else
            puts "Node name not supported: #{node.name}"
          end
        end
        return tileset
      else
        raise "ERROR"
      end
    end
  end

  def self.parse_map(filename : String)
    File.open(filename, "r") do |f|
      parser = XML.parse(f)
      map_xml = parser.first_element_child

      if map_xml && map_xml.name == "map"
        if map_xml["renderorder"] != "right-down" || map_xml["orientation"] != "orthogonal" || map_xml["infinite"] != "0"
          raise "ERROR"
        end

        # TODO: Tile sizes MAY differ from tileset values, implement this in Crystal2Day at some point
        map = ParsedMap.new(map_xml["width"].to_u32, map_xml["height"].to_u32, map_xml["tilewidth"].to_u32, map_xml["tileheight"].to_u32)
        
        map_xml.children.each do |node|
          next if node.text?

          case node.name
          when "tileset" then
            map.tileset_file = node["source"]
          when "layer" then
            layer = ParsedLayer.new(node["width"].to_u32, node["height"].to_u32, node["name"])

            node.children.each do |layer_node|
              next if layer_node.text?

              case layer_node.name
              when "data" then
                elements = layer_node.content.gsub("\n", "").split(",")
                elements.each do |element|
                  layer.content.push element.to_u32
                end

                map.layers.push(layer)
              else
                puts "Node name not supported: #{layer_node.name}"
              end
            end
          else
            puts "Node name not supported: #{node.name}"
          end
        end
        return map
      else
        raise "ERROR"
      end
    end
  end
end
