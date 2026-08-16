function goldfish_path_pos(_progress) {
    var _path = global.goldfish_path;
    var _n = array_length(_path);
    var _t = _progress * (_n - 1);
    var _seg = clamp(floor(_t), 0, _n - 2);
    var _frac = _t - _seg;
    return [
        lerp(_path[_seg][0], _path[_seg + 1][0], _frac),
        lerp(_path[_seg][1], _path[_seg + 1][1], _frac)
    ];
}

function goldfish_spawn(_progress) {
    var _type = irandom(4);
    var _start_frame = (_type == 1) ? 1 : 0;
    var _fish = {
        type_idx: _type,
        progress: _progress,
        speed: 0.00015 + random(0.0001),
        offset_x: random_range(-1000, 1000),
        offset_y: random_range(-700, 700),
        frame: _start_frame,
        anim_dir: 1,
        anim_timer: irandom_range(15, 45)
    };
    array_push(global.goldfish, _fish);
}

function goldfish_draw_layer(_front) {
    for (var _i = 0; _i < array_length(global.goldfish); _i++) {
        var _f = global.goldfish[_i];
        if (global.goldfish_is_front[_f.type_idx] != _front) continue;
        var _pos = goldfish_path_pos(_f.progress);
        var _s = global.goldfish_scale[_f.type_idx];
        draw_sprite_ext(global.goldfish_spr[_f.type_idx], _f.frame,
            _pos[0] + _f.offset_x, _pos[1] + _f.offset_y,
            _s, _s, 0, c_white, 1);
    }
}

function approach(_current, _target, _amount) {
    if (_current < _target) return min(_current + _amount, _target);
    else return max(_current - _amount, _target);
}

function draw_game_menu() {
    if (!global.menu_open) return;

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    draw_set_font(-1);
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
    if (global.menu_teleport_expanded) _block_h += 2 * _btn_h + _btn_gap + 12;
    var _start_y = (_gui_h / 2) - (_block_h / 2);
    var _btn_x = (_gui_w / 2) - (_btn_w / 2);

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

    if (global.menu_teleport_expanded) {
        var _tp_labels = ["Hub", "Alpha", "Forest", "Isles", "Ocean"];
        var _sub_gap = 12;
        var _cols = 3;
        var _sub_w = (_btn_w - (_cols - 1) * _sub_gap) / _cols;
        var _tp_count = array_length(_tp_labels);
        for (var _s = 0; _s < _tp_count; _s++) {
            var _row = _s div _cols;
            var _col = _s mod _cols;
            var _sub_y = _start_y + _count * (_btn_h + _btn_gap) + _row * (_btn_h + _sub_gap);
            var _sx = _btn_x + _col * (_sub_w + _sub_gap);
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

    draw_set_alpha(1);
    draw_set_colour(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
