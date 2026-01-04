module Tiled
  struct Properties
    struct Property
      property name : String
      property type : String = "string"
      property propertytype : String = ""
      property value : String = ""

      property properties : Properties? = nil

      def initialize(@name)
      end

      def self.parse_from_node(node : XML::Node)
        return Tiled::Macros.parse_node_of_class(node, Tiled::Properties::Property)
      end
    end

    property array_property : Array(Property) = [] of Properties::Property

    def self.parse_from_node(node : XML::Node)
      return Tiled::Macros.parse_node_of_class(node, Tiled::Properties)
    end
  end
end
