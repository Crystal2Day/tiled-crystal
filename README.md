# tiled-crystal

This Crystal shard allows parsing map files from Tiled (https://www.mapeditor.org/) into Crystal structures.

To run it, just include it into your project (it has no dependencies beyond the Crystal standard library)
and call the following functions (with the paths to the respective files):

```crystal
tileset = Tiled.parse_tileset_from_file("ExampleTileset.tsx")

map = Tiled.parse_map_from_file("ExampleMap.tmx")
```
