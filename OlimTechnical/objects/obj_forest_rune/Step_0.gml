if (global.forest_rune_solved) { instance_destroy(); return; }

if (rune_solved && !animating) {
    animating = true;
    image_speed = 6 / game_get_speed(gamespeed_fps);
}

if (animating) {
    if (image_index >= sprite_get_number(sprite_index) - 1) {
        global.forest_rune_solved = true;
        save_game();
        instance_destroy();
    }
    return;
}

var _player = instance_find(obj_player, 0);
if (_player != noone && !instance_exists(obj_dialogue)) {
    if (abs(x - _player.x) < 300 && input_check_pressed("interact")) {
        _player.state = player_state_puzzle;
        var _dlg = instance_create_depth(0, 0, -1000, obj_dialogue);
        var _answers = [
            "Today we finished hanging the new lanterns, and the gardeners pruned the vines.",
            "Soon it will be the time of summer celebrations.",
            "Everyone seems happier now, and the tops of trees glow with bright lights.",
            "Of course, everyone's still concerned because of that alert we received a few days ago.",
            "But the council says they are figuring it out.",
            "Perhaps this year I will be able to return to see family, I am certain that--"
        ];
        var _prompts = [
            "HODIE NOS NOVAS LUCERNAS SUSPENDERE FINIVIMUS, ET HORTULANI VITES AMPUTAVERUNT.",
            "MOX TEMPUS ERIT CELEBRATIONUM AESTATIS.",
            "OMNES NUNC LAETIORES VIDENTUR, ET CACUMINA ARBORUM CLARIS LUMINIBUS FULGENT.",
            "SANE OMNES ADHUC SOLLICITI SUNT PROPTER ILLUD NUNTIUM ANTE PAUCOS DIES ACCEPIMUS.",
            "AUTEM CONCILIUM DICIT SE ID CURARE.",
            "FORTASSE HOC ANNO FAMILIAM REDIRE POTERO UT VIDEAM, CERTUS SUM--"
        ];

        var _wrong1, _wrong2;
        if (global.creator_mode) {
            _dlg.stages = [{ prompt: "You find what appears to be a diary entry, scribbled onto the fractured stone, and piece it together.", options: [], correct_index: 0 }];
            for (var _i = 0; _i < array_length(_prompts); _i++) {
                var _pos = irandom(2);
                var _opts = ["Incorrect", "Incorrect", "Incorrect"];
                _opts[_pos] = _answers[_i];
                array_push(_dlg.stages, { prompt: _prompts[_i], options: _opts, correct_index: _pos });
            }
        } else {
            var _wrong_a = [
                "Today we hung the new lanterns, and the gardeners pruned the vines.",
                "Soon it's time for the summer of celebrations.",
                "All do seem happier, and lights glow bright at the treetops.",
                "Quite sanely, everyone's still concerned from that alert of a few days ago.",
                "But it is said the council's figuring it out.",
                "This year I am certain that I will be able to return to see family, perhaps--"
            ];
            var _wrong_b = [
                "Today our new lanterns finished hanging, and the gardeners had pruned the vines.",
                "Soon time will be of celebrations of summer.",
                "Happier all seem now, and glowing the tops of trees with bright lights.",
                "Of course, everyone's still received that alert a few days ago, and are concerned.",
                "But the council are figuring it out.",
                "Perhaps this year I am certain that I will be able to return to see family--"
            ];
            _dlg.stages = [{ prompt: "You find what appears to be a diary entry, scribbled onto the fractured stone, and piece it together.", options: [], correct_index: 0 }];
            for (var _i = 0; _i < array_length(_prompts); _i++) {
                var _pos = irandom(2);
                var _opts = ["", "", ""];
                _opts[_pos] = _answers[_i];
                var _slot = 0;
                for (var _j = 0; _j < 3; _j++) {
                    if (_j != _pos) {
                        if (_slot == 0) { _opts[_j] = _wrong_a[_i]; }
                        else { _opts[_j] = _wrong_b[_i]; }
                        _slot++;
                    }
                }
                array_push(_dlg.stages, { prompt: _prompts[_i], options: _opts, correct_index: _pos });
            }
        }

        array_push(_dlg.stages, { prompt: "The entry abruptly cuts off. You notice burn marks on the stone and faded splatters of dried blood.", options: [], correct_index: 0 });
        _dlg.stage_index = 0;
        _dlg.prompt = _dlg.stages[0].prompt;
        _dlg.options = _dlg.stages[0].options;
        _dlg.correct_index = _dlg.stages[0].correct_index;
        _dlg.option_alpha = [];
        _dlg.caller = id;
    }
}
