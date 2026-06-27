function player_move_and_collide() {
    // Cap speeds
    y_speed = clamp(y_speed, -20, 20);
    x_speed = clamp(x_speed, -20, 20);

    var _tile_h = (global.floor_tile != -1) ? sprite_get_height(global.floor_tile) * global.floor_scale : (TILE_SIZE * 2);
    var _floor_y = room_height - _tile_h + 140;

    // --- Horizontal ---
    x += x_speed;
    var _hw = sprite_get_xoffset(sprite_index) * abs(image_xscale);
    if (_hw <= 0) _hw = 225 * abs(image_xscale);
    if (x < _hw) { x = _hw; x_speed = 0; }
    if (x > room_width - _hw) { x = room_width - _hw; x_speed = 0; }

    // --- Vertical ---
    y += y_speed;

    on_ground = false;

    // With bottom-center origin, y IS the feet position
    // Floor collision: feet at or below floor
    if (y >= _floor_y) {
        y = _floor_y;
        y_speed = 0;
        on_ground = true;
    }

    // Ground margin check (within 2px of floor and not jumping)
    if (!on_ground && y_speed >= 0 && y >= _floor_y - 2) {
        on_ground = true;
    }

    var _sprite_h = sprite_get_height(sprite_index) * abs(image_yscale);
    if (y - _sprite_h < 0) {
        y = _sprite_h;
        y_speed = 0;
    }
}
