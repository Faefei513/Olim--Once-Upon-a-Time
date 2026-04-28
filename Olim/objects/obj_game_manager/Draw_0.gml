// Draw sky background stretched to fill the entire room
if (global.sky_bg != -1) {
    draw_sprite_stretched(global.sky_bg, 0, 0, 0, room_width, room_height);
}

// Draw green floor (bottom 32 pixels of room)
var _floor_y = room_height - (TILE_SIZE * 2);
draw_set_colour(make_colour_rgb(76, 153, 0));
draw_rectangle(0, _floor_y, room_width, room_height, false);
draw_set_colour(c_white);
