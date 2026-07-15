global.input_map = {};
global.input_map[$ "left"]     = ord("A");
global.input_map[$ "right"]    = ord("D");
global.input_map[$ "up"]       = ord("W");
global.input_map[$ "down"]     = ord("S");
global.input_map[$ "jump"]     = vk_space;
global.input_map[$ "fly"]      = ord("X");
global.input_map[$ "interact"] = ord("C");
global.input_map[$ "return_home"] = ord("R");
global.input_map[$ "pause"]    = vk_escape;
global.input_map[$ "skip"]     = vk_return;

function input_check(_action) {
    if (global.menu_open) return false;
    return keyboard_check(global.input_map[$ _action]);
}
function input_check_pressed(_action) {
    if (global.menu_open) return false;
    return keyboard_check_pressed(global.input_map[$ _action]);
}
function input_check_released(_action) {
    if (global.menu_open) return false;
    return keyboard_check_released(global.input_map[$ _action]);
}
