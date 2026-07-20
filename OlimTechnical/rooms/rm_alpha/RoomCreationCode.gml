// rm_alpha — Room Creation Code
var _tm = layer_tilemap_get_id("Collision");
var _room_w_tiles = room_width div TILE_SIZE;
var _room_h_tiles = room_height div TILE_SIZE;

show_debug_message("Tilemap ID: " + string(_tm));
show_debug_message("Room tiles: " + string(_room_w_tiles) + " x " + string(_room_h_tiles));

// Fill bottom 2 rows with collision tiles
for (var _tx = 0; _tx < _room_w_tiles; _tx++) {
    tilemap_set(_tm, 1, _tx, _room_h_tiles - 1);
    tilemap_set(_tm, 1, _tx, _room_h_tiles - 2);
}

// Verify a tile was set
var _test = tilemap_get(_tm, 0, _room_h_tiles - 1);
show_debug_message("Tile at (0, bottom): " + string(_test));
var _test2 = tilemap_get_at_pixel(_tm, 0, room_height - 8);
show_debug_message("Tile at pixel (0, " + string(room_height - 8) + "): " + string(_test2));
