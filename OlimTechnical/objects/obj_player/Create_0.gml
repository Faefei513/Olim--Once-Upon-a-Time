x_speed = 0; y_speed = 0;
move_speed = MOVE_SPEED; jump_force = JUMP_FORCE;
on_ground = false; facing = 1;
if (room == rm_ocean) player_scale = 1.0;
else if (room == rm_forest) player_scale = 0.8;
else player_scale = 0.6;
energy_segments = MAX_ENERGY_SEGMENTS;
energy_segments_max = MAX_ENERGY_SEGMENTS;
state = (room == rm_ocean) ? player_state_ocean : player_state_idle;
has_flight = true; has_extended_flight = false;
has_water_glide = false; has_wind_dash = false;
can_interact = false; interact_target = noone;
last_ground_x = x;
last_ground_y = y;
hub_full_anim = false;
sprite_index = spr_player_idle; image_speed = 1;
image_xscale = player_scale;
image_yscale = player_scale;

if (global.player_spawn_x != -1) {
    x = global.player_spawn_x;
    global.player_spawn_x = -1;
}
if (global.player_spawn_y != -1) {
    y = global.player_spawn_y;
    global.player_spawn_y = -1;
}
