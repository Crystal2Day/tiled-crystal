module Tiled
  struct Tileset
    struct TileOffset
      property x : Int32 = 0
      property y : Int32 = 0

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset::TileOffset)
      end
    end

    struct Grid
      property orientation : String = "orthogonal"
      property width : UInt32
      property height : UInt32

      def initialize(@width, @height)
      end

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset::Grid)
      end
    end
    
    struct Image
      property format : String = ""
      property source : String = ""
      property trans : String = ""
      property width : UInt32 = 0
      property height : UInt32 = 0

      property data : Layer::Data

      def initialize(@data)
      end

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset::Image)
      end
    end

    struct Transformations
      property hflip : Bool = false
      property vflip : Bool = false
      property rotate : Bool = false
      property preferuntransformed : Bool = false

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset::Transformations)
      end
    end

    struct Tile
      struct Animation
        struct Frame
          property tileid : UInt32
          property duration : UInt32

          def initialize(@tileid, @duration)
          end

          def self.parse_from_node(node : XML::Node)
            return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset::Tile::Animation::Frame)
          end
        end

        property array_frame : Array(Frame) = [] of Frame

        def self.parse_from_node(node : XML::Node)
          return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset::Tile::Animation)
        end
      end
  
      property id : UInt32
      property type : String = ""
      property probability : Float32 = 0.0
      property x : UInt32 = 0
      property y : UInt32 = 0
      property width : UInt32 = 0
      property height : UInt32 = 0

      def initialize(@id)
      end

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset::Tile)
      end
    end

    struct WangSets
      struct WangSet
        property name : String
        property class : String = ""
        property tile : UInt32

        property properties : Properties? = nil
        property array_wangcolor : Array(WangColor) = [] of WangColor
        property array_wangtile : Array(WangTile) = [] of WangTile

        def initialize(@name, @tile)
        end

        def self.parse_from_node(node : XML::Node)
          return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset::WangSets::WangSet)
        end
      end

      struct WangColor
        property name : String
        property class : String = ""
        property color : String
        property tile : UInt32
        property probability : Float32 = 0.0

        def initialize(@name, @color, @tile)
        end

        def self.parse_from_node(node : XML::Node)
          return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset::WangSets::WangColor)
        end
      end

      struct WangTile
        property tileid : UInt32
        property wangid : String

        def initialize(@tileid, @wangid)
        end

        def self.parse_from_node(node : XML::Node)
          return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset::WangSets::WangTile)
        end
      end

      property array_wangset : Array(WangSet) = [] of WangSets::WangSet

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset::WangSets)
      end
    end

    property firstgid : UInt32 = 0
    property source : String = ""
    property name : String = ""
    property class : String = ""
    property tilewidth : UInt32 = 0
    property tileheight : UInt32 = 0
    property spacing : UInt32 = 0
    property margin : UInt32 = 0
    property tilecount : UInt32 = 0
    property columns : UInt32 = 0
    property objectalignment : String = "unspecified"
    property tilerendersize : String = "tile"
    property fillmode : String = "stretch"

    property image : Image? = nil
    property tileoffset : TileOffset? = nil
    property grid : Grid? = nil
    property properties : Properties? = nil
    property wangsets : WangSets? = nil
    property transformations : Transformations? = nil

    property array_tile : Array(Tile) = [] of Tile

    def self.parse_from_node(node : XML::Node)
      return Tiled::Macros.parse_node_of_class(node, Tiled::Tileset)
    end
  end
end
