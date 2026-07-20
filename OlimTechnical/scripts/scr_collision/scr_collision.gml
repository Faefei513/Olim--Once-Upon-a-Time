function player_move_and_collide() {
    y_speed = clamp(y_speed, -20, 20);
    x_speed = clamp(x_speed, -20, 20);

    var _was_on_ground = on_ground;

    x += x_speed;
    var _hw = sprite_get_xoffset(sprite_index) * abs(image_xscale);
    if (_hw <= 0) _hw = 225 * abs(image_xscale);
    if (x < _hw) { x = _hw; x_speed = 0; }
    if (x > room_width - _hw) { x = room_width - _hw; x_speed = 0; }

    y += y_speed;

    on_ground = false;
    var _floor_y = -1;
    var _over_gap = false;

    if (room == rm_isles || room == rm_isles2) {
        var _segs = (room == rm_isles) ? global.isles_segments : global.isles2_segments;
        for (var _g = 0; _g < array_length(_segs); _g++) {
            var _seg = _segs[_g];
            if (x >= _seg[0] && x <= _seg[1]) {
                _floor_y = _seg[2];
                break;
            }
        }
        _over_gap = (_floor_y == -1);

        var _manta = instance_find(obj_manta, 0);
        if (_manta != noone && _manta.gondola_active) {
            if (x >= _manta.gondola_room_left && x <= _manta.gondola_room_right) {
                if (_manta.gondola_room_floor < _floor_y || _floor_y == -1) {
                    _floor_y = _manta.gondola_room_floor;
                    _over_gap = false;
                }
            }
        }
    } else {
        var _tile_spr = (room == rm_forest) ? global.forest_floor : global.floor_tile;
        var _tile_h = (_tile_spr != -1) ? sprite_get_height(_tile_spr) * global.floor_scale : (TILE_SIZE * 2);
        _floor_y = room_height - _tile_h + 140;
        if (room == rm_forest) _floor_y += 20;

        if (room == rm_forest) {
            for (var _g = 0; _g < array_length(global.forest_gaps); _g++) {
                if (x > global.forest_gaps[_g][0] && x < global.forest_gaps[_g][1]) {
                    _over_gap = true;
                    break;
                }
            }
        }
    }

    var _land_margin = ((room == rm_isles || room == rm_isles2) && !_was_on_ground) ? 25 : 9999;

    if (!_over_gap && _floor_y != -1 && y >= _floor_y && y <= _floor_y + _land_margin) {
        y = _floor_y;
        y_speed = 0;
        on_ground = true;
    }

    if (!on_ground && !_over_gap && _floor_y != -1 && y_speed >= 0 && y >= _floor_y - 2 && y <= _floor_y + _land_margin) {
        on_ground = true;
    }

    if (on_ground) {
        last_ground_x = x;
        last_ground_y = _floor_y;
    }

    var _fell_off = (_over_gap && y > room_height + 50);
    if ((room == rm_isles || room == rm_isles2) && !on_ground && y > room_height + 50) _fell_off = true;

    if (_fell_off) {
        var _trans = instance_find(obj_transition, 0);
        if (_trans != noone && _trans.trans_state == E_TRANSITION.NONE) {
            _trans.transition_start(room, last_ground_x, last_ground_y, -1);
            visible = false;
        }
    }

    if (room != rm_isles && room != rm_isles2) {
        var _sprite_h = sprite_get_height(sprite_index) * abs(image_yscale);
        if (y - _sprite_h < 0) {
            y = _sprite_h;
            y_speed = 0;
        }
    }
}
