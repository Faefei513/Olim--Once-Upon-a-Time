sprite_index = global.hub_rune_spr;
image_speed = 0;
image_index = 0;
depth = 10;
rune_solved = false;
animating = false;

if (global.hub_rune_solved) {
    instance_create_layer(x, y, "Instances", obj_portal);
    instance_destroy();
}
