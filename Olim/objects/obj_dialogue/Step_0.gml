if (dlg_state == "fade_in") {
    alpha = min(alpha + 0.05, 1);
    if (alpha >= 1) dlg_state = "active";
}

if (dlg_state == "fade_out") {
    alpha = max(alpha - 0.05, 0);
    if (alpha <= 0) {
        with (obj_player) state = player_state_idle;
        instance_destroy();
    }
    return;
}

if (fading_option != -1) {
    option_alpha[fading_option] = max(option_alpha[fading_option] - 0.05, 0);
    if (option_alpha[fading_option] <= 0) {
        fading_option = -1;
        var _found = false;
        for (var _i = 0; _i < array_length(options); _i++) {
            if (option_alpha[_i] > 0 && _i != correct_index) { _found = true; break; }
        }
        if (!_found) {
            selected = correct_index;
        } else {
            while (option_alpha[selected] <= 0) {
                selected = (selected + 1) % array_length(options);
            }
        }
    }
    return;
}

if (dlg_state != "active") return;

if (input_check_pressed("up")) {
    var _s = selected - 1;
    while (_s >= 0 && option_alpha[_s] <= 0) _s--;
    if (_s >= 0) selected = _s;
}
if (input_check_pressed("down")) {
    var _s = selected + 1;
    while (_s < array_length(options) && option_alpha[_s] <= 0) _s++;
    if (_s < array_length(options)) selected = _s;
}

if (input_check_pressed("jump") || input_check_pressed("interact")) {
    if (selected == correct_index) {
        if (stage_index < array_length(stages) - 1) {
            stage_index++;
            prompt = stages[stage_index].prompt;
            options = stages[stage_index].options;
            correct_index = stages[stage_index].correct_index;
            selected = 0;
            option_alpha = array_create(array_length(options), 1);
            fading_option = -1;
        } else {
            dlg_state = "fade_out";
            if (caller != noone && instance_exists(caller)) {
                caller.rune_solved = true;
            }
        }
    } else {
        fading_option = selected;
    }
}
