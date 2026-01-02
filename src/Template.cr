module Tiled
  struct Template
    property tileset : Tileset? = nil
    property object : ObjectGroup::Object

    def initialize(@object)
    end
  end
end
