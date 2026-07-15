cam = camera_create();
camera_set_view_size(cam, VIEW_W, VIEW_H);
view_camera[0] = cam;
view_enabled = true;
view_visible[0] = true;
cam_x = 0; cam_y = 0;
target = noone;
shake_amount = 0; shake_decay = 0.9;
