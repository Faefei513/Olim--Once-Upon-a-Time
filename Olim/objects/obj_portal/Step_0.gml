var _player = instance_find(obj_player, 0);
if (_player != noone) {
    var _dist = abs(x - _player.x);
    if (_dist < 120 && !global.portal_cooldown) {
        global.portal_cooldown = true;
        if (room == rm_sky_hub) {
            global.player_spawn_x = 5300;
            room_goto(rm_hub);
        } else if (room == rm_hub) {
            global.player_spawn_x = 500;
            room_goto(rm_sky_hub);
        }
    }
    if (abs(x - _player.x) > 250) {
        global.portal_cooldown = false;
    }
}
