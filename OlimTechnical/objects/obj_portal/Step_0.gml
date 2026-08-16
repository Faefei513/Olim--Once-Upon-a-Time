var _player = instance_find(obj_player, 0);
var _trans = instance_find(obj_transition, 0);
if (_player != noone && _trans != noone && _trans.trans_state == E_TRANSITION.NONE) {
    var _dist = (room == rm_ocean) ? point_distance(x, y, _player.x, _player.y) : abs(x - _player.x);
    if (_dist < 120 && !global.portal_cooldown) {
        global.portal_cooldown = true;
        if (room == rm_alpha) {
            if (x > room_width / 2) {
                _trans.transition_start(rm_forest, 720, 750, -1);
            } else {
                _trans.transition_start(rm_hub, 5300, 750, -1);
            }
        } else if (room == rm_hub) {
            _trans.transition_start(rm_alpha, 500, 750, -1);
        } else if (room == rm_forest) {
            _trans.transition_start(rm_alpha, 4800, 750, -1);
        } else if (room == rm_ocean) {
            _trans.transition_start(rm_title, 0, 0, -1);
        }
    }
    var _reset_dist = (room == rm_ocean) ? point_distance(x, y, _player.x, _player.y) : abs(x - _player.x);
    if (_reset_dist > 250) {
        global.portal_cooldown = false;
    }
}
