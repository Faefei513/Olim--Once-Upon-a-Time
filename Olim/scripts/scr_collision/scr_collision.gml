function player_move_and_collide() {
    // Cap speeds
    y_speed = clamp(y_speed, -20, 20);
    x_speed = clamp(x_speed, -20, 20);

    // Floor = top of bottom 2 tile rows
    var _floor_y = room_height - (TILE_SIZE * 2);

    // --- Horizontal ---
    x += x_speed;
    // Keep in room (use sprite half-width ~225 for 450px sprite)
    var _hw = sprite_get_xoffset(sprite_index);
    if (_hw <= 0) _hw = 225;
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

    // Ceiling: top of sprite
    var _sprite_h = sprite_get_height(sprite_index);
    if (y - _sprite_h < 0) {
        y = _sprite_h;
        y_speed = 0;
    }
}
