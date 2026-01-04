module Tiled
  struct Template
    property tileset : Tileset? = nil
    property object : ObjectGroup::Object

    def initialize(@object)
    end

    def self.parse_from_node(node : XML::Node)
      return Tiled::Macros.parse_node_of_class(node, Tiled::Template)
    end
  end
end
