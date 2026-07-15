btn_w = 520;
btn_h = 60;
btn_gap = 16;
hovered = -1;
fade_alpha = 0;
pending_action = -1;
pending_slot = 0;
test_expanded = false;

slot_info = [];
for (var _i = 0; _i < 3; _i++) {
    if (save_slot_exists(_i + 1)) {
        slot_info[_i] = save_slot_info(_i + 1);
    } else {
        slot_info[_i] = undefined;
    }
}
