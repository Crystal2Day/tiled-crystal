module Tiled
  struct Group
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

    property properties : Properties? = nil

    property array_layer : Array(Layer) = [] of Layer
    property array_objectgroup : Array(ObjectGroup) = [] of ObjectGroup
    property array_imagelayer : Array(ImageLayer) = [] of ImageLayer
    property array_group : Array(Group) = [] of Group
  end
end
