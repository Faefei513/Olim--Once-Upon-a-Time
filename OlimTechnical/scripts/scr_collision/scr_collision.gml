function player_move_and_collide() {
    y_speed = clamp(y_speed, -20, 20);
    x_speed = clamp(x_speed, -20, 20);

    var _tile_spr = (room == rm_forest) ? global.forest_floor : global.floor_tile;
    var _tile_h = (_tile_spr != -1) ? sprite_get_height(_tile_spr) * global.floor_scale : (TILE_SIZE * 2);
    var _floor_y = room_height - _tile_h + 140;
    if (room == rm_forest) _floor_y += 20;

    x += x_speed;
    var _hw = sprite_get_xoffset(sprite_index) * abs(image_xscale);
    if (_hw <= 0) _hw = 225 * abs(image_xscale);
    if (x < _hw) { x = _hw; x_speed = 0; }
    if (x > room_width - _hw) { x = room_width - _hw; x_speed = 0; }

    y += y_speed;

    on_ground = false;

    var _over_gap = false;
    if (room == rm_forest) {
        for (var _g = 0; _g < array_length(global.forest_gaps); _g++) {
            if (x > global.forest_gaps[_g][0] && x < global.forest_gaps[_g][1]) {
                _over_gap = true;
                break;
            }
        }
    }

    if (!_over_gap && y >= _floor_y) {
        y = _floor_y;
        y_speed = 0;
        on_ground = true;
    }

    if (!on_ground && !_over_gap && y_speed >= 0 && y >= _floor_y - 2) {
        on_ground = true;
    }

    if (on_ground) last_ground_x = x;

    if (_over_gap && y > room_height + 50) {
        var _trans = instance_find(obj_transition, 0);
        if (_trans != noone && _trans.trans_state == E_TRANSITION.NONE) {
            _trans.transition_start(room, last_ground_x, _floor_y, -1);
            visible = false;
        }
    }

    var _sprite_h = sprite_get_height(sprite_index) * abs(image_yscale);
    if (y - _sprite_h < 0) {
        y = _sprite_h;
        y_speed = 0;
    }
}
