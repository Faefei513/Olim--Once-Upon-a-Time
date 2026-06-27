if (rune_solved && !animating) {
    animating = true;
    image_speed = 6 / game_get_speed(gamespeed_fps);
}

if (animating) {
    if (image_index >= sprite_get_number(sprite_index) - 1) {
        global.hub_rune_solved = true;
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
        _dlg.stages = [
            {
                prompt: "OLIM, STELLAE FULSERUNT TAM CLARE, UT RUINAS PER UNIVERSUM RELINQUERENT.",
                options: ["Once upon a time, the stars lit up so bright, leaving ruins throughout the universe.", "Incorrect", "Incorrect"],
                correct_index: 0
            },
            {
                prompt: "EX HOC FULGORE AVIS ORTA.",
                options: ["Incorrect", "Incorrect", "Out of this glow came a bird."],
                correct_index: 2
            },
            {
                prompt: "HARPYIA.",
                options: ["Incorrect", "A harpy.", "Incorrect"],
                correct_index: 1
            },
            {
                prompt: "TUAM HISTORIAM QUAERE.",
                options: ["Incorrect", "Incorrect", "Find your history."],
                correct_index: 2
            },
            {
                prompt: "\"PER ASPERA AD ASTRA.\" (- IGNOTUS)",
                options: ["\"Through hardships to the stars.\" (- UNKNOWN)", "Incorrect", "Incorrect"],
                correct_index: 0
            }
        ];
        _dlg.stage_index = 0;
        _dlg.prompt = _dlg.stages[0].prompt;
        _dlg.options = _dlg.stages[0].options;
        _dlg.correct_index = _dlg.stages[0].correct_index;
        _dlg.option_alpha = array_create(array_length(_dlg.options), 1);
        _dlg.caller = id;
    }
}
