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
global.forest_bg = sprite_add("forest_bg.png", 1, false, false, 0, 0);
global.forest_fg = sprite_add("forest_fg.png", 1, false, false, 0, 0);
global.forest_floor = sprite_add("forest_floor.png", 1, false, false, 0, 0);
global.forest_rune_spr = sprite_add("forest_rune.png", 12, false, false, 225, 225);
global.isles_bg = sprite_add("isles_bg.png", 1, false, false, 0, 0);
global.isles_bg2 = sprite_add("isles_bg2.png", 1, false, false, 0, 0);
global.isles_fg = sprite_add("isles_fg.png", 1, false, false, 0, 0);
global.isles_fg2 = sprite_add("isles_fg2.png", 1, false, false, 0, 0);
global.isles_knife_spr = sprite_add("isles_knife.png", 1, false, false, 225, 225);
global.isles_cutscene_spr = [
    sprite_add("isles_cutscene_0.png", 8, false, false, 960, 450),
    sprite_add("isles_cutscene_1.png", 8, false, false, 960, 450),
    sprite_add("isles_cutscene_2.png", 6, false, false, 960, 450)
];
global.manta_spr = {
    departure_b: sprite_add("manta_departure_b.png", 1, false, false, 0, 0),
    departure_f: sprite_add("manta_departure_f.png", 1, false, false, 0, 0),
    runway_b: sprite_add("manta_runway_b.png", 1, false, false, 0, 0),
    runway_f: sprite_add("manta_runway_f.png", 1, false, false, 0, 0),
    liftoff1_b: sprite_add("manta_liftoff1_b.png", 1, false, false, 0, 0),
    liftoff1_f: sprite_add("manta_liftoff1_f.png", 1, false, false, 0, 0),
    liftoff2_b: sprite_add("manta_liftoff2_b.png", 1, false, false, 0, 0),
    liftoff2_f: sprite_add("manta_liftoff2_f.png", 1, false, false, 0, 0),
    descent1_b: sprite_add("manta_descent1_b.png", 1, false, false, 0, 0),
    descent1_f: sprite_add("manta_descent1_f.png", 1, false, false, 0, 0),
    descent2_b: sprite_add("manta_descent2_b.png", 1, false, false, 0, 0),
    descent2_f: sprite_add("manta_descent2_f.png", 1, false, false, 0, 0),
    taxi1_b: sprite_add("manta_taxi1_b.png", 1, false, false, 0, 0),
    taxi1_f: sprite_add("manta_taxi1_f.png", 1, false, false, 0, 0),
    taxi2_b: sprite_add("manta_taxi2_b.png", 1, false, false, 0, 0),
    taxi2_f: sprite_add("manta_taxi2_f.png", 1, false, false, 0, 0),
    landing_b: sprite_add("manta_landing_b.png", 1, false, false, 0, 0),
    landing_f: sprite_add("manta_landing_f.png", 1, false, false, 0, 0)
};
global.isles_segments = [
    [0, 2000, 734],
    [2520, 2916, 330],
    [3700, 4000, 580],
    [4130, 4300, 385],
    [4700, 5450, 315],
    [6336, 10080, 739],
    [10080, 11808, 698],
    [11808, 15120, 658]
];
global.isles2_segments = [
    [6500, 9800, 694],
    [9800, 13250, 682],
    [13250, 16700, 670],
    [16700, 20160, 655]
];
global.forest_gaps = [
    [4464, 5112],
    [15120, 17496],
    [18216, 19800]
];
global.floor_scale = 1.5;
global.title_bg = sprite_add("title_bg.png", 1, false, false, 0, 0);
global.portal_cooldown = false;
global.player_spawn_x = -1;
global.player_spawn_y = -1;
global.hub_rune_solved = false;
global.forest_rune_solved = false;
global.save_slot = -1;
global.test_run = false;
global.creator_mode = false;
global.move_hint_timer = 10 * game_get_speed(gamespeed_fps);
global.interact_hint_timer = 0;
global.interact_hint_age = 0;
global.flight_hint_timer = 10 * game_get_speed(gamespeed_fps);
global.esc_hint_timer = 10 * game_get_speed(gamespeed_fps);
global.menu_open = false;
global.menu_hovered = -1;
global.menu_teleport_expanded = false;
global.manta_arriving = false;
global.isles_cutscene_seen = false;
global.ending_state = 0;
global.ending_alpha = 0;
global.cutscene_state = 0;
global.cutscene_alpha = 0;
global.cutscene_frame = 0;
global.cutscene_timer = 0;

global.grammar = {};
global.grammar[$ "OLIM"] = { info: "Adverb", eng: "Once upon a time" };
global.grammar[$ "STELLAE"] = { info: "Noun, Nominative, Plural", eng: "Stars" };
global.grammar[$ "FULSERUNT"] = { info: "Verb, 3rd Person, Plural, Perfect Active Indicative", eng: "Lit up / Flashed" };
global.grammar[$ "CLARAE"] = { info: "Adjective, Nominative, Plural", eng: "Bright" };
global.grammar[$ "RUINAS"] = { info: "Noun, Accusative, Plural", eng: "Ruins" };
global.grammar[$ "PER"] = { info: "Preposition, Accusative", eng: "Through / Throughout" };
global.grammar[$ "UNIVERSUM"] = { info: "Noun, Accusative, Singular", eng: "Universe" };
global.grammar[$ "RELINQUERE"] = { info: "Verb, Present Active Infinitive", eng: "To leave / Leaving" };
global.grammar[$ "EX"] = { info: "Preposition, Ablative", eng: "From" };
global.grammar[$ "HOC"] = { info: "Pronoun, Ablative, Singular", eng: "This" };
global.grammar[$ "FULGORE"] = { info: "Noun, Ablative, Singular", eng: "Glow" };
global.grammar[$ "AVIS"] = { info: "Noun, Nominative, Singular", eng: "Bird" };
global.grammar[$ "ORTA"] = { display: "ORTA EST", info: "Verb, 3rd Person, Singular, Perfect Active Indicative", eng: "Arose" };
global.grammar[$ "EST"] = { display: "ORTA EST", info: "Verb, 3rd Person, Singular, Perfect Active Indicative", eng: "Arose" };
global.grammar[$ "HARPYIA"] = { info: "Noun, Nominative, Singular", eng: "Harpy" };
global.grammar[$ "TUAM"] = { info: "Adjective, Accusative, Singular", eng: "Your" };
global.grammar[$ "HISTORIAM"] = { info: "Noun, Accusative, Singular", eng: "History" };
global.grammar[$ "QUAERE"] = { info: "Verb, Singular, Imperative", eng: "Seek" };
global.grammar[$ "ASPERA"] = { info: "Noun, Nominative, Plural", eng: "Hardships" };
global.grammar[$ "AD"] = { info: "Preposition, Accusative", eng: "To" };
global.grammar[$ "ASTRA"] = { info: "Noun, Accusative, Plural", eng: "Stars" };
global.grammar[$ "IGNOTUS"] = { info: "Adjective, Nominative, Singular", eng: "Unknown" };
global.grammar[$ "HODIE"] = { info: "Adverb", eng: "Today" };
global.grammar[$ "NOS"] = { info: "Pronoun, Nominative, Plural", eng: "We" };
global.grammar[$ "NOVAS"] = { info: "Adjective, Accusative, Plural", eng: "New" };
global.grammar[$ "LUCERNAS"] = { info: "Noun, Accusative, Plural", eng: "Lanterns" };
global.grammar[$ "SUSPENDERE"] = { info: "Verb, Present Active Infinitive", eng: "Hanging" };
global.grammar[$ "FINIVIMUS"] = { info: "Verb, 1st Person, Plural, Perfect Active Indicative", eng: "Finished" };
global.grammar[$ "ET"] = { info: "Conjunction", eng: "And" };
global.grammar[$ "HORTULANI"] = { info: "Noun, Nominative, Plural", eng: "Gardeners" };
global.grammar[$ "VITES"] = { info: "Noun, Accusative, Plural", eng: "Vines" };
global.grammar[$ "AMPUTAVERUNT"] = { info: "Verb, 3rd Person, Plural, Perfect Active Indicative", eng: "Pruned" };
global.grammar[$ "MOX"] = { info: "Adverb", eng: "Soon" };
global.grammar[$ "TEMPUS"] = { info: "Noun, Nominative, Singular", eng: "Time" };
global.grammar[$ "ERIT"] = { info: "Verb, 3rd Person, Singular, Future Active Indicative", eng: "Will be" };
global.grammar[$ "CELEBRATIONUM"] = { info: "Noun, Genitive, Plural", eng: "Celebrations" };
global.grammar[$ "AESTATIS"] = { info: "Noun, Genitive, Singular", eng: "Summer" };
global.grammar[$ "OMNES"] = { info: "Noun, Nominative, Plural", eng: "Everyone" };
global.grammar[$ "NUNC"] = { info: "Adverb", eng: "Now" };
global.grammar[$ "LAETIORES"] = { info: "Adjective, Nominative, Plural, Comparative", eng: "Happier" };
global.grammar[$ "VIDENTUR"] = { info: "Verb, 3rd Person, Plural, Present Passive Indicative", eng: "Seems" };
global.grammar[$ "CACUMINA"] = { info: "Noun, Nominative, Plural", eng: "Tops" };
global.grammar[$ "ARBORUM"] = { info: "Noun, Genitive, Plural", eng: "Trees" };
global.grammar[$ "CLARIS"] = { info: "Adjective, Ablative, Plural", eng: "Bright" };
global.grammar[$ "LUMINIBUS"] = { info: "Noun, Ablative, Plural", eng: "Lights" };
global.grammar[$ "FULGENT"] = { info: "Verb, 3rd Person, Plural, Present Active Indicative", eng: "Glow" };
global.grammar[$ "SANE"] = { info: "Adverb", eng: "Of course" };
global.grammar[$ "ADHUC"] = { info: "Adverb", eng: "Still" };
global.grammar[$ "SOLLICITI"] = { info: "Adjective, Nominative, Plural", eng: "Concerned" };
global.grammar[$ "SUNT"] = { info: "Verb, 3rd Person, Plural, Present Active Indicative", eng: "Is" };
global.grammar[$ "PROPTER"] = { info: "Preposition, Accusative", eng: "Because of" };
global.grammar[$ "ILLUD"] = { info: "Pronoun, Accusative", eng: "That" };
global.grammar[$ "NUNTIUM"] = { info: "Noun, Accusative, Singular", eng: "Alert" };
global.grammar[$ "ANTE"] = { info: "Adverb", eng: "Before" };
global.grammar[$ "PAUCOS"] = { info: "Adjective, Accusative, Plural", eng: "Few" };
global.grammar[$ "DIES"] = { info: "Noun, Accusative, Plural", eng: "Days" };
global.grammar[$ "ACCEPIMUS"] = { info: "Verb, 1st Person, Plural, Perfect Active Indicative", eng: "Received" };
global.grammar[$ "AUTEM"] = { info: "Conjunction", eng: "But" };
global.grammar[$ "CONCILIUM"] = { info: "Noun, Nominative, Singular", eng: "Council" };
global.grammar[$ "DICIT"] = { info: "Verb, 3rd Person, Singular, Present Active Indicative", eng: "Says" };
global.grammar[$ "SE"] = { info: "Pronoun, Accusative, Singular", eng: "They / Themselves" };
global.grammar[$ "ID"] = { info: "Pronoun, Nominative, Plural", eng: "It" };
global.grammar[$ "CURARE"] = { info: "Verb, Present Active Infinitive", eng: "Figuring" };
global.grammar[$ "FORTASSE"] = { info: "Adverb", eng: "Perhaps" };
global.grammar[$ "ANNO"] = { info: "Noun, Ablative, Singular", eng: "Year" };
global.grammar[$ "FAMILIAM"] = { info: "Noun, Accusative, Singular", eng: "Family" };
global.grammar[$ "REDIRE"] = { info: "Verb, Present Active Infinitive", eng: "To return" };
global.grammar[$ "POTERO"] = { info: "Verb, 1st Person, Singular, Future Active Indicative", eng: "Will be able" };
global.grammar[$ "UT"] = { info: "Conjunction", eng: "To" };
global.grammar[$ "VIDEAM"] = { info: "Verb, 1st Person, Singular, Present Active Subjunctive", eng: "Maybe see" };
global.grammar[$ "CERTUS"] = { info: "Adjective, Nominative, Singular", eng: "Certain" };
global.grammar[$ "SUM"] = { info: "Verb, 1st Person, Singular, Present Active Indicative", eng: "Am" };
global.grammar[$ "SIC"] = { info: "Adverb", eng: "Thus" };
global.grammar[$ "CADENT"] = { info: "Verb, 3rd Person, Plural, Future Active Indicative", eng: "Will fall" };
