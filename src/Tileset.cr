module Tiled
  class Tileset
    class TileOffset
      property x : Int32 = 0
      property y : Int32 = 0
    end

    class Grid
      property orientation : String = "orthogonal"
      property width : UInt32
      property height : UInt32
    end
    
    class Image
      property format : String = ""
      property source : String = ""
      property trans : String = ""
      property width : UInt32 = 0
      property height : UInt32 = 0

      property data : Data
    end

    class Transformations
      property hflip : Bool = false
      property vflip : Bool = false
      property rotate : Bool = false
      property preferuntransformed : Bool = false
    end

    class Tile
      class Animation
        class Frame
          property tileid : UInt32
          property duration : UInt32
        end

        property array_frame : Array(Frame) = [] of Frame
      end
  
      property id : UInt32
      property type : String = ""
      property probability : Float32 = 0.0
      property x : UInt32 = 0
      property y : UInt32 = 0
      property width : UInt32 = 0
      property height : UInt32 = 0
    end

    class WangSets
      class WangSet
        property name : String
        property class : String = ""
        property tile : UInt32

        property properties : Properties? = nil
        property array_wangcolor : Array(WangColor) = [] of WangColor
        property array_wangtile : Array(WangTile) = [] of WangTile
      end

      class WangColor
        property name : String
        property class : String = ""
        property color : String
        property tile : UInt32
        property probability : Float32 = 0.0
      end

      class WangTile
        property tileid : UInt32
        property wangid : String
      end

      property array_wangset : Array(WangSet) = [] of WangSet
    end

    property firstgid : UInt32
    property source : String = ""
    property name : String
    property class : String = ""
    property tilewidth : UInt32
    property tileheight : UInt32
    property spacing : UInt32 = 0
    property margin : UInt32 = 0
    property tilecount : UInt32
    property columns : UInt32
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
  end
end
