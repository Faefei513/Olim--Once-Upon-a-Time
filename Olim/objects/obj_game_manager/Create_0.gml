window_set_size(1600, 750);
display_set_gui_size(1920, 900);
depth = 75;
global.current_realm = E_REALM.SKY;
global.game_complete = false;
global.free_roam = false;
global.realm_unlocked = array_create(E_REALM.COUNT, false);
global.realm_unlocked[E_REALM.SKY] = true;
global.runes_found = [];
global.total_runes = 0;
global.cosmetics_obtained = [];
global.active_cosmetic = "default";

// Load sky backgrounds, floor tile, and portal
global.sky_bg = sprite_add("sky_bg.png", 1, false, false, 0, 0);
global.hub_bg = sprite_add("hub_bg.png", 1, false, false, 0, 0);
global.floor_tile = sprite_add("floor_tile.png", 1, false, false, 0, 0);
global.portal_spr = sprite_add("portal.png", 29, false, false, 225, 225);
global.hub_rune_spr = sprite_add("hub_rune.png", 12, false, false, 225, 225);
global.floor_scale = 1.5;
global.portal_cooldown = false;
global.player_spawn_x = -1;
global.hub_rune_solved = false;
global.move_hint_timer = 10 * game_get_speed(gamespeed_fps);
global.interact_hint_timer = 0;
global.flight_hint_timer = 10 * game_get_speed(gamespeed_fps);
