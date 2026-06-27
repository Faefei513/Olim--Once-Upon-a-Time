var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_white);

if (room == rm_hub) {
    if (global.move_hint_timer > 0) {
        var _a = min(global.move_hint_timer / 30, 1);
        draw_set_alpha(_a);
        draw_text(_gui_w / 2, _gui_h * 0.15, "A and D to move, SPACE to jump");
        draw_text(_gui_w / 2, _gui_h * 0.22, "ESC to enter and exit fullscreen");
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

if (room == rm_sky_hub) {
    if (global.flight_hint_timer > 0) {
        var _a = min(global.flight_hint_timer / 30, 1);
        draw_set_alpha(_a);
        draw_text(_gui_w / 2, _gui_h * 0.15, "X to flap, hold SPACE to glide");
    }
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
