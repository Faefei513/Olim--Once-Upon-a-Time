global.current_realm = E_REALM.SKY;
global.game_complete = false;
global.free_roam = false;
global.realm_unlocked = array_create(E_REALM.COUNT, false);
global.realm_unlocked[E_REALM.SKY] = true;
global.runes_found = [];
global.total_runes = 0;
global.cosmetics_obtained = [];
global.active_cosmetic = "default";

// Load sky background
global.sky_bg = sprite_add("sky_bg.png", 1, false, false, 0, 0);
