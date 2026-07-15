var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Draw poster background scaled to fit height, extend edges
if (global.title_bg != -1) {
    var _sw = sprite_get_width(global.title_bg);
    var _sh = sprite_get_height(global.title_bg);
    var _scale = _gui_h / _sh;
    var _drawn_w = _sw * _scale;
    var _dx = _gui_w - _drawn_w;
    var _strip = 20;

    // Extend left edge
    if (_dx > 0) {
        draw_sprite_part_ext(global.title_bg, 0, 0, 0, _strip, _sh, 0, 0, _dx / _strip, _scale, c_white, 1);
    }
    // Extend right edge
    var _right_gap = _gui_w - _dx - _drawn_w;
    if (_right_gap > 0) {
        draw_sprite_part_ext(global.title_bg, 0, _sw - _strip, 0, _strip, _sh, _dx + _drawn_w, 0, _right_gap / _strip, _scale, c_white, 1);
    }
    // Draw poster centered
    draw_sprite_ext(global.title_bg, 0, _dx, 0, _scale, _scale, 0, c_white, 1);

    // Cover original logo on the poster with gradient strip taken from just past the logo
    var _cover_src_x = 1290;
    var _cover_w = 1350 * _scale;
    draw_sprite_part_ext(global.title_bg, 0, _cover_src_x, 0, _strip, _sh * 0.35, _dx, 0, _cover_w / _strip, _scale, c_white, 1);

    // Draw logo pinned to top-left
    var _logo_x = 0;
    var _logo_y = 60;
    var _logo_w = 1300;
    var _logo_h = 1340;
    var _logo_scale = _gui_h * 0.35 / _logo_h;
    draw_sprite_part_ext(global.title_bg, 0, _logo_x, _logo_y, _logo_w, _logo_h, 30, 20, _logo_scale, _logo_scale, c_white, 1);
}

// Darken overlay so buttons are readable
draw_set_alpha(0.3);
draw_set_colour(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// Draw buttons
var _rows = 5;
if (test_expanded) _rows += 1;
var _block_h = _rows * btn_h + (_rows - 1) * btn_gap;
var _start_y = (_gui_h / 2) - (_block_h / 2) + 55;
var _btn_x = (_gui_w / 4.5) - (btn_w / 2);

draw_set_font(-1);

// First 4 buttons: 3 save slots + Test Run
for (var _i = 0; _i < 4; _i++) {
    var _by = _start_y + _i * (btn_h + btn_gap);
    var _is_hovered = (hovered == _i) || (_i == 3 && test_expanded);

    draw_set_alpha(_is_hovered ? 0.6 : 0.3);
    draw_set_colour(c_black);
    draw_rectangle(_btn_x, _by, _btn_x + btn_w, _by + btn_h, false);

    if (_is_hovered) {
        draw_set_alpha(1);
        draw_set_colour(c_white);
        draw_rectangle(_btn_x, _by, _btn_x + btn_w, _by + btn_h, true);
    }

    var _label = "";
    if (_i < 3) {
        var _slot_num = _i + 1;
        if (slot_info[_i] != undefined) {
            _label = "Save Slot " + string(_slot_num) + " - Continue (" + slot_info[_i].room_display + ")";
        } else {
            _label = "Save Slot " + string(_slot_num) + " - New Game";
        }
    } else {
        _label = "Test Run - Does not save!";
    }

    draw_set_alpha(_is_hovered ? 1 : 0.5);
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_btn_x + btn_w / 2, _by + btn_h / 2, _label);

    if (_is_hovered) {
        var _tw = string_width(_label);
        var _tx = (_btn_x + btn_w / 2) - _tw / 2;
        var _uy = _by + btn_h / 2 + string_height(_label) / 2 + 2;
        draw_set_alpha(1);
        draw_line(_tx, _uy, _tx + _tw, _uy);
    }
}

// Test Run sub-buttons (side by side)
var _next_row = 4;
if (test_expanded) {
    var _sub_labels = ["Player Vers.", "Creator Vers."];
    var _sub_y = _start_y + 4 * (btn_h + btn_gap);
    var _sub_gap = 12;
    var _sub_w = (btn_w - _sub_gap) / 2;
    for (var _s = 0; _s < 2; _s++) {
        var _sx = _btn_x + _s * (_sub_w + _sub_gap);
        var _is_sub_hovered = (hovered == 4 + _s);

        draw_set_alpha(_is_sub_hovered ? 0.6 : 0.3);
        draw_set_colour(c_black);
        draw_rectangle(_sx, _sub_y, _sx + _sub_w, _sub_y + btn_h, false);

        if (_is_sub_hovered) {
            draw_set_alpha(1);
            draw_set_colour(c_white);
            draw_rectangle(_sx, _sub_y, _sx + _sub_w, _sub_y + btn_h, true);
        }

        draw_set_alpha(_is_sub_hovered ? 1 : 0.5);
        draw_set_colour(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_sx + _sub_w / 2, _sub_y + btn_h / 2, _sub_labels[_s]);

        if (_is_sub_hovered) {
            var _tw = string_width(_sub_labels[_s]);
            var _tx = (_sx + _sub_w / 2) - _tw / 2;
            var _uy = _sub_y + btn_h / 2 + string_height(_sub_labels[_s]) / 2 + 2;
            draw_set_alpha(1);
            draw_line(_tx, _uy, _tx + _tw, _uy);
        }
    }
    _next_row = 5;
}

// Quit button (always last)
var _quit_y = _start_y + _next_row * (btn_h + btn_gap);
var _quit_hovered = (hovered == 10);

draw_set_alpha(_quit_hovered ? 0.6 : 0.3);
draw_set_colour(c_black);
draw_rectangle(_btn_x, _quit_y, _btn_x + btn_w, _quit_y + btn_h, false);

if (_quit_hovered) {
    draw_set_alpha(1);
    draw_set_colour(c_white);
    draw_rectangle(_btn_x, _quit_y, _btn_x + btn_w, _quit_y + btn_h, true);
}

draw_set_alpha(_quit_hovered ? 1 : 0.5);
draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_btn_x + btn_w / 2, _quit_y + btn_h / 2, "Quit");

if (_quit_hovered) {
    var _tw = string_width("Quit");
    var _tx = (_btn_x + btn_w / 2) - _tw / 2;
    var _uy = _quit_y + btn_h / 2 + string_height("Quit") / 2 + 2;
    draw_set_alpha(1);
    draw_line(_tx, _uy, _tx + _tw, _uy);
}

// Fade overlay
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
