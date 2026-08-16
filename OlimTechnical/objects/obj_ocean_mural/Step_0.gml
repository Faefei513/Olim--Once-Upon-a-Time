var _player = instance_find(obj_player, 0);
if (_player != noone && !instance_exists(obj_dialogue)) {
    if (point_distance(x, y, _player.x, _player.y) < 500 && input_check_pressed("interact")) {
        _player.state = player_state_ocean_locked;
        global.ocean_mural_seen = true;
        var _dlg = instance_create_depth(0, 0, -1000, obj_dialogue);
        _dlg.stages = [
            { prompt: "You come across the remains of a mural.", options: [], correct_index: 0 },
            { prompt: "The blue paint is faded, and most of the mural is missing.", options: [], correct_index: 0 },
            { prompt: "You inspect the image, and notice it appears to be some aquatic creature, based on what little you have to gather.", options: [], correct_index: 0 },
            { prompt: "Strange. It looks nothing like the Leviathan or the Goldfish you had just come across.", options: [], correct_index: 0 },
            { prompt: "Probably some animal from before the Doomsday Incident, likely long gone by now.", options: [], correct_index: 0 }
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
