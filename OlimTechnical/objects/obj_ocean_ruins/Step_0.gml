var _player = instance_find(obj_player, 0);
if (_player != noone && !instance_exists(obj_dialogue)) {
    if (point_distance(x, y, _player.x, _player.y) < 500 && input_check_pressed("interact")) {
        _player.state = player_state_ocean_locked;
        global.ocean_ruins_seen = true;
        var _dlg = instance_create_depth(0, 0, -1000, obj_dialogue);
        _dlg.stages = [
            { prompt: "You come across the cracked remains of a building. The walls block the light out from inside, making it difficult to see inside.", options: [], correct_index: 0 },
            { prompt: "Strange fragments float inside. Some seem like chipped pieces of the stone wall, while others are a bit more difficult to decipher.", options: [], correct_index: 0 },
            { prompt: "You appear to see a table, and what resembles a strange puzzle piece.", options: [], correct_index: 0 },
            { prompt: "The strange puzzle piece looks dangerous. You decide not to touch anything and leave.", options: [], correct_index: 0 }
        ];
        _dlg.stage_index = 0;
        _dlg.prompt = _dlg.stages[0].prompt;
        _dlg.options = _dlg.stages[0].options;
        _dlg.correct_index = _dlg.stages[0].correct_index;
        _dlg.option_alpha = [];
        _dlg.any_correct = true;
        _dlg.show_latin_hints = false;
        _dlg.caller = noone;
    }
}
