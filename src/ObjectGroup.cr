module Tiled
  struct ObjectGroup
    struct Object
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

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::ObjectGroup::Object)
      end
    end

    struct Ellipse
      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::ObjectGroup::Ellipse)
      end
    end

    struct Point
      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::ObjectGroup::Point)
      end
    end

    struct Polygon
      property points : String

      def initialize(@points)
      end

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::ObjectGroup::Polygon)
      end
    end

    struct Polyline
      property points : String

      def initialize(@points)
      end

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::ObjectGroup::Polyline)
      end
    end

    struct Text
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

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::ObjectGroup::Text)
      end
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
    
    property array_object : Array(Object) = [] of Object

    def self.parse_from_node(node : XML::Node)
      return Tiled::Macros.parse_node_of_class(node, Tiled::ObjectGroup)
    end
  end
end
