if (room != rm_forest && room != rm_isles && room != rm_isles2 && room != rm_ocean && global.floor_tile != -1) {
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

if (room == rm_ocean) {
    goldfish_draw_layer(true);
}

if (room == rm_ocean && global.ocean_mg != -1) {
    var _mg_scale = room_height / sprite_get_height(global.ocean_mg);
    draw_sprite_ext(global.ocean_mg, 0, 0, 0, _mg_scale, _mg_scale, 0, c_white, 1);
}

if (room == rm_ocean && global.ocean_fg != -1) {
    var _fg_scale = room_height / sprite_get_height(global.ocean_fg);
    if (global.ocean_fg_fade > 0.01) {
        var _cam = view_camera[0];
        var _cx = camera_get_view_x(_cam);
        var _cy = camera_get_view_y(_cam);
        var _cw = camera_get_view_width(_cam);
        var _ch = camera_get_view_height(_cam);
        var _surf = surface_create(_cw, _ch);
        if (surface_exists(_surf)) {
            surface_set_target(_surf);
            draw_clear_alpha(c_black, 0);
            draw_sprite_ext(global.ocean_fg, 0, -_cx, -_cy, _fg_scale, _fg_scale, 0, c_white, 1);
            var _player = instance_find(obj_player, 0);
            if (_player != noone) {
                var _px = _player.x - _cx;
                var _py = _player.y - _cy;
                var _outer_r = 1200;
                var _fa = min(global.ocean_fg_fade * 3, 1);
                var _segs = 32;
                gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
                draw_primitive_begin(pr_trianglefan);
                draw_vertex_colour(_px, _py, c_white, _fa);
                for (var _s = 0; _s <= _segs; _s++) {
                    var _ang = _s * 360 / _segs;
                    draw_vertex_colour(
                        _px + lengthdir_x(_outer_r, _ang),
                        _py + lengthdir_y(_outer_r, _ang),
                        c_white, 0
                    );
                }
                draw_primitive_end();
                gpu_set_blendmode(bm_normal);
                draw_set_alpha(1);
            }
            surface_reset_target();
            draw_surface(_surf, _cx, _cy);
            surface_free(_surf);
        } else {
            draw_sprite_ext(global.ocean_fg, 0, 0, 0, _fg_scale, _fg_scale, 0, c_white, 1);
        }
    } else {
        draw_sprite_ext(global.ocean_fg, 0, 0, 0, _fg_scale, _fg_scale, 0, c_white, 1);
    }
}
