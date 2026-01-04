module Tiled
  struct Layer
    struct Data
      property encoding : String = ""
      property compression : String = ""

      property content : Array(UInt32) = [] of UInt32

      property array_tile : Array(Tile) = [] of Tile
      property array_chunk : Array(Chunk) = [] of Layer::Chunk

      def self.parse_from_node(node : XML::Node)
        # NOTE: Special handling for data blocks specifically
        new_data = Tiled::Macros.parse_node_of_class(node, Tiled::Layer::Data)
        new_data.content = node.content.split(",").map {|str| str.to_u32}
        return new_data
      end
    end

    struct Chunk
      property x : Int32
      property y : Int32
      property width : UInt32
      property height : UInt32

      property array_tile : Array(Tile) = [] of Tile

      def initialize(@x, @y, @width, @height)
      end

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::Layer::Chunk)
      end
    end

    struct Tile
      property gid : UInt32 = 0

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::Layer::Tile)
      end
    end

    property id : UInt32 = 0
    property name : String = ""
    property class : String = ""
    property x : Int32 = 0
    property y : Int32 = 0
    property width : UInt32
    property height : UInt32
    property opacity : Float32 = 1.0
    property visible : Bool = true
    property tintcolor : String = ""
    property offsetx : Int32 = 0
    property offsety : Int32 = 0
    property parallaxx : Float32 = 1.0
    property parallaxy : Float32 = 1.0

    property properties : Properties? = nil
    property data : Data? = nil

    def initialize(@width, @height)
    end

    def self.parse_from_node(node : XML::Node)
      return Tiled::Macros.parse_node_of_class(node, Tiled::Layer)
    end
  end
end
