depth = 5;
manta_scale = 2.5;
state = E_MANTA.WAITING;
dialogue_shown = false;
anim_timer = 0;
anim_frame = 0;
state_timer = 0;
rider = noone;
vx = 0;
vy = 0;
player_y_offset = -100;

manta_choice = -1;
gondola_active = false;
gondola_room_left = 0;
gondola_room_right = 0;
gondola_room_floor = 0;

// Gondola interior per phase: [center_x, floor_y, left_x, right_x] in sprite space
gd_departure = [347, 384, 261, 434];
gd_runway    = [358, 330, 271, 445];
gd_liftoff1  = [471, 279, 404, 538];
gd_liftoff2  = [471, 279, 404, 539];
gd_descent1  = [708, 586, 623, 794];
gd_descent2  = [716, 530, 621, 811];
gd_taxi1     = [724, 446, 620, 828];
gd_taxi2     = [714, 455, 620, 808];
gd_landing   = [667, 384, 581, 754];

dock_x = 22000;
taxi_y = 600;

cur_spr_b = global.manta_spr.departure_b;
cur_spr_f = global.manta_spr.departure_f;
cur_gondola = gd_departure;

is_ending_manta = false;

if (room == rm_isles2 && !global.manta_arriving) {
    is_ending_manta = true;
    x = 21000;
    y = 655;
    dock_x = 23500;
    taxi_y = 655;
    cur_spr_b = global.manta_spr.departure_b;
    cur_spr_f = global.manta_spr.departure_f;
    cur_gondola = gd_departure;
}

if (global.manta_arriving) {
    global.manta_arriving = false;
    state = E_MANTA.TAXI;
    anim_timer = 0;
    anim_frame = 0;
    state_timer = 0;
    x = 500;
    y = 670;
    dock_x = 7000;
    taxi_y = 670;
    vx = 6;
    cur_spr_b = global.manta_spr.taxi1_b;
    cur_spr_f = global.manta_spr.taxi1_f;
    cur_gondola = gd_taxi1;
    var _player = instance_find(obj_player, 0);
    if (_player != noone) {
        rider = _player;
        _player.state = player_state_puzzle;
        _player.sprite_index = spr_player_idle;
        _player.image_speed = 1;
        _player.x_speed = 0;
        _player.y_speed = 0;
        _player.x = x;
        _player.y = y + player_y_offset;
    }
}
