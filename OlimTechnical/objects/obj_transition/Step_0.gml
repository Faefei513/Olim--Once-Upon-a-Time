switch (trans_state) {
    case E_TRANSITION.FADE_OUT:
        trans_alpha += trans_speed;
        if (trans_alpha >= 1) {
            trans_alpha = 1;
            if (pending_realm >= 0) global.current_realm = pending_realm;
            global.player_spawn_x = pending_x;
            global.player_spawn_y = pending_y;
            room_goto(pending_room);
            trans_state = E_TRANSITION.FADE_IN;
        }
        break;
    case E_TRANSITION.FADE_IN:
        trans_alpha -= trans_speed;
        if (trans_alpha <= 0) { trans_alpha = 0; trans_state = E_TRANSITION.NONE; save_game(); }
        break;
}
