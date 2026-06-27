// Draw the correct sky background for the current room
var _bg = (room == rm_hub) ? global.hub_bg : global.sky_bg;
if (_bg != -1) {
    var _sky_mul = (room == rm_hub) ? 1.35 : 1.15;
    var _sky_scale = _sky_mul * room_height / sprite_get_height(_bg);
    var _sky_y = (room == rm_hub) ? -180 : -200;
    draw_sprite_ext(_bg, 0, 0, _sky_y, _sky_scale, _sky_scale, 0, c_white, 1);
}
