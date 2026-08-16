if (global.ending_state > 0) return;

var _hub_idx = (room == rm_hub) ? image_index : 0;
if (room == rm_hub && (input_check_pressed("jump") || input_check_pressed("fly")) && !hub_full_anim && state != player_state_puzzle) {
    hub_full_anim = true;
    _hub_idx = 1;
}
state();
player_move_and_collide();
energy_segments = clamp(energy_segments, 0, energy_segments_max);

if (room == rm_hub) {
    if (on_ground && !input_check_pressed("jump")) hub_full_anim = false;
    sprite_index = spr_player_jump;
    image_index = _hub_idx;
    if (hub_full_anim) {
        image_speed = 0.4;
        if (image_index >= sprite_get_number(spr_player_jump) - 1) hub_full_anim = false;
    } else {
        image_speed = 0.15;
        if (floor(image_index) == 1) image_index = 2;
    }
}
