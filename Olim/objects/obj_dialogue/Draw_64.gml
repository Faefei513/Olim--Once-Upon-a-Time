var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _bar_h = 140;
var _bar_y = _gui_h - _bar_h;

draw_set_alpha(alpha * 0.7);
draw_set_colour(c_black);
draw_rectangle(0, _bar_y, _gui_w, _gui_h, false);

draw_set_alpha(alpha);
draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1);
draw_text(_gui_w / 2, _bar_y + _bar_h / 2, prompt);

var _opt_w = 520;
var _opt_h = 60;
var _opt_x = _gui_w - _opt_w - 50;
var _opt_gap = 8;
var _num = array_length(options);

for (var _i = 0; _i < _num; _i++) {
    if (option_alpha[_i] <= 0) continue;
    var _oy = _bar_y - ((_num - _i) * (_opt_h + _opt_gap));
    var _oa = alpha * option_alpha[_i];

    draw_set_alpha(_oa * 0.7);
    draw_set_colour((_i == selected) ? make_colour_rgb(80, 60, 130) : c_black);
    draw_rectangle(_opt_x, _oy, _opt_x + _opt_w, _oy + _opt_h, false);

    if (_i == selected) {
        draw_set_alpha(_oa);
        draw_set_colour(c_white);
        draw_rectangle(_opt_x, _oy, _opt_x + _opt_w, _oy + _opt_h, true);
    }

    draw_set_alpha(_oa);
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_ext(_opt_x + _opt_w / 2, _oy + _opt_h / 2, options[_i], -1, _opt_w - 20);
}

draw_set_alpha(alpha * 0.6);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_text(20, _gui_h - 10, "W and S to change option, SPACE to choose");

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
