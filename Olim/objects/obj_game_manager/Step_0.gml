var _w = window_get_width();
var _h = window_get_height();
if (_w > 0 && _h > 0 && (surface_get_width(application_surface) != _w || surface_get_height(application_surface) != _h)) {
    surface_resize(application_surface, _w, _h);
}

if (input_check_pressed("pause")) {
    if (window_get_fullscreen()) {
        window_set_fullscreen(false);
        window_set_size(1600, 750);
    } else {
        window_set_fullscreen(true);
    }
}

if (room == rm_hub && global.move_hint_timer > 0) {
    global.move_hint_timer--;
}

if (room == rm_sky_hub && global.flight_hint_timer > 0) {
    global.flight_hint_timer--;
}

if (room == rm_hub) {
    var _rune = instance_find(obj_hub_rune, 0);
    var _player = instance_find(obj_player, 0);
    if (_rune != noone && _player != noone && abs(_rune.x - _player.x) < 300) {
        global.interact_hint_timer = min(global.interact_hint_timer + 1, 5 * game_get_speed(gamespeed_fps));
    } else {
        global.interact_hint_timer = max(global.interact_hint_timer - 1, 0);
    }
}
