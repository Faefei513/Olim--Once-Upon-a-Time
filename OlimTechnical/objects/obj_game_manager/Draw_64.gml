var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_white);

// ESC hint (all game rooms)
if (room == rm_hub && global.esc_hint_timer > 0) {
    var _a = min(global.esc_hint_timer / 30, 1);
    draw_set_alpha(_a);
    draw_text(_gui_w / 2, _gui_h * 0.15, "ESC brings up Game Menu, enter/exit full screen from there");
    draw_text(_gui_w / 2, _gui_h * 0.22, "(recommend to play in full screen)");
}

if (room == rm_hub) {
    if (global.move_hint_timer > 0) {
        var _a = min(global.move_hint_timer / 30, 1);
        draw_set_alpha(_a);
        draw_text(_gui_w / 2, _gui_h * 0.30, "A + D to move, SPACE to jump");
    }

    if (global.interact_hint_timer > 0) {
        var _rune = instance_find(obj_hub_rune, 0);
        if (_rune != noone) {
            var _cam_x = camera_get_view_x(view_camera[0]);
            var _cam_y = camera_get_view_y(view_camera[0]);
            var _cam_w = camera_get_view_width(view_camera[0]);
            var _cam_h = camera_get_view_height(view_camera[0]);
            var _rx = (_rune.x - _cam_x) / _cam_w * _gui_w;
            var _ry = (_rune.y - _cam_y) / _cam_h * _gui_h;
            var _a = min(global.interact_hint_timer / 30, 1);
            draw_set_alpha(_a);
            draw_text(_rx, _ry - 80, "C to interact");
        }
    }
}

if (room == rm_forest) {
    if (global.interact_hint_timer > 0) {
        var _rune = instance_find(obj_forest_rune, 0);
        if (_rune != noone) {
            var _cam_x = camera_get_view_x(view_camera[0]);
            var _cam_y = camera_get_view_y(view_camera[0]);
            var _cam_w = camera_get_view_width(view_camera[0]);
            var _cam_h = camera_get_view_height(view_camera[0]);
            var _rx = (_rune.x - _cam_x) / _cam_w * _gui_w;
            var _ry = (_rune.y - _cam_y) / _cam_h * _gui_h;
            var _a = min(global.interact_hint_timer / 30, 1);
            draw_set_alpha(_a);
            draw_text(_rx, _ry - 80, "C to interact");
        }
    }
}

if (room == rm_isles) {
    if (global.interact_hint_timer > 0) {
        var _knife = instance_find(obj_isles_knife, 0);
        if (_knife != noone) {
            var _cam_x = camera_get_view_x(view_camera[0]);
            var _cam_y = camera_get_view_y(view_camera[0]);
            var _cam_w = camera_get_view_width(view_camera[0]);
            var _cam_h = camera_get_view_height(view_camera[0]);
            var _rx = (_knife.x - _cam_x) / _cam_w * _gui_w;
            var _ry = (_knife.y - _cam_y) / _cam_h * _gui_h;
            var _a = min(global.interact_hint_timer / 30, 1);
            draw_set_alpha(_a);
            draw_text(_rx, _ry - 150, "C to interact");
        }
    }
}

if (room == rm_ocean) {
    if (global.interact_hint_timer > 0) {
        var _cam_x = camera_get_view_x(view_camera[0]);
        var _cam_y = camera_get_view_y(view_camera[0]);
        var _cam_w = camera_get_view_width(view_camera[0]);
        var _cam_h = camera_get_view_height(view_camera[0]);
        var _player = instance_find(obj_player, 0);
        var _target = noone;
        var _ruins = instance_find(obj_ocean_ruins, 0);
        var _mural = instance_find(obj_ocean_mural, 0);
        if (_player != noone && _ruins != noone && point_distance(_ruins.x, _ruins.y, _player.x, _player.y) < 500) _target = _ruins;
        if (_player != noone && _mural != noone && point_distance(_mural.x, _mural.y, _player.x, _player.y) < 500) _target = _mural;
        if (_target != noone) {
            var _rx = (_target.x - _cam_x) / _cam_w * _gui_w;
            var _ry = (_target.y - _cam_y) / _cam_h * _gui_h;
            var _a = min(global.interact_hint_timer / 30, 1);
            draw_set_alpha(_a);
            draw_text(_rx, _ry - 80, "C to interact");
        }
    }
}

if (room == rm_alpha) {
    if (global.flight_hint_timer > 0) {
        var _a = min(global.flight_hint_timer / 30, 1);
        draw_set_alpha(_a);
        draw_text(_gui_w / 2, _gui_h * 0.30, "F to flap, hold SPACE to glide");
    }
}

if (!instance_exists(obj_dialogue)) draw_game_menu();

// Ending overlay
if (global.ending_state > 0) {
    draw_set_alpha(global.ending_alpha);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
}

// Cutscene overlay
if (global.cutscene_state > 0) {
    draw_set_alpha(global.cutscene_alpha);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    if (global.cutscene_state == 2 && global.cutscene_frame < 22) {
        var _spr, _sub;
        if (global.cutscene_frame < 8) {
            _spr = global.isles_cutscene_spr[0];
            _sub = global.cutscene_frame;
        } else if (global.cutscene_frame < 16) {
            _spr = global.isles_cutscene_spr[1];
            _sub = global.cutscene_frame - 8;
        } else {
            _spr = global.isles_cutscene_spr[2];
            _sub = global.cutscene_frame - 16;
        }
        draw_set_alpha(1);
        draw_sprite_ext(_spr, _sub, _gui_w / 2, _gui_h / 2, 1, 1, 0, c_white, 1);
    }
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
