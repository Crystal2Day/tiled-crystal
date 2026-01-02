module Tiled
  class ObjectGroup
    class TiledObject # Renamed to avoid issues
      property id : UInt32 = 0
      property name : String = ""
      property type : String = ""
      property x : Int32 = 0
      property y : Int32 = 0
      property width : UInt32 = 0
      property height : UInt32 = 0
      property rotation : Float32 = 0.0
      property gid : UInt32? = nil
      property visible : Bool = true
      property template : String = ""

      property properties : Properties? = nil
      property ellipse : Ellipse? = nil
      property point : Point? = nil
      property polygon : Polygon? = nil
      property polyline : Polyline? = nil
      property text : Text? = nil
    end

    class Ellipse
    end

    class Point
    end

    class Polygon
      property points : String
    end

    class Polyline
      property points : String
    end

    class Text
      property fontfamily : String = "sans-serif"
      property pixelsize : UInt32 = 16
      property wrap : Bool = false
      property color : String = "#000000"
      property bold : Bool = false
      property italic : Bool = false
      property underline : Bool = false
      property strikeout : Bool = false
      property kerning : Bool = true
      property halign : String = "left"
      property valign : String = "top"
    end

    property id : UInt32 = 0
    property name : String = ""
    property class : String = ""
    property color : String = ""
    property x : Int32 = 0
    property y : Int32 = 0
    property width : UInt32 = 0 # Meaningless
    property height : UInt32 = 0  # Meaningless
    property opacity : Float32 = 1.0
    property visible : Bool = true
    property tintcolor : String = ""
    property offsetx : Int32 = 0
    property offsety : Int32 = 0
    property parallaxx : Float32 = 1.0
    property parallaxy : Float32 = 1.0
    property draworder : String = "topdown"

    property properties : Properties? = nil
    
    property array_object : Array(TiledObject) = [] of TiledObject
  end
end
