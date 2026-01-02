module Tiled
  class Layer
    class Data
      property encoding : String = ""
      property compression : String = ""

      property array_tile : Array(Tile) = [] of Tile
      property array_chunk : Array(Chunk) = [] of Chunk
    end

    class Chunk
      property x : Int32
      property y : Int32
      property width : UInt32
      property height : UInt32

      property array_tile : Array(Tile) = [] of Tile
    end

    class Tile
      property gid : UInt32 = 0
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
  end
end
