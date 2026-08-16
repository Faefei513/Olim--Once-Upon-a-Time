var _w = window_get_width();
var _h = window_get_height();
if (_w > 0 && _h > 0 && (surface_get_width(application_surface) != _w || surface_get_height(application_surface) != _h)) {
    surface_resize(application_surface, _w, _h);
    display_set_gui_size(900 * (_w / _h), 900);
}

// Music system
if (global.music_state == 0) {
    if (global.music_order_idx >= array_length(global.music_order)) {
        global.music_order = [0, 1, 2, 3];
        for (var _i = 3; _i > 0; _i--) {
            var _j = irandom(_i);
            var _tmp = global.music_order[_i];
            global.music_order[_i] = global.music_order[_j];
            global.music_order[_j] = _tmp;
        }
        if (global.music_current >= 0 && global.music_order[0] == global.music_current) {
            global.music_order[0] = global.music_order[1];
            global.music_order[1] = global.music_current;
        }
        global.music_order_idx = 0;
    }
    global.music_current = global.music_order[global.music_order_idx];
    global.music_order_idx++;
    var _vol = global.music_base_vol * global.music_track_vol[global.music_current];
    global.music_instance = audio_play_sound(global.music_tracks[global.music_current], 0, false);
    audio_sound_gain(global.music_instance, 0, 0);
    audio_sound_gain(global.music_instance, _vol, 3000);
    global.music_fade_started = false;
    global.music_state = 1;
} else if (global.music_state == 1) {
    if (!audio_is_playing(global.music_instance)) {
        global.music_state = 2;
        global.music_timer = 150;
    } else if (!global.music_fade_started) {
        var _len = audio_sound_length(global.music_tracks[global.music_current]);
        var _pos = audio_sound_get_track_position(global.music_instance);
        if (_len > 0 && _pos >= _len - 3) {
            audio_sound_gain(global.music_instance, 0, 3000);
            global.music_fade_started = true;
        }
    }
} else if (global.music_state == 2) {
    global.music_timer--;
    if (global.music_timer <= 0) global.music_state = 0;
}

// Ending state machine (manta carries player to ocean)
if (global.ending_state > 0) {
    if (global.ending_state == 1) {
        global.ending_alpha = min(global.ending_alpha + 0.02, 1);
        if (global.ending_alpha >= 1) {
            global.ending_state = 3;
            global.player_spawn_x = 500;
            global.player_spawn_y = 500;
            room_goto(rm_ocean);
        }
    } else if (global.ending_state == 3) {
        global.ending_alpha = max(global.ending_alpha - 0.02, 0);
        if (global.ending_alpha <= 0) {
            global.ending_state = 0;
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
    if (global.menu_teleport_expanded) _block_h += 2 * _btn_h + _btn_gap + 12;
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

    // Check teleport sub-buttons (2 rows: 3 + 2)
    if (global.menu_teleport_expanded && global.menu_hovered == -1) {
        var _sub_gap = 12;
        var _cols = 3;
        var _sub_w = (_btn_w - (_cols - 1) * _sub_gap) / _cols;
        var _tp_count = 5;
        for (var _s = 0; _s < _tp_count; _s++) {
            var _row = _s div _cols;
            var _col = _s mod _cols;
            var _sub_y = _start_y + _count * (_btn_h + _btn_gap) + _row * (_btn_h + _sub_gap);
            var _sx = _btn_x + _col * (_sub_w + _sub_gap);
            if (_mx >= _sx && _mx <= _sx + _sub_w && _my >= _sub_y && _my <= _sub_y + _btn_h) {
                global.menu_hovered = _count + _s;
                break;
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
                else if (global.menu_hovered == 9) { _dest = rm_ocean; _sx = 500; _sy = 500; }
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
if (room == rm_ocean) {
    var _player = instance_find(obj_player, 0);
    var _ruins = instance_find(obj_ocean_ruins, 0);
    if (_ruins != noone && _player != noone && point_distance(_ruins.x, _ruins.y, _player.x, _player.y) < 500) _near_rune = true;
    var _mural = instance_find(obj_ocean_mural, 0);
    if (_mural != noone && _player != noone && point_distance(_mural.x, _mural.y, _player.x, _player.y) < 500) _near_rune = true;
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

if (room == rm_ocean) {
    if (!global.goldfish_initialized) {
        global.goldfish = [];
        for (var _g = 0; _g < 3; _g++) {
            var _base = _g * 0.3 + 0.15;
            var _count = irandom_range(2, 4);
            for (var _j = 0; _j < _count; _j++) {
                goldfish_spawn(_base + random_range(-0.06, 0.06));
            }
        }
        global.goldfish_spawn_timer = 180;
        global.goldfish_initialized = true;
    }

    global.goldfish_spawn_timer--;
    if (global.goldfish_spawn_timer <= 0) {
        var _count = irandom_range(1, 2);
        for (var _j = 0; _j < _count; _j++) {
            goldfish_spawn(random_range(-0.1, 0.1));
        }
        global.goldfish_spawn_timer = irandom_range(480, 720);
    }

    for (var _i = array_length(global.goldfish) - 1; _i >= 0; _i--) {
        var _f = global.goldfish[_i];
        _f.progress += _f.speed;
        if (_f.progress > 1.1) {
            array_delete(global.goldfish, _i, 1);
            continue;
        }
        var _max_fr = global.goldfish_frames[_f.type_idx];
        if (_max_fr > 1) {
            _f.anim_timer--;
            if (_f.anim_timer <= 0) {
                _f.anim_timer = 30;
                _f.frame += _f.anim_dir;
                if (_f.frame >= _max_fr - 1) { _f.frame = _max_fr - 1; _f.anim_dir = -1; }
                else if (_f.frame <= 0) { _f.frame = 0; _f.anim_dir = 1; }
            }
        }
    }
    // Foreground fade zone (bottom-left ruins)
    var _player = instance_find(obj_player, 0);
    if (_player != noone) {
        var _dist = point_distance(_player.x, _player.y, 1800, 7200);
        var _target = clamp(1 - _dist / 600, 0, 1);
        _target = min(_target * 2.5, 1);
        global.ocean_fg_fade = lerp(global.ocean_fg_fade, _target, 0.05);
        if (global.ocean_fg_fade < 0.005) global.ocean_fg_fade = 0;
    }
    // Leviathan encounter
    if (global.leviathan_state == 0) {
        var _player = instance_find(obj_player, 0);
        if (_player != noone && _player.y >= 2800) {
            global.leviathan_state = 1;
            global.leviathan_alpha = 0;
            global.leviathan_frame = 0;
            global.leviathan_anim_timer = 0;
            global.leviathan_active_spr = global.leviathan_arrival;
            global.leviathan_dlg_created = false;
            _player.state = player_state_ocean_locked;
        }
    } else if (global.leviathan_state == 1) {
        global.leviathan_alpha = min(global.leviathan_alpha + 0.006, 1);
        global.leviathan_anim_timer++;
        if (global.leviathan_anim_timer >= 9) {
            global.leviathan_anim_timer = 0;
            global.leviathan_frame++;
            var _max_fr = sprite_get_number(global.leviathan_active_spr);
            if (global.leviathan_frame >= _max_fr) {
                if (global.leviathan_active_spr == global.leviathan_arrival) {
                    global.leviathan_active_spr = global.leviathan_blink;
                    global.leviathan_frame = 0;
                } else {
                    global.leviathan_frame = 0;
                }
            }
        }
        if (global.leviathan_alpha >= 1) {
            global.leviathan_alpha = 1;
            global.leviathan_state = 2;
        }
        with (obj_player) state = player_state_ocean_locked;
    } else if (global.leviathan_state == 2) {
        if (!global.leviathan_dlg_created) {
            if (global.leviathan_active_spr != global.leviathan_blink) {
                global.leviathan_active_spr = global.leviathan_blink;
                global.leviathan_frame = 0;
                global.leviathan_anim_timer = 0;
            }
            var _dlg = instance_create_depth(0, 0, -1000, obj_dialogue);
            var _p = global.leviathan_dlg_phase;
            if (_p == 0) {
                _dlg.stages = [
                    { prompt: "How peculiar. The Ocean has not seen a new being in... Oh, I don't even know how long. What brings you here?", options: [], correct_index: 0 },
                    { prompt: "What brings you here?", options: ["Searching for signs of civilization.", "Searching for the story of the ancient civilizations."], correct_index: 0 }
                ];
            } else if (_p == 1) {
                _dlg.stages = [
                    { prompt: "I see. I must tell you, there is nothing worth looking for. You should turn back now.", options: [], correct_index: 0 },
                    { prompt: "You should turn back now.", options: ["...", "No, there must be something of worth."], correct_index: 0 }
                ];
            } else if (_p == 2) {
                _dlg.stages = [
                    { prompt: "...", options: [], correct_index: 0 },
                    { prompt: "Good luck. The path ahead will become difficult.", options: [], correct_index: 0 }
                ];
            } else if (_p == 3) {
                _dlg.stages = [
                    { prompt: "Such trivial matters. Ultimately, all you will find are the results of an endless list of sins.", options: [], correct_index: 0 },
                    { prompt: "Poisoning the earth and the water, slaughtering the animals, taking the souls of their planets, and engaging in endless bloodshed.", options: [], correct_index: 0 },
                    { prompt: "Even in their final moments, all they could think of was their own selfish wants, resulting in their well-deserved extinction.", options: [], correct_index: 0 },
                    { prompt: "Even in their final moments, all they could think of was their own selfish wants, resulting in their well-deserved extinction.", options: ["...", "I insist, there has to have been good in many of them still."], correct_index: 0 }
                ];
            } else if (_p == 4) {
                _dlg.stages = [
                    { prompt: "...", options: [], correct_index: 0 },
                    { prompt: "I suppose, even if I tried, that you would not change your mind.", options: [], correct_index: 0 },
                    { prompt: "Good luck. The path ahead will become difficult.", options: [], correct_index: 0 }
                ];
            } else if (_p == 5) {
                _dlg.stages = [
                    { prompt: "What does it matter? Will some good deeds outweigh the towering pile of wrongdoings?", options: [], correct_index: 0 },
                    { prompt: "If I were to continue with all the horrors I've seen, the two of us would be here till the end of time.", options: [], correct_index: 0 },
                    { prompt: "If I were to continue with all the horrors I've seen, the two of us would be here till the end of time.", options: ["...", "Yes, I believe that there is worth, even in the smallest of good deeds."], correct_index: 0 }
                ];
            } else if (_p == 6) {
                _dlg.stages = [
                    { prompt: "I suppose, even if I tried, that you would not change your mind.", options: [], correct_index: 0 },
                    { prompt: "Good luck. You are honorable, but the path ahead will become difficult.", options: [], correct_index: 0 }
                ];
            }
            _dlg.stage_index = 0;
            _dlg.prompt = _dlg.stages[0].prompt;
            _dlg.options = _dlg.stages[0].options;
            _dlg.correct_index = _dlg.stages[0].correct_index;
            _dlg.option_alpha = array_create(array_length(_dlg.stages[0].options), 1);
            _dlg.any_correct = true;
            _dlg.show_latin_hints = false;
            _dlg.caller = noone;
            global.leviathan_dlg_created = true;
            global.leviathan_last_choice = -1;
        }
        global.leviathan_anim_timer++;
        if (global.leviathan_anim_timer >= 9) {
            global.leviathan_anim_timer = 0;
            global.leviathan_frame = (global.leviathan_frame + 1) % 30;
        }
        with (obj_player) state = player_state_ocean_locked;
        if (instance_exists(obj_dialogue)) {
            global.leviathan_last_choice = instance_find(obj_dialogue, 0).last_selected;
        } else if (global.leviathan_dlg_created) {
            var _next = -1;
            if (global.leviathan_dlg_phase == 0) _next = 1;
            else if (global.leviathan_dlg_phase == 1) _next = (global.leviathan_last_choice == 0) ? 2 : 3;
            else if (global.leviathan_dlg_phase == 3) _next = (global.leviathan_last_choice == 0) ? 4 : 5;
            else if (global.leviathan_dlg_phase == 5) _next = (global.leviathan_last_choice == 0) ? 4 : 6;
            if (_next < 0) {
                global.leviathan_state = 3;
            } else {
                global.leviathan_dlg_phase = _next;
                global.leviathan_dlg_created = false;
            }
        }
    } else if (global.leviathan_state == 3) {
        global.leviathan_anim_timer++;
        if (global.leviathan_anim_timer >= 9) {
            global.leviathan_anim_timer = 0;
            global.leviathan_frame = (global.leviathan_frame + 1) % 30;
        }
        with (obj_player) state = player_state_ocean_locked;
        global.leviathan_alpha = max(global.leviathan_alpha - 0.006, 0);
        if (global.leviathan_alpha <= 0) {
            global.leviathan_state = 4;
            with (obj_player) state = player_state_idle;
        }
    }
    // Spawn portal at end of goldfish line once all interactions are complete
    if (!global.ocean_portal_spawned && global.leviathan_state == 4 && global.ocean_ruins_seen && global.ocean_mural_seen) {
        instance_create_layer(5500, 4300, "Instances", obj_portal);
        global.ocean_portal_spawned = true;
    }
} else if (global.goldfish_initialized) {
    global.goldfish = [];
    global.goldfish_initialized = false;
    global.ocean_fg_fade = 0;
    global.leviathan_state = 0;
    global.leviathan_dlg_created = false;
    global.leviathan_dlg_phase = 0;
    global.ocean_ruins_seen = false;
    global.ocean_mural_seen = false;
    global.ocean_portal_spawned = false;
}
