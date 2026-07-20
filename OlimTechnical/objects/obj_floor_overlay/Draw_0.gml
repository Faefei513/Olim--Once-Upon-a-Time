if (room != rm_forest && room != rm_isles && room != rm_isles2 && global.floor_tile != -1) {
    var _s = global.floor_scale;
    var _tile_h = sprite_get_height(global.floor_tile) * _s;
    var _tile_w = sprite_get_width(global.floor_tile) * _s;
    var _floor_y = room_height - _tile_h;
    for (var _x = 0; _x < room_width; _x += _tile_w) {
        draw_sprite_ext(global.floor_tile, 0, _x, _floor_y, _s, _s, 0, c_white, 1);
    }
}

if (room == rm_forest && global.forest_fg != -1) {
    var _fg_scale = 1.20 * room_height / sprite_get_height(global.forest_fg);
    draw_sprite_ext(global.forest_fg, 0, 0, -180, _fg_scale, _fg_scale, 0, c_white, 1);
}

if (room == rm_isles || room == rm_isles2) {
    var _manta = instance_find(obj_manta, 0);
    if (_manta != noone) {
        var _gd = _manta.cur_gondola;
        var _s = _manta.manta_scale;
        draw_sprite_ext(_manta.cur_spr_f, 0, _manta.x - _gd[0] * _s, _manta.y - _gd[1] * _s, _s, _s, 0, c_white, 1);
    }
}

if (room == rm_isles && global.isles_fg != -1) {
    var _fg_scale = 1.20 * room_height / sprite_get_height(global.isles_fg);
    draw_sprite_ext(global.isles_fg, 0, 0, -180, _fg_scale, _fg_scale, 0, c_white, 1);
}

if (room == rm_isles2 && global.isles_fg2 != -1) {
    var _fg_scale = 1.20 * room_height / sprite_get_height(global.isles_fg2);
    draw_sprite_ext(global.isles_fg2, 0, 0, -180, _fg_scale, _fg_scale, 0, c_white, 1);
}
