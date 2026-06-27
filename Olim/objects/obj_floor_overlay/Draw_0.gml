if (global.floor_tile != -1) {
    var _s = global.floor_scale;
    var _tile_h = sprite_get_height(global.floor_tile) * _s;
    var _tile_w = sprite_get_width(global.floor_tile) * _s;
    var _floor_y = room_height - _tile_h;
    for (var _x = 0; _x < room_width; _x += _tile_w) {
        draw_sprite_ext(global.floor_tile, 0, _x, _floor_y, _s, _s, 0, c_white, 1);
    }
}
