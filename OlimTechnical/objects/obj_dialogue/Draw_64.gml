var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _bar_h = 140;
var _bar_y = _gui_h - _bar_h;

if (overlay_spr != -1) {
    draw_set_alpha(alpha * 0.65);
    draw_set_colour(make_colour_rgb(30, 30, 30));
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    var _knife_h = sprite_get_height(overlay_spr);
    var _area_h = _gui_h - _bar_h;
    var _target_h = _area_h * 0.75;
    var _kscale = _target_h / _knife_h;
    draw_set_alpha(alpha);
    draw_sprite_ext(overlay_spr, 0, _gui_w / 2, _area_h / 2, _kscale, _kscale, 0, c_white, alpha);
}

draw_set_alpha(alpha * 0.7);
draw_set_colour(c_black);
draw_rectangle(0, _bar_y, _gui_w, _gui_h, false);

draw_set_alpha(alpha);
draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1);
draw_text_ext(_gui_w / 2, _bar_y + _bar_h / 2, prompt, -1, _gui_w - 80);

var _num = array_length(options);

if (_num > 0) {
    var _opt_w = 520;
    var _opt_h = 60;
    var _opt_x = _gui_w - _opt_w - 50;
    var _opt_gap = 8;

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
}

draw_set_alpha(alpha * 0.6);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
if (_num > 0) {
    if (show_latin_hints) {
        draw_text(20, _gui_h - 10, "W + S to change option, SPACE to choose, ENTER to skip + reveal answer");
        draw_text(20, _gui_h - 30, "Hover over Latin words for help like grammar info");
    } else {
        draw_text(20, _gui_h - 10, "W + S to change option, SPACE to choose");
    }
} else {
    draw_text(20, _gui_h - 10, "SPACE to continue");
}

// Word hover tooltip on translation stages
if (_num > 0 && alpha >= 1 && show_latin_hints) {
    draw_set_font(-1);
    var _prompt_w = string_width(prompt);
    var _char_h = string_height("A");
    var _prompt_start_x = (_gui_w / 2) - (_prompt_w / 2);
    var _prompt_cy = _bar_y + _bar_h / 2;

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    if (_my >= _prompt_cy - _char_h / 2 && _my <= _prompt_cy + _char_h / 2) {
        var _words = string_split(prompt, " ");
        var _space_w = string_width(" ");
        var _cx = _prompt_start_x;
        var _hovered = -1;

        for (var _w = 0; _w < array_length(_words); _w++) {
            var _ww = string_width(_words[_w]);
            if (_mx >= _cx && _mx <= _cx + _ww) {
                _hovered = _w;
                break;
            }
            _cx += _ww + _space_w;
        }

        if (_hovered >= 0) {
            var _word = _words[_hovered];
            var _clean = "";
            for (var _c = 1; _c <= string_length(_word); _c++) {
                var _ch = string_char_at(_word, _c);
                if (_ch != "." && _ch != "," && _ch != ";" && _ch != ":" && _ch != "!" && _ch != "?" && _ch != "(" && _ch != ")" && _ch != "\"") {
                    _clean += _ch;
                }
            }

            var _entry = grammar_overrides[$ _clean];
            if (_entry == undefined) _entry = global.grammar[$ _clean];
            if (_entry != undefined) {
                var _display = variable_struct_exists(_entry, "display") ? _entry.display : _clean;
                var _tip_text = _display + "\n" + _entry.info + "\nEnglish: " + _entry.eng;
                var _tip_pad = 12;
                var _tip_max_w = 400;
                var _tip_tw = string_width_ext(_tip_text, -1, _tip_max_w);
                var _tip_w = _tip_tw + _tip_pad * 2;
                var _tip_th = string_height_ext(_tip_text, -1, _tip_max_w);
                var _tip_h = _tip_th + _tip_pad * 2;

                var _tip_x = _mx + 15;
                var _tip_y = _my - _tip_h - 30;
                if (_tip_x + _tip_w > _gui_w) _tip_x = _mx - _tip_w - 15;
                if (_tip_y < 0) _tip_y = _my + 20;

                draw_set_alpha(0.85);
                draw_set_colour(c_black);
                draw_rectangle(_tip_x, _tip_y, _tip_x + _tip_w, _tip_y + _tip_h, false);

                draw_set_alpha(1);
                draw_set_colour(c_white);
                draw_rectangle(_tip_x, _tip_y, _tip_x + _tip_w, _tip_y + _tip_h, true);

                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                draw_text_ext(_tip_x + _tip_pad, _tip_y + _tip_pad, _tip_text, -1, _tip_max_w);

                var _ul_y = _prompt_cy + _char_h / 2 + 2;
                draw_line(_cx, _ul_y, _cx + _ww, _ul_y);
            }
        }
    }
}

draw_game_menu();

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
