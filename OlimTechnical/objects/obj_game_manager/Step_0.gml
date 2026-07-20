var _w = window_get_width();
var _h = window_get_height();
if (_w > 0 && _h > 0 && (surface_get_width(application_surface) != _w || surface_get_height(application_surface) != _h)) {
    surface_resize(application_surface, _w, _h);
    display_set_gui_size(900 * (_w / _h), 900);
}

// Ending state machine (Isles update thank-you screen)
if (global.ending_state > 0) {
    if (global.ending_state == 1) {
        global.ending_alpha = min(global.ending_alpha + 0.02, 1);
        if (global.ending_alpha >= 1) global.ending_state = 2;
    } else if (global.ending_state == 2) {
        if (input_check_pressed("jump") || input_check_pressed("interact")) {
            global.ending_state = 3;
        }
    } else if (global.ending_state == 3) {
        global.ending_alpha = max(global.ending_alpha - 0.02, 0);
        if (global.ending_alpha <= 0) {
            global.ending_state = 0;
            room_goto(rm_title);
        }
    }
    return;
}

// Cutscene state machine
if (global.cutscene_state > 0) {
    if (global.cutscene_state == 1) {
        global.cutscene_alpha = min(global.cutscene_alpha + 0.02, 1);
        if (global.cutscene_alpha >= 1) {
            global.cutscene_state = 2;
            global.cutscene_frame = 0;
            global.cutscene_timer = 0;
        }
    } else if (global.cutscene_state == 2) {
        global.cutscene_timer++;
        if (global.cutscene_timer >= 30) {
            global.cutscene_timer = 0;
            global.cutscene_frame++;
            if (global.cutscene_frame >= 22) {
                global.cutscene_state = 3;
            }
        }
    } else if (global.cutscene_state == 3) {
        global.cutscene_alpha = max(global.cutscene_alpha - 0.02, 0);
        if (global.cutscene_alpha <= 0) {
            global.cutscene_state = 0;
            global.isles_cutscene_seen = true;
            save_game();
            with (obj_player) state = player_state_idle;
        }
    }
    return;
}

// ESC toggles menu (only in game rooms)
if (keyboard_check_pressed(vk_escape) && room != rm_title && room != rm_boot) {
    global.menu_open = !global.menu_open;
    global.menu_hovered = -1;
    global.menu_teleport_expanded = false;
}

// Menu input handling
if (global.menu_open) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _btn_w = 520;
    var _btn_h = 60;
    var _btn_gap = 16;

    var _count = global.creator_mode ? 5 : 4;
    var _block_h = _count * _btn_h + (_count - 1) * _btn_gap;
    if (global.menu_teleport_expanded) _block_h += _btn_h + _btn_gap;
    var _start_y = (_gui_h / 2) - (_block_h / 2);
    var _btn_x = (_gui_w / 2) - (_btn_w / 2);

    global.menu_hovered = -1;
    for (var _i = 0; _i < _count; _i++) {
        var _by = _start_y + _i * (_btn_h + _btn_gap);
        if (_mx >= _btn_x && _mx <= _btn_x + _btn_w && _my >= _by && _my <= _by + _btn_h) {
            global.menu_hovered = _i;
            break;
        }
    }

    // Check teleport sub-buttons
    if (global.menu_teleport_expanded && global.menu_hovered == -1) {
        var _sub_y = _start_y + _count * (_btn_h + _btn_gap);
        var _sub_gap = 12;
        var _sub_count = 4;
        var _sub_w = (_btn_w - (_sub_count - 1) * _sub_gap) / _sub_count;
        if (_my >= _sub_y && _my <= _sub_y + _btn_h) {
            for (var _s = 0; _s < _sub_count; _s++) {
                var _sx = _btn_x + _s * (_sub_w + _sub_gap);
                if (_mx >= _sx && _mx <= _sx + _sub_w) {
                    global.menu_hovered = _count + _s;
                    break;
                }
            }
        }
    }

    if (global.menu_hovered >= 0 && mouse_check_button_pressed(mb_left)) {
        if (global.menu_hovered == 0) {
            global.menu_open = false;
            global.menu_teleport_expanded = false;
        } else if (global.menu_hovered == 1) {
            global.menu_open = false;
            global.menu_teleport_expanded = false;
            var _trans = instance_find(obj_transition, 0);
            if (_trans != noone) {
                _trans.transition_start(rm_title, 0, 0, -1);
            }
        } else if (global.menu_hovered == 2) {
            if (window_get_fullscreen()) {
                window_set_fullscreen(false);
                window_set_size(1600, 750);
            } else {
                window_set_fullscreen(true);
            }
        } else if (global.menu_hovered == 3) {
            save_game();
            game_end();
        } else if (global.creator_mode && global.menu_hovered == 4) {
            global.menu_teleport_expanded = !global.menu_teleport_expanded;
        } else if (global.creator_mode && global.menu_hovered >= 5) {
            global.menu_open = false;
            global.menu_teleport_expanded = false;
            var _trans = instance_find(obj_transition, 0);
            if (_trans != noone) {
                var _dest = rm_hub;
                var _sx = 960; var _sy = 750;
                if (global.menu_hovered == 5) { _dest = rm_hub; _sx = 960; _sy = 750; }
                else if (global.menu_hovered == 6) { _dest = rm_alpha; _sx = 960; _sy = 750; }
                else if (global.menu_hovered == 7) { _dest = rm_forest; _sx = 720; _sy = 750; }
                else if (global.menu_hovered == 8) { _dest = rm_isles; _sx = 500; _sy = 750; }
                _trans.transition_start(_dest, _sx, _sy, -1);
            }
        }
    }
    return;
}

if (room == rm_hub && global.move_hint_timer > 0) {
    global.move_hint_timer--;
}

if (room == rm_alpha && global.flight_hint_timer > 0) {
    global.flight_hint_timer--;
}

if (room != rm_title && room != rm_boot && global.esc_hint_timer > 0) {
    global.esc_hint_timer--;
}

// Forest end → Isles transition (behind tree trunk, requires rune solved)
if (room == rm_forest && global.forest_rune_solved) {
    var _player = instance_find(obj_player, 0);
    var _trans = instance_find(obj_transition, 0);
    if (_player != noone && _trans != noone && _trans.trans_state == E_TRANSITION.NONE) {
        if (_player.x > room_width - 500) {
            _trans.transition_start(rm_isles, 500, 750, -1);
        }
    }
}

// Isles cutscene trigger
if (room == rm_isles && !global.isles_cutscene_seen && global.cutscene_state == 0) {
    var _player = instance_find(obj_player, 0);
    if (_player != noone && _player.x >= 10600 && _player.x <= 11000) {
        _player.state = player_state_puzzle;
        global.cutscene_state = 1;
        global.cutscene_alpha = 0;
    }
}

var _near_rune = false;
if (room == rm_hub) {
    var _rune = instance_find(obj_hub_rune, 0);
    var _player = instance_find(obj_player, 0);
    if (_rune != noone && _player != noone && abs(_rune.x - _player.x) < 300) _near_rune = true;
}
if (room == rm_forest) {
    var _rune = instance_find(obj_forest_rune, 0);
    var _player = instance_find(obj_player, 0);
    if (_rune != noone && _player != noone && abs(_rune.x - _player.x) < 300) _near_rune = true;
}
if (room == rm_isles) {
    var _knife = instance_find(obj_isles_knife, 0);
    var _player = instance_find(obj_player, 0);
    if (_knife != noone && _player != noone && abs(_knife.x - _player.x) < 300) _near_rune = true;
}

if (_near_rune) {
    global.interact_hint_age++;
    var _fade_start = 5 * game_get_speed(gamespeed_fps);
    if (global.interact_hint_age < _fade_start) {
        global.interact_hint_timer = min(global.interact_hint_timer + 1, 30);
    } else {
        global.interact_hint_timer = max(global.interact_hint_timer - 1, 0);
    }
} else {
    global.interact_hint_timer = max(global.interact_hint_timer - 1, 0);
    global.interact_hint_age = 0;
}
