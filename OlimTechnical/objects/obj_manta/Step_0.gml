if (global.menu_open || global.ending_state > 0) return;

// Update sprite pair and gondola data for current state
switch (state) {
    case E_MANTA.WAITING:
    case E_MANTA.DIALOGUE:
    case E_MANTA.BOARDING:
        cur_spr_b = global.manta_spr.departure_b;
        cur_spr_f = global.manta_spr.departure_f;
        cur_gondola = gd_departure;
        break;
    case E_MANTA.RUNWAY:
        cur_spr_b = global.manta_spr.runway_b;
        cur_spr_f = global.manta_spr.runway_f;
        cur_gondola = gd_runway;
        break;
    case E_MANTA.LIFTOFF:
        if (anim_frame == 0) {
            cur_spr_b = global.manta_spr.liftoff1_b;
            cur_spr_f = global.manta_spr.liftoff1_f;
            cur_gondola = gd_liftoff1;
        } else {
            cur_spr_b = global.manta_spr.liftoff2_b;
            cur_spr_f = global.manta_spr.liftoff2_f;
            cur_gondola = gd_liftoff2;
        }
        break;
    case E_MANTA.DESCENT:
        if (anim_frame == 0) {
            cur_spr_b = global.manta_spr.descent1_b;
            cur_spr_f = global.manta_spr.descent1_f;
            cur_gondola = gd_descent1;
        } else {
            cur_spr_b = global.manta_spr.descent2_b;
            cur_spr_f = global.manta_spr.descent2_f;
            cur_gondola = gd_descent2;
        }
        break;
    case E_MANTA.TAXI:
        if (anim_frame == 0) {
            cur_spr_b = global.manta_spr.taxi1_b;
            cur_spr_f = global.manta_spr.taxi1_f;
            cur_gondola = gd_taxi1;
        } else {
            cur_spr_b = global.manta_spr.taxi2_b;
            cur_spr_f = global.manta_spr.taxi2_f;
            cur_gondola = gd_taxi2;
        }
        break;
    case E_MANTA.LANDED:
    case E_MANTA.CHOICE:
    case E_MANTA.CHOICE_RESULT:
        cur_spr_b = global.manta_spr.landing_b;
        cur_spr_f = global.manta_spr.landing_f;
        cur_gondola = gd_landing;
        break;
    case E_MANTA.FAREWELL_RUNWAY:
        cur_spr_b = global.manta_spr.runway_b;
        cur_spr_f = global.manta_spr.runway_f;
        cur_gondola = gd_runway;
        break;
    case E_MANTA.FAREWELL_LIFTOFF:
        if (anim_frame == 0) {
            cur_spr_b = global.manta_spr.liftoff1_b;
            cur_spr_f = global.manta_spr.liftoff1_f;
            cur_gondola = gd_liftoff1;
        } else {
            cur_spr_b = global.manta_spr.liftoff2_b;
            cur_spr_f = global.manta_spr.liftoff2_f;
            cur_gondola = gd_liftoff2;
        }
        break;
}

// Update gondola room bounds (scaled)
var _s = manta_scale;
gondola_room_left = x - (cur_gondola[0] - cur_gondola[2]) * _s;
gondola_room_right = x + (cur_gondola[3] - cur_gondola[0]) * _s;
gondola_room_floor = y;

// State machine
switch (state) {
    case E_MANTA.WAITING:
        var _player = instance_find(obj_player, 0);
        if (_player != noone && !dialogue_shown && _player.x >= x - 1000) {
            dialogue_shown = true;
            _player.state = player_state_puzzle;
            var _dlg = instance_create_depth(0, 0, -1000, obj_dialogue);
            _dlg.stages = [
                { prompt: "The manta appears to be offering you a ride to the next Isle. It seems, though civilization is long gone, that it continues to circle the Isles, forever carrying out its role.", options: [], correct_index: 0 }
            ];
            _dlg.stage_index = 0;
            _dlg.prompt = _dlg.stages[0].prompt;
            _dlg.options = [];
            _dlg.correct_index = 0;
            _dlg.option_alpha = [];
            _dlg.caller = noone;
            state = E_MANTA.DIALOGUE;
        }
        break;

    case E_MANTA.DIALOGUE:
        if (!instance_exists(obj_dialogue)) {
            state = E_MANTA.BOARDING;
            gondola_active = true;
            with (obj_player) state = player_state_idle;
        }
        break;

    case E_MANTA.BOARDING:
        var _player = instance_find(obj_player, 0);
        if (_player != noone && _player.on_ground) {
            if (_player.x >= gondola_room_left && _player.x <= gondola_room_right) {
                if (abs(_player.y - y) < 20) {
                    rider = _player;
                    _player.state = player_state_puzzle;
                    _player.sprite_index = spr_player_idle;
                    _player.image_speed = 1;
                    _player.x_speed = 0;
                    _player.y_speed = 0;
                    gondola_active = false;
                    state = E_MANTA.RUNWAY;
                    state_timer = 0;
                }
            }
        }
        break;

    case E_MANTA.RUNWAY:
        state_timer++;
        vx = -1.5;
        vy = -0.8;
        x += vx;
        y += vy;
        if (rider != noone) {
            rider.x = x;
            rider.y = y + player_y_offset;
        }
        if (state_timer >= 60) {
            state = E_MANTA.LIFTOFF;
            state_timer = 0;
            anim_timer = 0;
            anim_frame = 0;
        }
        break;

    case E_MANTA.LIFTOFF:
        anim_timer++;
        if (anim_timer >= 50) { anim_timer = 0; anim_frame = 1 - anim_frame; }
        vx = -3;
        vy = -8;
        x += vx;
        y += vy;
        if (rider != noone) {
            rider.x = x;
            rider.y = y + player_y_offset;
        }
        if (y < -1800) {
            state = E_MANTA.DESCENT;
            state_timer = 0;
            anim_timer = 0;
            anim_frame = 0;
            y = -1200;
            x += 800;
            if (rider != noone) {
                rider.x = x;
                rider.y = y + player_y_offset;
            }
        }
        break;

    case E_MANTA.DESCENT:
        anim_timer++;
        if (anim_timer >= 50) { anim_timer = 0; anim_frame = 1 - anim_frame; }
        vx = 7;
        vy = 4;
        x += vx;
        y += vy;
        if (rider != noone) {
            rider.x = x;
            rider.y = y + player_y_offset;
        }
        if (y >= taxi_y) {
            y = taxi_y;
            state = E_MANTA.TAXI;
            state_timer = 0;
            anim_timer = 0;
            anim_frame = 0;
            vy = 0;
            if (rider != noone) {
                rider.y = y + player_y_offset;
            }
        }
        break;

    case E_MANTA.TAXI:
        anim_timer++;
        if (anim_timer >= 50) { anim_timer = 0; anim_frame = 1 - anim_frame; }
        vx = 6;
        x += vx;
        if (rider != noone) {
            rider.x += vx;
            rider.y = y + player_y_offset;
            var _hmove = input_check("right") - input_check("left");
            if (_hmove != 0) {
                rider.x += _hmove * 3;
                rider.facing = sign(_hmove);
                rider.image_xscale = rider.facing * rider.player_scale;
                rider.sprite_index = spr_player_walk;
                rider.image_speed = 0.15;
            } else {
                rider.sprite_index = spr_player_idle;
            }
            rider.x = clamp(rider.x, gondola_room_left, gondola_room_right);
            rider.x_speed = 0;
            rider.y_speed = 0;
        }
        if (x >= dock_x) {
            if (is_ending_manta) {
                if (x > room_width + 500 && global.ending_state == 0) {
                    global.ending_state = 1;
                    global.ending_alpha = 0;
                    if (rider != noone) {
                        rider.visible = false;
                    }
                }
            } else if (room == rm_isles) {
                vx = 0;
                vy = 0;
                global.manta_arriving = true;
                var _trans = instance_find(obj_transition, 0);
                if (_trans != noone && _trans.trans_state == E_TRANSITION.NONE) {
                    _trans.transition_start(rm_isles2, 500, 670, -1);
                }
            } else {
                vx = 0;
                gondola_active = true;
                if (room == rm_isles2) {
                    if (rider != noone) {
                        rider.state = player_state_idle;
                        rider = noone;
                    }
                    state = E_MANTA.CHOICE;
                    state_timer = 0;
                } else {
                    state = E_MANTA.LANDED;
                    state_timer = 0;
                }
            }
        }
        break;

    case E_MANTA.LANDED:
        state_timer++;
        if (rider != noone) {
            if (state_timer >= 30) {
                rider.state = player_state_idle;
                rider = noone;
            } else {
                rider.x = x;
                rider.y = y + player_y_offset;
                rider.x_speed = 0;
                rider.y_speed = 0;
            }
        }
        break;

    case E_MANTA.CHOICE:
        var _dlg = instance_find(obj_dialogue, 0);
        if (_dlg != noone) {
            if (_dlg.last_selected >= 0) manta_choice = _dlg.last_selected;
        } else if (manta_choice < 0) {
            var _player = instance_find(obj_player, 0);
            var _on_gondola = (_player != noone && gondola_active
                && _player.x >= gondola_room_left && _player.x <= gondola_room_right
                && abs(_player.y - gondola_room_floor) < 20);
            if (_player != noone && _player.on_ground && !_on_gondola) {
                state_timer++;
            }
            if (state_timer >= 30) {
                gondola_active = false;
                _player.state = player_state_puzzle;
                var _dlg = instance_create_depth(0, 0, -1000, obj_dialogue);
                _dlg.stages = [
                    { prompt: "You have a choice now.", options: ["Free the Manta", "Leave the Manta"], correct_index: 0 }
                ];
                _dlg.stage_index = 0;
                _dlg.prompt = _dlg.stages[0].prompt;
                _dlg.options = ["Free the Manta", "Leave the Manta"];
                _dlg.correct_index = 0;
                _dlg.selected = 0;
                _dlg.option_alpha = [1, 1];
                _dlg.caller = noone;
                _dlg.any_correct = true;
                _dlg.show_latin_hints = false;
            }
        } else {
            var _player = instance_find(obj_player, 0);
            if (_player != noone) _player.state = player_state_puzzle;
            var _result = "";
            if (manta_choice == 0) {
                _result = "The Manta is now freed. However, it will continue to circle the Isles without end.";
            } else {
                _result = "The Manta gives no reaction. It will continue to circle the Isles without end.";
            }
            var _dlg2 = instance_create_depth(0, 0, -1000, obj_dialogue);
            _dlg2.stages = [
                { prompt: _result, options: [], correct_index: 0 }
            ];
            _dlg2.stage_index = 0;
            _dlg2.prompt = _result;
            _dlg2.options = [];
            _dlg2.correct_index = 0;
            _dlg2.option_alpha = [];
            _dlg2.caller = noone;
            _dlg2.show_latin_hints = false;
            state = E_MANTA.CHOICE_RESULT;
        }
        break;

    case E_MANTA.CHOICE_RESULT:
        if (!instance_exists(obj_dialogue)) {
            state = E_MANTA.FAREWELL_RUNWAY;
            state_timer = 0;
            vx = 0;
            vy = 0;
        }
        break;

    case E_MANTA.FAREWELL_RUNWAY:
        state_timer++;
        vx = -1.5;
        vy = -0.8;
        x += vx;
        y += vy;
        if (state_timer >= 60) {
            state = E_MANTA.FAREWELL_LIFTOFF;
            state_timer = 0;
            anim_timer = 0;
            anim_frame = 0;
        }
        break;

    case E_MANTA.FAREWELL_LIFTOFF:
        anim_timer++;
        if (anim_timer >= 50) { anim_timer = 0; anim_frame = 1 - anim_frame; }
        vx = -3;
        vy = -8;
        x += vx;
        y += vy;
        if (y < -500) {
            is_ending_manta = true;
            state = E_MANTA.WAITING;
            dialogue_shown = false;
            x = 21000;
            y = 655;
            dock_x = 23500;
            taxi_y = 655;
            vx = 0;
            vy = 0;
            anim_timer = 0;
            anim_frame = 0;
            state_timer = 0;
            rider = noone;
            manta_choice = -1;
            gondola_active = false;
            cur_spr_b = global.manta_spr.departure_b;
            cur_spr_f = global.manta_spr.departure_f;
            cur_gondola = gd_departure;
        }
        break;
}
