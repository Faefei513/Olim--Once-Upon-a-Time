# Olim — Phase 1 Setup Guide

Open the project in GameMaker, then follow these steps in order.
After creating each asset in the IDE, paste the corresponding GML code.

---

## Step 1: Create Sprites

Right-click in Asset Browser > Create Sprite for each:

| Name | Size | Origin |
|------|------|--------|
| spr_player_idle | 32x32 | Middle Center |
| spr_player_walk | 32x32 | Middle Center |
| spr_player_jump | 32x32 | Middle Center |
| spr_player_fall | 32x32 | Middle Center |
| spr_player_fly | 32x32 | Middle Center |
| spr_player_glide | 32x32 | Middle Center |
| spr_tileset_collision | 16x16 | Top Left |

For placeholders: just draw a colored rectangle in each.
For spr_tileset_collision: fill the entire 16x16 with solid white.

---

## Step 2: Create Tileset

Right-click > Create Tile Set:
- Name: `ts_collision`
- Sprite: `spr_tileset_collision`
- Tile Width: 16, Tile Height: 16

---

## Step 3: Create Scripts

Right-click > Create Script for each. Name them exactly as shown,
then paste the code from the corresponding section below.

### scr_enums
```gml
// scr_enums — All game enumerations

enum E_PLAYER_STATE {
    IDLE,
    WALK,
    JUMP,
    FALL,
    FLY,
    GLIDE,
    INTERACT,
    PUZZLE
}

enum E_REALM {
    SKY,
    FOREST,
    FLOATING_ISLES,
    OCEAN,
    FLOWER_FIELD,
    RUINS,
    COUNT
}

enum E_ABILITY {
    BASIC_FLIGHT,
    EXTENDED_FLIGHT_1,
    EXTENDED_FLIGHT_2,
    EXTENDED_FLIGHT_3,
    EXTENDED_FLIGHT_4,
    WATER_GLIDE,
    WIND_DASH,
    NONE
}

enum E_CREATURE_STATE {
    IDLE,
    WANDER,
    APPROACH,
    RETREAT,
    INTERACT
}

enum E_TRANSITION {
    NONE,
    FADE_OUT,
    FADE_IN
}
```

### scr_macros
```gml
// scr_macros — Global constants

// Energy (segment-based flight)
#macro MAX_ENERGY_SEGMENTS  4
#macro ENERGY_REGEN_RATE    0.02
#macro FLY_THRUST_FORCE    -6.0

// Physics
#macro GRAVITY              0.4
#macro MOVE_SPEED           3.5
#macro JUMP_FORCE          -7.0
#macro GLIDE_GRAVITY        0.15
#macro GLIDE_TERMINAL       1.5
#macro GLIDE_H_MULTIPLIER   1.5

// Camera
#macro CAMERA_LERP_SPEED    0.08
#macro VIEW_W               480
#macro VIEW_H               270

// Tiles
#macro TILE_SIZE            16

// Save
#macro SAVE_FILE            "olim_save.json"

// Transition
#macro TRANS_SPEED           0.04
```

### scr_input
```gml
// scr_input — Input abstraction layer

global.input_map = {};
global.input_map[$ "left"]     = vk_left;
global.input_map[$ "right"]    = vk_right;
global.input_map[$ "up"]       = vk_up;
global.input_map[$ "down"]     = vk_down;
global.input_map[$ "jump"]     = ord("Z");
global.input_map[$ "fly"]      = ord("X");
global.input_map[$ "interact"] = ord("C");
global.input_map[$ "return_home"] = ord("R");
global.input_map[$ "pause"]    = vk_escape;

function input_check(_action) {
    return keyboard_check(global.input_map[$ _action]);
}

function input_check_pressed(_action) {
    return keyboard_check_pressed(global.input_map[$ _action]);
}

function input_check_released(_action) {
    return keyboard_check_released(global.input_map[$ _action]);
}
```

### scr_utils
```gml
// scr_utils — General utility functions

function approach(_current, _target, _amount) {
    if (_current < _target) {
        return min(_current + _amount, _target);
    } else {
        return max(_current - _amount, _target);
    }
}

function sign_safe(_val) {
    if (_val > 0) return 1;
    if (_val < 0) return -1;
    return 0;
}
```

### scr_collision
```gml
// scr_collision — Tilemap collision helpers

function tilemap_collision_h(_tilemap, _xspeed) {
    if (_xspeed == 0) return false;

    var _bbox_side = (_xspeed > 0) ? bbox_right : bbox_left;
    var _check_x = _bbox_side + _xspeed;

    if (tilemap_get_at_pixel(_tilemap, _check_x, bbox_top) != 0
     || tilemap_get_at_pixel(_tilemap, _check_x, bbox_bottom) != 0) {
        if (_xspeed > 0) {
            x = ((_check_x) div TILE_SIZE) * TILE_SIZE - (bbox_right - x) - 1;
        } else {
            x = ((_check_x) div TILE_SIZE + 1) * TILE_SIZE - (bbox_left - x);
        }
        return true;
    }
    return false;
}

function tilemap_collision_v(_tilemap, _yspeed) {
    if (_yspeed == 0) return false;

    var _bbox_side = (_yspeed > 0) ? bbox_bottom : bbox_top;
    var _check_y = _bbox_side + _yspeed;

    if (tilemap_get_at_pixel(_tilemap, bbox_left, _check_y) != 0
     || tilemap_get_at_pixel(_tilemap, bbox_right, _check_y) != 0) {
        if (_yspeed > 0) {
            y = ((_check_y) div TILE_SIZE) * TILE_SIZE - (bbox_bottom - y) - 1;
        } else {
            y = ((_check_y) div TILE_SIZE + 1) * TILE_SIZE - (bbox_top - y);
        }
        return true;
    }
    return false;
}

function player_move_and_collide() {
    var _col_map = layer_tilemap_get_id("Collision");

    if (tilemap_collision_h(_col_map, x_speed)) {
        x_speed = 0;
    }
    x += x_speed;

    on_ground = false;
    if (tilemap_collision_v(_col_map, y_speed)) {
        if (y_speed > 0) on_ground = true;
        y_speed = 0;
    }
    y += y_speed;
}
```

### scr_player_states
```gml
// scr_player_states — Player state machine functions

function player_state_idle() {
    if (on_ground) {
        energy_segments = approach(energy_segments, energy_segments_max, ENERGY_REGEN_RATE);
    }

    sprite_index = spr_player_idle;
    x_speed = 0;

    var _hmove = input_check("right") - input_check("left");
    if (_hmove != 0) { state = player_state_walk; return; }
    if (input_check_pressed("jump") && on_ground) { state = player_state_jump; return; }
    if (!on_ground) { state = player_state_fall; return; }
}

function player_state_walk() {
    if (on_ground) {
        energy_segments = approach(energy_segments, energy_segments_max, ENERGY_REGEN_RATE);
    }

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

    if (input_check_pressed("fly") && has_flight && energy_segments >= 1) {
        state = player_state_fly;
        return;
    }
    if (input_check("jump") && y_speed > 0 && has_flight) {
        state = player_state_glide;
        return;
    }
    if (on_ground) {
        state = player_state_idle;
        return;
    }
}

function player_state_fly() {
    energy_segments -= 1;
    y_speed = FLY_THRUST_FORCE;

    var _hmove = input_check("right") - input_check("left");
    x_speed = _hmove * move_speed;
    if (_hmove != 0) facing = sign(_hmove);

    sprite_index = spr_player_fly;
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

    if (input_check_pressed("fly") && energy_segments >= 1) {
        state = player_state_fly;
        return;
    }
    if (!input_check("jump")) {
        state = player_state_fall;
        return;
    }
    if (on_ground) {
        state = player_state_idle;
        return;
    }
}

function player_state_interact() {
    x_speed = 0;
    y_speed = 0;
    sprite_index = spr_player_idle;
}

function player_state_puzzle() {
    x_speed = 0;
    y_speed = 0;
}
```

---

## Step 4: Create Objects

Right-click > Create Object for each. Add the events listed and paste the code.

### obj_game_manager
- **Persistent: YES** (check the Persistent box)
- **Create Event:**
```gml
global.current_realm = E_REALM.SKY;
global.game_complete = false;
global.free_roam = false;

global.realm_unlocked = array_create(E_REALM.COUNT, false);
global.realm_unlocked[E_REALM.SKY] = true;

global.runes_found = [];
global.total_runes = 0;

global.cosmetics_obtained = [];
global.active_cosmetic = "default";
```

### obj_camera
- **Persistent: YES**
- **Create Event:**
```gml
cam = camera_create();
camera_set_view_size(cam, VIEW_W, VIEW_H);
view_camera[0] = cam;
view_enabled = true;
view_visible[0] = true;

cam_x = 0;
cam_y = 0;
target = noone;
shake_amount = 0;
shake_decay = 0.9;
```
- **Step Event:**
```gml
if (instance_exists(obj_player)) target = obj_player;

if (target != noone) {
    var _tx = target.x - VIEW_W / 2;
    var _ty = target.y - VIEW_H / 2;

    cam_x = lerp(cam_x, _tx, CAMERA_LERP_SPEED);
    cam_y = lerp(cam_y, _ty, CAMERA_LERP_SPEED);

    cam_x = clamp(cam_x, 0, room_width - VIEW_W);
    cam_y = clamp(cam_y, 0, room_height - VIEW_H);

    if (shake_amount > 0.5) {
        cam_x += random_range(-shake_amount, shake_amount);
        cam_y += random_range(-shake_amount, shake_amount);
        shake_amount *= shake_decay;
    } else {
        shake_amount = 0;
    }
}

camera_set_view_pos(cam, cam_x, cam_y);
```

### obj_transition
- **Persistent: YES**
- **Create Event:**
```gml
trans_state = E_TRANSITION.NONE;
trans_alpha = 0;
trans_speed = TRANS_SPEED;
pending_room = -1;
pending_x = 0;
pending_y = 0;
pending_realm = -1;

function transition_start(_room, _px, _py, _realm) {
    trans_state = E_TRANSITION.FADE_OUT;
    trans_alpha = 0;
    pending_room = _room;
    pending_x = _px;
    pending_y = _py;
    pending_realm = _realm;
}
```
- **Step Event:**
```gml
switch (trans_state) {
    case E_TRANSITION.FADE_OUT:
        trans_alpha += trans_speed;
        if (trans_alpha >= 1) {
            trans_alpha = 1;
            if (pending_realm >= 0) {
                global.current_realm = pending_realm;
            }
            room_goto(pending_room);
            obj_player.x = pending_x;
            obj_player.y = pending_y;
            trans_state = E_TRANSITION.FADE_IN;
        }
        break;

    case E_TRANSITION.FADE_IN:
        trans_alpha -= trans_speed;
        if (trans_alpha <= 0) {
            trans_alpha = 0;
            trans_state = E_TRANSITION.NONE;
        }
        break;
}
```
- **Draw GUI Event:**
```gml
if (trans_state != E_TRANSITION.NONE) {
    draw_set_alpha(trans_alpha);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}
```

### obj_input_manager
- **Persistent: YES**
- **Create Event:**
```gml
// Input map is initialized in scr_input (runs at game start)
```

### obj_player
- **Persistent: NO**
- **Sprite: spr_player_idle**
- **Create Event:**
```gml
x_speed = 0;
y_speed = 0;
move_speed = MOVE_SPEED;
jump_force = JUMP_FORCE;
on_ground = false;
facing = 1;

energy_segments = MAX_ENERGY_SEGMENTS;
energy_segments_max = MAX_ENERGY_SEGMENTS;

state = player_state_idle;

has_flight = true;
has_extended_flight = false;
has_water_glide = false;
has_wind_dash = false;

can_interact = false;
interact_target = noone;

sprite_index = spr_player_idle;
image_speed = 1;
```
- **Step Event:**
```gml
state();

player_move_and_collide();

energy_segments = clamp(energy_segments, 0, energy_segments_max);
```

---

## Step 5: Create Rooms

### rm_boot (first in room order)
- Size: 480 x 270
- Add Instances layer
- Place one each: obj_game_manager, obj_camera, obj_transition, obj_input_manager
- Room Creation Code (click the room settings gear icon):
```gml
room_goto(rm_sky_hub);
```

### rm_sky_hub (second in room order)
- Size: 2400 x 272
- Enable Views: View 0 visible, Camera W=480 H=270, Port W=1920 H=1080
- Add layers:
  1. Instances layer — place obj_player at (240, 200)
  2. Tile layer named "Collision" — set tileset to ts_collision
  3. Background layer
- Paint collision tiles: fill the bottom row and left/right edges with tiles

---

## Controls
- Arrow keys: Move
- Z: Jump
- X: Fly (uses 1 energy segment per thrust)
- Hold Z in air: Glide (free, slow descent)
