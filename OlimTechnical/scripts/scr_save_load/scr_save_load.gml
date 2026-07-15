function save_game() {
    if (global.test_run || global.save_slot < 1) return;
    if (room == rm_title || room == rm_boot) return;
    var _file = "save_slot_" + string(global.save_slot) + ".ini";
    ini_open(_file);
    ini_write_real("game", "current_realm", global.current_realm);
    ini_write_real("game", "hub_rune_solved", global.hub_rune_solved);
    ini_write_real("game", "forest_rune_solved", global.forest_rune_solved);
    ini_write_string("game", "current_room", room_get_name(room));
    var _player = instance_find(obj_player, 0);
    if (_player != noone) {
        ini_write_real("game", "player_x", _player.x);
        ini_write_real("game", "player_y", _player.y);
    }
    ini_close();
}

function reset_hints() {
    global.move_hint_timer = 10 * game_get_speed(gamespeed_fps);
    global.flight_hint_timer = 10 * game_get_speed(gamespeed_fps);
    global.esc_hint_timer = 10 * game_get_speed(gamespeed_fps);
    global.interact_hint_timer = 0;
    global.interact_hint_age = 0;
}

function load_game(_slot) {
    global.save_slot = _slot;
    global.test_run = false;
    var _file = "save_slot_" + string(_slot) + ".ini";
    ini_open(_file);
    global.current_realm = ini_read_real("game", "current_realm", E_REALM.SKY);
    global.hub_rune_solved = ini_read_real("game", "hub_rune_solved", 0);
    global.forest_rune_solved = ini_read_real("game", "forest_rune_solved", 0);
    var _room_name = ini_read_string("game", "current_room", "rm_sky_hub");
    global.player_spawn_x = ini_read_real("game", "player_x", -1);
    global.player_spawn_y = ini_read_real("game", "player_y", -1);
    ini_close();
    reset_hints();
    room_goto(asset_get_index(_room_name));
}

function new_game(_slot) {
    global.save_slot = _slot;
    global.test_run = false;
    global.current_realm = E_REALM.SKY;
    global.hub_rune_solved = false;
    global.forest_rune_solved = false;
    global.player_spawn_x = -1;
    global.player_spawn_y = -1;
    reset_hints();
    room_goto(rm_hub);
}

function start_test_run(_creator) {
    global.save_slot = -1;
    global.test_run = true;
    global.creator_mode = _creator;
    global.current_realm = E_REALM.SKY;
    global.hub_rune_solved = false;
    global.forest_rune_solved = false;
    global.player_spawn_x = -1;
    global.player_spawn_y = -1;
    reset_hints();
    room_goto(rm_hub);
}

function save_slot_exists(_slot) {
    return file_exists("save_slot_" + string(_slot) + ".ini");
}

function save_slot_info(_slot) {
    if (!save_slot_exists(_slot)) return undefined;
    var _file = "save_slot_" + string(_slot) + ".ini";
    ini_open(_file);
    var _room_name = ini_read_string("game", "current_room", "rm_sky_hub");
    ini_close();

    var _display = "Unknown";
    if (_room_name == "rm_sky_hub") _display = "Alpha Room";
    else if (_room_name == "rm_hub") _display = "The Hub";
    else if (_room_name == "rm_forest") _display = "The Forest";

    return { room_display: _display };
}
