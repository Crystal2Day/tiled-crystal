module Tiled
  class Properties
    class Property
      property name : String
      property type : String = "string"
      property propertytype : String = ""
      property value : String = ""

      property properties : Properties? = nil
    end

    property array_property : Array(Property) = [] of Property
  end
end
