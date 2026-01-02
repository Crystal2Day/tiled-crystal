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
    end

    property array_property : Array(Property) = [] of Properties::Property
  end
end
