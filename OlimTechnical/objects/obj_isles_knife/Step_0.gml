var _player = instance_find(obj_player, 0);
if (_player != noone && !instance_exists(obj_dialogue)) {
    if (abs(x - _player.x) < 300 && input_check_pressed("interact")) {
        _player.state = player_state_puzzle;
        var _dlg = instance_create_depth(0, 0, -1000, obj_dialogue);

        var _correct = "Thus it will be: all will fall";

        if (global.creator_mode) {
            var _pos = irandom(2);
            var _opts = ["Incorrect", "Incorrect", "Incorrect"];
            _opts[_pos] = _correct;
            _dlg.stages = [
                { prompt: "Beneath the pole you find a bloodied knife, wrapped in the same fabric as the ones tied onto the flagposts. Upon careful inspection, you notice a short sentence engraved into the metal.", options: [], correct_index: 0 },
                { prompt: "SIC ERIT: OMNES CADENT", options: _opts, correct_index: _pos },
                { prompt: "The engravings are rusted and weathered, but the words remain clear. You keep the knife, just in case.", options: [], correct_index: 0 }
            ];
        } else {
            var _wrong1 = "So it shall be: all will fall";
            var _wrong2 = "Thus it may be: all will die";
            var _pos = irandom(2);
            var _opts = ["", "", ""];
            _opts[_pos] = _correct;
            var _slot = 0;
            for (var _j = 0; _j < 3; _j++) {
                if (_j != _pos) {
                    if (_slot == 0) { _opts[_j] = _wrong1; }
                    else { _opts[_j] = _wrong2; }
                    _slot++;
                }
            }
            _dlg.stages = [
                { prompt: "Beneath the pole you find a bloodied knife, wrapped in the same fabric as the ones tied onto the flagposts. Upon careful inspection, you notice a short sentence engraved into the metal.", options: [], correct_index: 0 },
                { prompt: "SIC ERIT: OMNES CADENT", options: _opts, correct_index: _pos },
                { prompt: "The engravings are rusted and weathered, but the words remain clear. You keep the knife, just in case.", options: [], correct_index: 0 }
            ];
        }

        _dlg.stage_index = 0;
        _dlg.prompt = _dlg.stages[0].prompt;
        _dlg.options = _dlg.stages[0].options;
        _dlg.correct_index = _dlg.stages[0].correct_index;
        _dlg.option_alpha = [];
        _dlg.overlay_spr = global.isles_knife_spr;
        _dlg.grammar_overrides[$ "OMNES"] = { info: "Noun, Nominative, Plural", eng: "All" };
        _dlg.caller = noone;
    }
}
