if (global.forest_rune_solved) {
    instance_destroy();
    return;
}
sprite_index = global.forest_rune_spr;
image_speed = 0;
image_index = 0;
depth = 10;
rune_solved = false;
animating = false;
