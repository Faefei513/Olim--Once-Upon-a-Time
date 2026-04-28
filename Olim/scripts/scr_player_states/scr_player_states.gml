function player_state_idle() {
    if (on_ground) energy_segments = approach(energy_segments, energy_segments_max, ENERGY_REGEN_RATE);
    sprite_index = spr_player_idle;
    x_speed = 0;
    var _hmove = input_check("right") - input_check("left");
    if (_hmove != 0) { state = player_state_walk; return; }
    if (input_check_pressed("jump") && on_ground) { state = player_state_jump; return; }
    if (!on_ground) { state = player_state_fall; return; }
}
function player_state_walk() {
    if (on_ground) energy_segments = approach(energy_segments, energy_segments_max, ENERGY_REGEN_RATE);
    var _hmove = input_check("right") - input_check("left");
    x_speed = _hmove * move_speed;
    if (_hmove != 0) facing = sign(_hmove);
    sprite_index = spr_player_walk;
    image_xscale = facing;
    if (_hmove == 0) { state = player_state_idle; return; }
    if (input_check_pressed("jump") && on_ground) { state = player_state_jump; return; }
    if (!on_ground) { state = player_state_fall; return; }
}
function player_state_jump() {
    y_speed = jump_force;
    on_ground = false;
    sprite_index = spr_player_jump;
    state = player_state_fall;
}
function player_state_fall() {
    var _hmove = input_check("right") - input_check("left");
    x_speed = _hmove * move_speed;
    if (_hmove != 0) facing = sign(_hmove);
    y_speed += GRAVITY;
    sprite_index = (y_speed < 0) ? spr_player_jump : spr_player_fall;
    image_xscale = facing;
    if (y_speed < 0) {
        // Going up: lock to frame 1 (thrust/upward pose)
        image_speed = 0;
        image_index = 1;
    } else {
        // Going down: animate but skip frame 1
        image_speed = 0.15;
        if (floor(image_index) == 1) image_index = 2;
    }
    if (input_check_pressed("fly") && has_flight && energy_segments >= 1) { state = player_state_fly; return; }
    if (input_check("jump") && y_speed > 0 && has_flight) { state = player_state_glide; return; }
    if (on_ground) { state = player_state_idle; return; }
}
function player_state_fly() {
    energy_segments -= 1;
    y_speed = FLY_THRUST_FORCE;
    var _hmove = input_check("right") - input_check("left");
    x_speed = _hmove * move_speed;
    if (_hmove != 0) facing = sign(_hmove);
    sprite_index = spr_player_fly;
    image_speed = 0;
    image_index = 1;
    image_xscale = facing;
    state = player_state_fall;
}
function player_state_glide() {
    var _hmove = input_check("right") - input_check("left");
    x_speed = _hmove * move_speed * GLIDE_H_MULTIPLIER;
    if (_hmove != 0) facing = sign(_hmove);
    y_speed += GLIDE_GRAVITY;
    y_speed = min(y_speed, GLIDE_TERMINAL);
    sprite_index = spr_player_glide;
    image_xscale = facing;
    // Animate but skip frame 1
    image_speed = 0.15;
    if (floor(image_index) == 1) image_index = 2;
    if (input_check_pressed("fly") && energy_segments >= 1) { state = player_state_fly; return; }
    if (!input_check("jump")) { state = player_state_fall; return; }
    if (on_ground) { state = player_state_idle; return; }
}
function player_state_interact() { x_speed = 0; y_speed = 0; sprite_index = spr_player_idle; }
function player_state_puzzle() { x_speed = 0; y_speed = 0; }
