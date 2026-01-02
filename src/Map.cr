module Tiled
  struct Map
    property version : String
    property tiledversion : String
    property class : String = ""
    property orientation : String = "orthogonal"
    property renderorder : String = "right-down"
    property compressionlevel : Int32 = -1
    property width : UInt32
    property height : UInt32
    property tilewidth : UInt32
    property tileheight : UInt32
    property hexsidelength : UInt32 = 0
    property staggeraxis : String = ""
    property staggerindex : String = ""
    property parallaxoriginx : Float32 = 0.0
    property parallaxoriginy : Float32 = 0.0
    property backgroundcolor : String = "#00000000"
    property nextlayerid : UInt32
    property nextobjectid : UInt32
    property infinite : Bool = false

    property properties : Properties? = nil
    # Skipped: editorsettings
    property array_tileset : Array(Tileset) = [] of Tileset
    property array_layer : Array(Layer) = [] of Layer
    property array_objectgroup : Array(ObjectGroup) = [] of ObjectGroup
    property array_imagelayer : Array(ImageLayer) = [] of ImageLayer
    property array_group : Array(Group) = [] of Group

    def initialize(@version, @tiledversion, @width, @height, @tilewidth, @tileheight, @nextlayerid, @nextobjectid)
    end

    def self.parse_from_node(map_xml : XML::Node)
      Tiled.parse_basic_properties(map_xml, Tiled::Map)
    end
  end
end
