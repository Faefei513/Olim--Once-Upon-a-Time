// Ensure views stay enabled (persists across room changes)
view_enabled = true;
view_visible[0] = true;
view_camera[0] = cam;

if (room == rm_ocean) {
    camera_set_view_size(cam, VIEW_W * 2, VIEW_H * 2);
} else {
    camera_set_view_size(cam, VIEW_W, VIEW_H);
}

if (room == rm_title || room == rm_boot) { target = noone; }
else if (instance_exists(obj_player)) { target = obj_player; }
else { target = noone; }
if (target != noone) {
    var _vw = camera_get_view_width(cam);
    var _vh = camera_get_view_height(cam);

    var _tx = target.x - _vw / 2;
    var _ty = target.y - _vh / 2;

    var _manta = instance_find(obj_manta, 0);
    if (_manta != noone && _manta.rider != noone && (_manta.state == E_MANTA.TAXI || _manta.state == E_MANTA.DESCENT)) {
        _tx = _manta.x - _vw / 2;
        _ty = _manta.y + 200 - _vh / 2;
    }

    // Snap instantly on first frame, then lerp
    if (cam_x == 0 && cam_y == 0) {
        cam_x = _tx;
        cam_y = _ty;
    } else {
        cam_x = lerp(cam_x, _tx, CAMERA_LERP_SPEED);
        cam_y = lerp(cam_y, _ty, CAMERA_LERP_SPEED);
    }

    cam_x = clamp(cam_x, 0, room_width - _vw);
    cam_y = clamp(cam_y, 0, room_height - _vh);

    if (shake_amount > 0.5) {
        cam_x += random_range(-shake_amount, shake_amount);
        cam_y += random_range(-shake_amount, shake_amount);
        shake_amount *= shake_decay;
    } else {
        shake_amount = 0;
    }
}
camera_set_view_pos(cam, cam_x, cam_y);
