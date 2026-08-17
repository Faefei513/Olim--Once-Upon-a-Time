// Handle fade-out
if (pending_action >= 0) {
    fade_alpha += 0.03;
    if (fade_alpha >= 1) {
        fade_alpha = 1;
        var _trans = instance_find(obj_transition, 0);
        if (_trans != noone) {
            _trans.trans_alpha = 1;
            _trans.trans_state = E_TRANSITION.FADE_IN;
        }
        if (pending_action == 0) {
            load_game(pending_slot);
        } else if (pending_action == 1) {
            new_game(pending_slot);
        } else if (pending_action == 2) {
            start_test_run(false);
        } else {
            start_test_run(true);
        }
    }
    return;
}

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _rows = 5;
if (test_expanded) _rows += 1;
var _block_h = _rows * btn_h + (_rows - 1) * btn_gap;
var _start_y = (_gui_h / 2) - (_block_h / 2) + 55;
var _btn_x = (_gui_w / 3.5) - (btn_w / 2);

hovered = -1;

// Check first 4 buttons (slots + test run)
for (var _i = 0; _i < 4; _i++) {
    var _by = _start_y + _i * (btn_h + btn_gap);
    if (_mx >= _btn_x && _mx <= _btn_x + btn_w && _my >= _by && _my <= _by + btn_h) {
        hovered = _i;
        break;
    }
}

// Check sub-buttons when expanded
var _next_row = 4;
if (test_expanded && hovered == -1) {
    var _sub_y = _start_y + 4 * (btn_h + btn_gap);
    var _sub_gap = 12;
    var _sub_w = (btn_w - _sub_gap) / 2;
    if (_my >= _sub_y && _my <= _sub_y + btn_h) {
        if (_mx >= _btn_x && _mx <= _btn_x + _sub_w) {
            hovered = 4;
        } else if (_mx >= _btn_x + _sub_w + _sub_gap && _mx <= _btn_x + btn_w) {
            hovered = 5;
        }
    }
    _next_row = 5;
}

// Check Quit button (always last)
if (hovered == -1) {
    var _quit_y = _start_y + _next_row * (btn_h + btn_gap);
    if (_mx >= _btn_x && _mx <= _btn_x + btn_w && _my >= _quit_y && _my <= _quit_y + btn_h) {
        hovered = 10;
    }
}

if (hovered >= 0 && mouse_check_button_pressed(mb_left)) {
    if (hovered < 3) {
        var _slot = hovered + 1;
        if (slot_info[hovered] != undefined) {
            pending_action = 0;
        } else {
            pending_action = 1;
        }
        pending_slot = _slot;
    } else if (hovered == 3) {
        test_expanded = !test_expanded;
    } else if (hovered == 4) {
        pending_action = 2;
    } else if (hovered == 5) {
        pending_action = 3;
    } else if (hovered == 10) {
        game_end();
    }
}
