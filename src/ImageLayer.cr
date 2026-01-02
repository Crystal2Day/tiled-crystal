module Tiled
  class ImageLayer
    property id : UInt32 = 0
    property name : String = ""
    property class : String = ""
    property offsetx : Int32 = 0
    property offsety : Int32 = 0
    property parallaxx : Float32 = 1.0
    property parallaxy : Float32 = 1.0
    property opacity : Float32 = 1.0
    property visible : Bool = true
    property tintcolor : String = ""
    property repeatx : Bool = false
    property repeaty : Bool = false

    property properties : Properties? = nil
    property image : Tileset::Image? = nil
  end
end
