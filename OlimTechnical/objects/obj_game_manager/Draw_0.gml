var _bg = -1;
if (room == rm_hub) _bg = global.hub_bg;
else if (room == rm_alpha) _bg = global.sky_bg;
else if (room == rm_forest) _bg = global.forest_bg;
else if (room == rm_isles) _bg = global.isles_bg;
else if (room == rm_isles2) _bg = global.isles_bg2;

if (_bg != -1) {
    var _sky_mul = 1.15;
    if (room == rm_hub) _sky_mul = 1.35;
    else if (room == rm_forest || room == rm_isles || room == rm_isles2) _sky_mul = 1.20;
    var _sky_scale = _sky_mul * room_height / sprite_get_height(_bg);
    var _sky_y;
    if (room == rm_hub) _sky_y = -180;
    else if (room == rm_forest || room == rm_isles || room == rm_isles2) _sky_y = -180;
    else _sky_y = -200;
    draw_sprite_ext(_bg, 0, 0, _sky_y, _sky_scale, _sky_scale, 0, c_white, 1);
}
