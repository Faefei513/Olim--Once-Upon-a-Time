// Ensure views stay enabled (persists across room changes)
view_enabled = true;
view_visible[0] = true;
view_camera[0] = cam;

if (room == rm_title || room == rm_boot) { target = noone; }
else if (instance_exists(obj_player)) { target = obj_player; }
else { target = noone; }
if (target != noone) {
    var _tx = target.x - VIEW_W / 2;
    var _ty = target.y - VIEW_H / 2;

    // Snap instantly on first frame, then lerp
    if (cam_x == 0 && cam_y == 0) {
        cam_x = _tx;
        cam_y = _ty;
    } else {
        cam_x = lerp(cam_x, _tx, CAMERA_LERP_SPEED);
        cam_y = lerp(cam_y, _ty, CAMERA_LERP_SPEED);
    }

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
