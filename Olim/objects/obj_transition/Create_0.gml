trans_state = E_TRANSITION.NONE;
trans_alpha = 0; trans_speed = TRANS_SPEED;
pending_room = -1; pending_x = 0; pending_y = 0; pending_realm = -1;
function transition_start(_room, _px, _py, _realm) {
    trans_state = E_TRANSITION.FADE_OUT;
    trans_alpha = 0;
    pending_room = _room; pending_x = _px; pending_y = _py; pending_realm = _realm;
}
