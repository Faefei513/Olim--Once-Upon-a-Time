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

if (room == rm_sky_hub) {
    if (global.flight_hint_timer > 0) {
        var _a = min(global.flight_hint_timer / 30, 1);
        draw_set_alpha(_a);
        draw_text(_gui_w / 2, _gui_h * 0.30, "X to flap, hold SPACE to glide");
    }
}

// Game Menu
if (global.menu_open) {
    draw_set_alpha(0.6);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    var _btn_w = 520;
    var _btn_h = 60;
    var _btn_gap = 16;
    var _labels = ["Resume", "Return to Title Screen", "Enter/Exit Full Screen", "Quit"];
    if (global.creator_mode) array_push(_labels, "Teleport");
    var _count = array_length(_labels);

    var _block_h = _count * _btn_h + (_count - 1) * _btn_gap;
    if (global.menu_teleport_expanded) _block_h += _btn_h + _btn_gap;
    var _start_y = (_gui_h / 2) - (_block_h / 2);
    var _btn_x = (_gui_w / 2) - (_btn_w / 2);

    draw_set_font(-1);

    for (var _i = 0; _i < _count; _i++) {
        var _by = _start_y + _i * (_btn_h + _btn_gap);
        var _is_hovered = (global.menu_hovered == _i) || (_i == 4 && global.menu_teleport_expanded);

        draw_set_alpha(_is_hovered ? 0.6 : 0.3);
        draw_set_colour(c_black);
        draw_rectangle(_btn_x, _by, _btn_x + _btn_w, _by + _btn_h, false);

        if (_is_hovered) {
            draw_set_alpha(1);
            draw_set_colour(c_white);
            draw_rectangle(_btn_x, _by, _btn_x + _btn_w, _by + _btn_h, true);
        }

        draw_set_alpha(_is_hovered ? 1 : 0.5);
        draw_set_colour(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_btn_x + _btn_w / 2, _by + _btn_h / 2, _labels[_i]);

        if (_is_hovered) {
            var _tw = string_width(_labels[_i]);
            var _tx = (_btn_x + _btn_w / 2) - _tw / 2;
            var _uy = _by + _btn_h / 2 + string_height(_labels[_i]) / 2 + 2;
            draw_set_alpha(1);
            draw_line(_tx, _uy, _tx + _tw, _uy);
        }
    }

    // Teleport sub-buttons (side by side, 3 across)
    if (global.menu_teleport_expanded) {
        var _tp_labels = ["Hub", "Alpha", "Forest"];
        var _sub_y = _start_y + _count * (_btn_h + _btn_gap);
        var _sub_gap = 12;
        var _sub_w = (_btn_w - 2 * _sub_gap) / 3;
        for (var _s = 0; _s < 3; _s++) {
            var _sx = _btn_x + _s * (_sub_w + _sub_gap);
            var _is_sub_hovered = (global.menu_hovered == _count + _s);

            draw_set_alpha(_is_sub_hovered ? 0.6 : 0.3);
            draw_set_colour(c_black);
            draw_rectangle(_sx, _sub_y, _sx + _sub_w, _sub_y + _btn_h, false);

            if (_is_sub_hovered) {
                draw_set_alpha(1);
                draw_set_colour(c_white);
                draw_rectangle(_sx, _sub_y, _sx + _sub_w, _sub_y + _btn_h, true);
            }

            draw_set_alpha(_is_sub_hovered ? 1 : 0.5);
            draw_set_colour(c_white);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(_sx + _sub_w / 2, _sub_y + _btn_h / 2, _tp_labels[_s]);

            if (_is_sub_hovered) {
                var _tw = string_width(_tp_labels[_s]);
                var _tx = (_sx + _sub_w / 2) - _tw / 2;
                var _uy = _sub_y + _btn_h / 2 + string_height(_tp_labels[_s]) / 2 + 2;
                draw_set_alpha(1);
                draw_line(_tx, _uy, _tx + _tw, _uy);
            }
        }
    }
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
