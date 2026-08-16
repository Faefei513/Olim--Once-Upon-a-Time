var _bg = -1;
if (room == rm_hub) _bg = global.hub_bg;
else if (room == rm_alpha) _bg = global.sky_bg;
else if (room == rm_forest) _bg = global.forest_bg;
else if (room == rm_isles) _bg = global.isles_bg;
else if (room == rm_isles2) _bg = global.isles_bg2;
else if (room == rm_ocean) _bg = global.ocean_bg;

if (_bg != -1) {
    if (room == rm_ocean) {
        var _ocean_scale = room_height / sprite_get_height(_bg);
        draw_sprite_ext(_bg, 0, 0, 0, _ocean_scale, _ocean_scale, 0, c_white, 1);
        if (global.leviathan_state > 0 && global.leviathan_state < 4 && global.leviathan_active_spr != -1) {
            var _cam = view_camera[0];
            var _cx = camera_get_view_x(_cam);
            var _cy = camera_get_view_y(_cam);
            var _cw = camera_get_view_width(_cam);
            var _ch = camera_get_view_height(_cam);
            var _lsx = _cw / sprite_get_width(global.leviathan_active_spr);
            var _lsy = _ch / sprite_get_height(global.leviathan_active_spr);
            draw_sprite_ext(global.leviathan_active_spr, global.leviathan_frame, _cx, _cy, _lsx, _lsy, 0, c_white, global.leviathan_alpha);
        }
        goldfish_draw_layer(false);
    } else {
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
}
