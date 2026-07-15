if (trans_state != E_TRANSITION.NONE) {
    draw_set_alpha(trans_alpha);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}
