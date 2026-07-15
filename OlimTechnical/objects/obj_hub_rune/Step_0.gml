if (rune_solved && !animating) {
    animating = true;
    image_speed = 6 / game_get_speed(gamespeed_fps);
}

if (animating) {
    if (image_index >= sprite_get_number(sprite_index) - 1) {
        global.hub_rune_solved = true;
        save_game();
        instance_create_layer(x, y, "Instances", obj_portal);
        instance_destroy();
    }
    return;
}

var _player = instance_find(obj_player, 0);
if (_player != noone && !instance_exists(obj_dialogue)) {
    if (abs(x - _player.x) < 300 && input_check_pressed("interact")) {
        _player.state = player_state_puzzle;
        var _dlg = instance_create_depth(0, 0, -1000, obj_dialogue);

        if (global.creator_mode) {
            _dlg.stages = [
                {
                    prompt: "OLIM, STELLAE FULSERUNT CLARAE, RUINAS PER UNIVERSUM RELINQUERE.",
                    options: ["Once upon a time, the stars lit up bright, leaving ruins throughout the universe.", "Incorrect", "Incorrect"],
                    correct_index: 0
                },
                {
                    prompt: "EX HOC FULGORE AVIS ORTA EST.",
                    options: ["Incorrect", "From this glow a bird arose.", "Incorrect"],
                    correct_index: 1
                },
                {
                    prompt: "HARPYIA.",
                    options: ["Incorrect", "A harpy.", "Incorrect"],
                    correct_index: 1
                },
                {
                    prompt: "TUAM HISTORIAM QUAERE.",
                    options: ["Incorrect", "Incorrect", "Seek your history."],
                    correct_index: 2
                },
                {
                    prompt: "\"PER ASPERA AD ASTRA.\" (- IGNOTUS)",
                    options: ["\"Through hardships to the stars.\" (- UNKNOWN)", "Incorrect", "Incorrect"],
                    correct_index: 0
                }
            ];
        } else {
            _dlg.stages = [
                {
                    prompt: "OLIM, STELLAE FULSERUNT CLARAE, RUINAS PER UNIVERSUM RELINQUERE.",
                    options: ["Once upon a time, the stars lit up bright, leaving ruins throughout the universe.", "Once upon a time, I watched the stars light up bright, leaving ruins throughout the universe.", "Once upon a time, brightly did the stars light up, and throughout the universe were ruins left."],
                    correct_index: 0
                },
                {
                    prompt: "EX HOC FULGORE AVIS ORTA EST.",
                    options: ["From the bird a glow arose.", "From this glow a bird arose.", "And the bird arose from this glow."],
                    correct_index: 1
                },
                {
                    prompt: "HARPYIA.",
                    options: ["Bird.", "A harpy.", "The Harpyia."],
                    correct_index: 1
                },
                {
                    prompt: "TUAM HISTORIAM QUAERE.",
                    options: ["Please seek your history.", "Seek your history.", "To seek your history."],
                    correct_index: 1
                },
                {
                    prompt: "\"PER ASPERA AD ASTRA.\" (- IGNOTUS)",
                    options: ["\"Through hardships to the stars.\" (- UNKNOWN)", "\"Through hardships to the stars.\" (- UNFAMILIAR)", "\"To hardships through stars.\" (- UNKNOWN)"],
                    correct_index: 0
                }
            ];
        }

        _dlg.stage_index = 0;
        _dlg.prompt = _dlg.stages[0].prompt;
        _dlg.options = _dlg.stages[0].options;
        _dlg.correct_index = _dlg.stages[0].correct_index;
        _dlg.option_alpha = array_create(array_length(_dlg.options), 1);
        _dlg.caller = id;
    }
}
