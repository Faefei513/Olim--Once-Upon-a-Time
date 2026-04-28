switch (trans_state) {
    case E_TRANSITION.FADE_OUT:
        trans_alpha += trans_speed;
        if (trans_alpha >= 1) {
            trans_alpha = 1;
            if (pending_realm >= 0) global.current_realm = pending_realm;
            room_goto(pending_room);
            obj_player.x = pending_x; obj_player.y = pending_y;
            trans_state = E_TRANSITION.FADE_IN;
        }
        break;
    case E_TRANSITION.FADE_IN:
        trans_alpha -= trans_speed;
        if (trans_alpha <= 0) { trans_alpha = 0; trans_state = E_TRANSITION.NONE; }
        break;
}
