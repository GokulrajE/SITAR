# Journey Home: 2D art prompts

166 prompts for the story in [JOURNEY_HOME_STORY.md](JOURNEY_HOME_STORY.md). Each one is complete: copy the
whole block into the image generator, attach the pictures named above it, and save the result under
`assets/images/journey/` with the given path.

## Look

Bright, sunlit, semi-realistic painted 2D, close to the three screenshots you liked: deep-blue skies, real
materials, cinematic chase views from behind the hero or vehicle. It is painted 2D, so it runs on the clinic PC
and stays consistent across chapters. All characters, vehicles and places are original: no real aircraft,
no brands, no military markings, and nothing from existing games.

**How the chase view works in 2D:** the game draws the road, sea or clouds in perspective from a ground tile,
scrolls a wide horizon picture sideways when the player steers, and grows roadside sprites as they come closer.
The hero or vehicle sheet sits at the bottom centre. Steering sheets hold 16 *angles*; the game picks the frame from
the angle of the board the player turns on the table.

## Rules for good sheets

These are the same lessons as in [COGNITIVE_2D_ART_PROMPTS.md](COGNITIVE_2D_ART_PROMPTS.md).

1. **One scale for the whole sheet.** Never resize single frames afterwards; move them if needed. Line frames up by the feet.
2. **No glow, haze or light rays in sprites.** They do not survive background removal. The game adds glow, fading and shake itself.
3. **Small motion belongs to the game.** Bobbing, spinning, scaling and fading are done in code at 60 frames a second. Sheets are for changes of pose.
4. **Removal colour.** Each prompt names a fallback colour that does not occur in that picture. Use that one.
5. **Check each sheet:** canvas size exact; 16 cells; same head size in every cell; feet on one line; nothing cut off; transparent corners; no text. Redo it if one fails.
6. **If a sheet drifts,** make frames 1-8 first, then 9-16 with the first half attached, and put them together on the 2048 x 2048 canvas.
7. **Wide horizons:** if the tool cannot make 3840 x 1080, make the middle 1920 x 1080 and outpaint left and right, then check that the two ends join.

## Try these first

Make `style_key.png`, `arun_reference.png`, `kili_reference.png` and `vehicles_reference.png`, then
`c1_road_horizon.png`, `arun_run_back_4x4.png` and `layout_chase.png`. Look at the hero on the Giant Road together.
If the look is right, continue; if not, change the style sentence once and use the new one everywhere.

## Speeds

| Kind | Speed |
|---|---|
| idle, talk, fly, rest | 10 frames a second, loops |
| run, pedal, row | 14-18 frames a second, faster when the player is faster |
| jump, strike, place, cheer, pop, burst | 16 frames a second, once |
| steering sheets | not played; frame chosen by angle |
| effects | 16-20 frames a second, once |
| coin and star spin | 12 frames a second, loops |

## Batch 1: enough for the prologue, the Giant Road and every chapter's main look (113 pictures)

| # | File | What it is | Use in game |
|---|---|---|---|
| 1 | `refs/style_key.png` | style key picture | reference only |
| 2 | `refs/arun_reference.png` | Arun, character reference | reference only |
| 3 | `refs/meera_reference.png` | Meera, character reference | reference only |
| 4 | `refs/rider_reference.png` | the hero in riding gear | reference only |
| 5 | `refs/kili_reference.png` | Kili, character reference | reference only |
| 6 | `refs/lakshmi_reference.png` | Grandma Lakshmi, character reference | reference only |
| 10 | `refs/vehicles_reference.png` | all vehicles | reference only |
| 11 | `heroes/arun_idle_front_4x4.png` | Arun, standing and breathing, facing the viewer | menus, talking, cutscenes |
| 12 | `heroes/arun_run_back_4x4.png` | Arun, running, seen from behind | Giant Road run |
| 13 | `heroes/arun_sidestep_back_4x4.png` | Arun, stepping to the left lane, seen from behind | changing lane (the game mirrors it for right) |
| 14 | `heroes/arun_jump_back_4x4.png` | Arun, jumping over a low obstacle, seen from behind | hop over logs and rocks |
| 15 | `heroes/arun_strike_back_4x4.png` | Arun, striking a glowing crack in a boulder, seen from behind | breaking a boulder (tap) |
| 16 | `heroes/arun_place_back_4x4.png` | Arun, kneeling to place a spark stone or plant a seed | board placed on a target |
| 17 | `heroes/arun_cheer_front_4x4.png` | Arun, victory cheer | level complete |
| 20 | `heroes/arun_rest_campfire_4x4.png` | Arun, sitting by a campfire, breathing slowly | rest scene between levels |
| 25 | `heroes/meera_idle_front_4x4.png` | Meera, standing and breathing, facing the viewer | menus, talking, cutscenes |
| 26 | `heroes/meera_run_back_4x4.png` | Meera, running, seen from behind | Giant Road run |
| 27 | `heroes/meera_sidestep_back_4x4.png` | Meera, stepping to the left lane, seen from behind | changing lane (the game mirrors it for right) |
| 28 | `heroes/meera_jump_back_4x4.png` | Meera, jumping over a low obstacle, seen from behind | hop over logs and rocks |
| 29 | `heroes/meera_strike_back_4x4.png` | Meera, striking a glowing crack in a boulder, seen from behind | breaking a boulder (tap) |
| 30 | `heroes/meera_place_back_4x4.png` | Meera, kneeling to place a spark stone or plant a seed | board placed on a target |
| 31 | `heroes/meera_cheer_front_4x4.png` | Meera, victory cheer | level complete |
| 34 | `heroes/meera_rest_campfire_4x4.png` | Meera, sitting by a campfire, breathing slowly | rest scene between levels |
| 39 | `rides/bike_steer_4x4.png` | bicycle with rider, 16 steering angles | chapter 2, steering by turning a board |
| 40 | `rides/bike_pedal_4x4.png` | bicycle with rider, pedalling | chapter 2, hold to pedal uphill |
| 42 | `rides/jeep_steer_4x4.png` | jeep with driver, 16 steering angles | chapter 3 |
| 43 | `rides/boat_row_4x4.png` | rowing boat, rowing | chapter 4, rowing |
| 45 | `rides/cannon_aim_4x4.png` | foam cannon on the bow, 16 aim angles | chapter 5, aiming by turning a board |
| 46 | `rides/jet_bank_4x4.png` | Kestrel jet, 16 banking angles | chapter 6, steering by turning a board |
| 47 | `rides/parachute_steer_4x4.png` | parachute, 16 steering angles | chapter 7 |
| 49 | `cast/kili_fly_4x4.png` | Kili, flying beside the hero | always on screen during play |
| 50 | `cast/kili_point_4x4.png` | Kili, pointing to the next target | hints |
| 51 | `cast/kili_talk_4x4.png` | Kili, talking | every spoken line |
| 52 | `cast/kili_cheer_4x4.png` | Kili, celebrating | correct action, level complete |
| 53 | `cast/kili_encourage_4x4.png` | Kili, kind encouragement | after a miss |
| 56 | `cast/lakshmi_talk_4x4.png` | Grandma Lakshmi, talking | quest giving, voice messages |
| 58 | `cast/portraits_4x4.png` | dialogue portraits | dialogue box during cutscenes and levels |
| 59 | `cast/rust_shout_4x4.png` | Captain Rust, shouting from his ship | chapter 5 |
| 60 | `cast/rust_defeat_4x4.png` | Captain Rust, defeated | chapter 5 boss end |
| 62 | `cast/boltbeard_climb_4x4.png` | Boltbeard robot climbing aboard | chapter 5, tap where they appear |
| 63 | `cast/boltbeard_pop_4x4.png` | Boltbeard robot falling apart | chapter 5, a hit robot |
| 64 | `cast/grumblet_fly_4x4.png` | Grumblet drone flying | chapter 6 targets |
| 65 | `cast/grumblet_burst_4x4.png` | Grumblet bursting into rain | chapter 6, a hit drone |
| 66 | `cast/megha_states_4x4.png` | Megha, the rain machine boss | chapter 6 boss |
| 68 | `cast/guardians_gift.png` | the five Guardians giving their seeds | seed reward scenes |
| 69 | `cast/villagers_4x4.png` | returning villagers | chapter 8, the village fills up |
| 72 | `world/c1_road_horizon.png` | Chapter 1, the Giant Road, horizon | chase view, scrolls sideways |
| 73 | `world/c1_road_ground.png` | Chapter 1, the Giant Road, ground tile | drawn in perspective by the game |
| 74 | `world/c1_road_props_4x4.png` | Chapter 1, the Giant Road, roadside things | scaled as they come closer |
| 75 | `world/c2_hills_horizon.png` | Chapter 2, Hill Trail, horizon | chase view, scrolls sideways |
| 76 | `world/c2_hills_ground.png` | Chapter 2, Hill Trail, ground tile | drawn in perspective by the game |
| 77 | `world/c2_hills_props_4x4.png` | Chapter 2, Hill Trail, roadside things | scaled as they come closer |
| 78 | `world/c3_desert_horizon.png` | Chapter 3, Desert Highway, horizon | chase view, scrolls sideways |
| 79 | `world/c3_desert_ground.png` | Chapter 3, Desert Highway, ground tile | drawn in perspective by the game |
| 80 | `world/c3_desert_props_4x4.png` | Chapter 3, Desert Highway, roadside things | scaled as they come closer |
| 81 | `world/c4_sea_horizon.png` | Chapter 4, the Harbour sea, horizon | chase view, scrolls sideways |
| 82 | `world/c4_sea_ground.png` | Chapter 4, the Harbour sea, ground tile | drawn in perspective by the game |
| 83 | `world/c4_sea_props_4x4.png` | Chapter 4, the Harbour sea, roadside things | scaled as they come closer |
| 84 | `world/c5_pirates_horizon.png` | Chapter 5, Pirate Attack sea, horizon | chase view, scrolls sideways |
| 85 | `world/c5_pirates_ground.png` | Chapter 5, Pirate Attack sea, ground tile | drawn in perspective by the game |
| 86 | `world/c5_pirates_props_4x4.png` | Chapter 5, Pirate Attack sea, roadside things | scaled as they come closer |
| 87 | `world/c6_sky_horizon.png` | Chapter 6, Storm Skies, horizon | chase view, scrolls sideways |
| 88 | `world/c6_sky_ground.png` | Chapter 6, Storm Skies, ground tile | drawn in perspective by the game |
| 89 | `world/c6_sky_props_4x4.png` | Chapter 6, Storm Skies, roadside things | scaled as they come closer |
| 93 | `world/c1_boulders_4x4.png` | Chapter 1, boulders to break | tap the crack; big ones need a board |
| 94 | `world/c1_gate_lock.png` | Chapter 1, the tortoise gate puzzle | rotate each ring |
| 95 | `world/c1_gate_rings.png` | Chapter 1, three stone rings | rotated by the player's board |
| 96 | `world/c1_chests_4x4.png` | Chapter 1, six chests and keys | key hunt (visual search) |
| 97 | `world/c2_repair_bench.png` | Chapter 2, bicycle repair bench | chain repair puzzle |
| 98 | `world/c2_bike_parts_4x4.png` | Chapter 2, chain and bike parts | sequence puzzle pieces |
| 99 | `world/c3_fuel_station.png` | Chapter 3, Rust's locked fuel station | coin-lock sums |
| 101 | `world/c4_harbour.png` | Chapter 4, the harbour | boat shop, fishing, lighthouse puzzle start |
| 102 | `world/c4_fish_4x4.png` | Chapter 4, fish to catch | fishing |
| 103 | `world/c4_whale_net.png` | Chapter 4, Neela in the nets | pull the net pegs |
| 104 | `world/c5_rust_ship.png` | Chapter 5, the Clanking Crab ship | boss target |
| 105 | `world/c5_deck.png` | Chapter 5, the boat's deck in battle | tap robots on all sides |
| 106 | `world/c6_fortress.png` | Chapter 6, the storm fortress | Megha boss arena |
| 107 | `world/c7_forest_from_above.png` | Chapter 7, the forest from the parachute | landing target |
| 108 | `world/c7_camp.png` | Chapter 7, the forest camp | survival tasks |
| 110 | `world/c7_survival_4x4.png` | Chapter 7, survival items and berries | chop, build, sort |
| 111 | `world/c8_village_square.png` | Chapter 8, the village square, dry | finale start |
| 112 | `world/c8_village_alive.png` | Chapter 8, the village square, alive | finale, all villagers home |
| 113 | `world/c8_farm_fields.png` | Chapter 8, the farm fields from above | farming loop |
| 114 | `world/c8_crops_4x4.png` | Chapter 8, crops in four growth stages | planting to harvest |
| 116 | `world/world_map.png` | the world map | chapter select |
| 117 | `world/rest_campfire.png` | rest scene background | between levels |
| 118 | `fx/fx_dust_4x4.png` | Dust kicked up by running feet or wheels | effects |
| 119 | `fx/fx_splash_4x4.png` | A water splash | effects |
| 120 | `fx/fx_rock_break_4x4.png` | A boulder breaking into stone chunks and gold coins | effects |
| 121 | `fx/fx_spark_pop_4x4.png` | A friendly 'spark stone' pop | effects |
| 126 | `fx/fx_confetti_4x4.png` | A celebration burst of solid paper confetti in marigold | effects |
| 129 | `fx/fx_campfire_4x4.png` | A cosy campfire of solid painted flame shapes in orange | effects |
| 130 | `fx/particles_4x4.png` | particles for every celebration | building blocks of all effects |
| 133 | `rewards/seeds_of_life.png` | the five Seeds of Life | the main reward, world map, finale |
| 134 | `rewards/coin_spin_4x4.png` | spinning gold coin | coins |
| 135 | `rewards/star_spin_4x4.png` | spinning star | stars to collect |
| 136 | `rewards/chest_open_4x4.png` | treasure chest opening | chapter 3 gold, big rewards |
| 137 | `rewards/badges_4x4.png` | badges | badge wall |
| 138 | `rewards/collectibles_4x4.png` | collectibles and pickups | in the world |
| 140 | `rewards/result_stars.png` | result stars | results screen |
| 142 | `ui/target_ring_4x4.png` | touch target ring | where to tap, place or turn |
| 143 | `ui/turn_dial.png` | turn dial | shows how far to turn a board |
| 144 | `ui/hold_meter.png` | hold meter | hold to pedal, fill, shield |
| 146 | `ui/progress_bar.png` | session progress bar | '18 of 30' goals, fuel, distance |
| 147 | `ui/dialogue_box.png` | dialogue box with portrait frame | every spoken line |
| 150 | `ui/layout_chase.png` | layout picture of a chase level | reference only |
| 151 | `story/p0_1.png` | Prologue 1 | cutscene |
| 152 | `story/p0_2.png` | Prologue 2 | cutscene |
| 153 | `story/p0_3.png` | Prologue 3 | cutscene |
| 154 | `story/p0_4.png` | Prologue 4 | cutscene |
| 155 | `story/p0_5.png` | Prologue 5 | cutscene |
| 156 | `story/p0_6.png` | Prologue 6 | cutscene |
| 157 | `story/p1_end.png` | Chapter 1 ending | cutscene |

## Batch 2: more variety and the later story beats (53 pictures)

| # | File | What it is | Use in game |
|---|---|---|---|
| 7 | `refs/helpers_reference.png` | Rao Uncle and Selvi Akka | reference only |
| 8 | `refs/rivals_reference.png` | Captain Rust, Boltbeards, Grumblets, Megha | reference only |
| 9 | `refs/guardians_reference.png` | the five Guardians | reference only |
| 18 | `heroes/arun_dance_front_4x4.png` | Arun, festival dance | finale festival, second celebration |
| 19 | `heroes/arun_wave_front_4x4.png` | Arun, waving hello and goodbye | greeting villagers, end of session |
| 21 | `heroes/arun_trip_back_4x4.png` | Arun, a gentle stumble and recovery | missed obstacle (never hurt) |
| 22 | `heroes/arun_chop_side_4x4.png` | Arun, chopping wood with a small axe | forest camp |
| 23 | `heroes/arun_harvest_side_4x4.png` | Arun, pulling a crop from the ground | farm harvest (board lifted) |
| 24 | `heroes/arun_water_side_4x4.png` | Arun, pouring water from a brass pot | farm watering (hold) |
| 32 | `heroes/meera_dance_front_4x4.png` | Meera, festival dance | finale festival, second celebration |
| 33 | `heroes/meera_wave_front_4x4.png` | Meera, waving hello and goodbye | greeting villagers, end of session |
| 35 | `heroes/meera_trip_back_4x4.png` | Meera, a gentle stumble and recovery | missed obstacle (never hurt) |
| 36 | `heroes/meera_chop_side_4x4.png` | Meera, chopping wood with a small axe | forest camp |
| 37 | `heroes/meera_harvest_side_4x4.png` | Meera, pulling a crop from the ground | farm harvest (board lifted) |
| 38 | `heroes/meera_water_side_4x4.png` | Meera, pouring water from a brass pot | farm watering (hold) |
| 41 | `rides/bike_hop_4x4.png` | bicycle with rider, hopping a log | chapter 2, tap to hop |
| 44 | `rides/boat_turn_4x4.png` | rowing boat, 16 turning angles | chapter 4, one-sided rowing and rudder |
| 48 | `rides/raft_steer_4x4.png` | bamboo raft, 16 steering angles | chapter 7, river |
| 54 | `cast/kili_sing_4x4.png` | Kili, singing Raman's song | chapter 6 boss, finale |
| 55 | `cast/kili_wake_4x4.png` | Kili, waking up for the first time | prologue, once |
| 57 | `cast/lakshmi_bless_4x4.png` | Grandma Lakshmi, blessing the hero | chapter breaks, finale |
| 61 | `cast/rust_sorry_4x4.png` | Captain Rust, saying sorry | chapter 8 |
| 67 | `cast/glowlings_4x4.png` | Glowlings | chapter 7 helpers |
| 70 | `cast/dancers_4x4.png` | festival dancers | finale festival |
| 71 | `cast/animals_4x4.png` | village and forest animals | ambient life |
| 90 | `world/c7_river_horizon.png` | Chapter 7, the forest river, horizon | chase view, scrolls sideways |
| 91 | `world/c7_river_ground.png` | Chapter 7, the forest river, ground tile | drawn in perspective by the game |
| 92 | `world/c7_river_props_4x4.png` | Chapter 7, the forest river, roadside things | scaled as they come closer |
| 100 | `world/c3_stepwell.png` | Chapter 3, the hidden stepwell | Sona's seed, sequence steps |
| 109 | `world/c7_night_path.png` | Chapter 7, the night path | remember the path |
| 115 | `world/c8_houses_4x4.png` | Chapter 8, houses being rebuilt | the village fills up |
| 122 | `fx/fx_gears_4x4.png` | Gears | effects |
| 123 | `fx/fx_rain_burst_4x4.png` | A cloud bursting into rain | effects |
| 124 | `fx/fx_lightning_4x4.png` | A lightning bolt drawn as a solid jagged yellow-white shape with a darker yellow edge (no glow). | effects |
| 125 | `fx/fx_sprout_4x4.png` | A seed planted in soil sprouting into a small plant with two leaves and a flower. | effects |
| 127 | `fx/fx_firework_4x4.png` | A festival firework drawn as solid petals and dots of colour in a flower shape (marigold | effects |
| 128 | `fx/fx_star_trail_4x4.png` | A trail of small solid gold four-pointed stars and dots | effects |
| 131 | `fx/speed_lines.png` | speed lines overlay | boost and jet speed |
| 132 | `fx/sandstorm_tile.png` | sandstorm overlay tile | chapter 3 sandstorm |
| 139 | `rewards/outfits_4x4.png` | outfit and paint shop items | shop |
| 141 | `rewards/hero_statue.png` | Hero of Malarpuram statue | finale |
| 145 | `ui/radar.png` | compass and mini-map | chase levels |
| 148 | `ui/chapter_card_4x4.png` | chapter cards | chapter select |
| 149 | `ui/postcard_frame.png` | postcard frame | rest scene postcards |
| 158 | `story/p2_end.png` | Chapter 2 ending | cutscene |
| 159 | `story/p3_end.png` | Chapter 3 ending | cutscene |
| 160 | `story/p4_end.png` | Chapter 4 ending | cutscene |
| 161 | `story/p5_end.png` | Chapter 5 ending | cutscene |
| 162 | `story/p6_end.png` | Chapter 6 ending | cutscene |
| 163 | `story/p7_end.png` | Chapter 7 ending | cutscene |
| 164 | `story/p8_1.png` | Finale 1 | cutscene |
| 165 | `story/p8_2.png` | Finale 2 | cutscene |
| 166 | `story/p8_3.png` | Finale 3 | cutscene |

---

# Part A. Style key and references

Make these first and attach them to everything after. None is loaded by the game.

## 1. `refs/style_key.png`: style key picture

*Attach the three game screenshots you like as mood references (look and light only).*

```
Full-screen painted game background with no characters. Malarpuram, a South Indian farming village at the foot of green hills, on a bright morning after a great storm. In the centre stand the two heroes side by side, looking at the viewer with warm, ready faces: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals. And Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals. Kili, a small friendly robot sparrow, Raman's hand-made companion. Rounded body of polished copper and cream enamel plates, a soft teal chest panel with a small round speaker grille, big round glass eyes with warm amber irises (painted, no glow), short brass beak, wing feathers of thin copper leaves that fan open, two small tail fins, small brass feet, a tiny brass winding key on the back, one neat repair patch on the left wing. Looks loved and well made, never scary. Kili sits on Meera's shoulder. Beside them Grandma Lakshmi, a warm, wise village elder of about 75. Brown wrinkled skin, silver hair in a low bun with a few white jasmine flowers, round gold-rimmed glasses, a small red bindi, a gentle smile with laugh lines. Maroon cotton sari with a mustard border over a cream blouse, a thin beige shawl, a carved wooden walking stick. Behind them: broken roof tiles, a dry well, brown fields with a few green shoots, a big banyan tree, coconut palms, and the hills with a long ancient stone road climbing up them under a deep-blue sky with large white clouds.
Composition: the four characters fill the middle third, full body, feet at y = 900.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 2. `refs/arun_reference.png`: Arun, character reference

*Attach: `style_key.png`.*

```
Character reference sheet of an original character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Top row: four full-body views on one ground line at the same scale: front, three-quarter facing right, side facing right, back. Bottom row: six head-and-shoulder expressions at the same scale: calm, curious, happy with smiling eyes, surprised and delighted, kind and encouraging, proud.
Friendly and dignified, right for adults and older people as well as children, not babyish.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. Plain white background. Canvas 2048 x 1536.
```

## 3. `refs/meera_reference.png`: Meera, character reference

*Attach: `style_key.png`.*

```
Character reference sheet of an original character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Top row: four full-body views on one ground line at the same scale: front, three-quarter facing right, side facing right, back. Bottom row: six head-and-shoulder expressions at the same scale: calm, curious, happy with smiling eyes, surprised and delighted, kind and encouraging, proud.
Friendly and dignified, right for adults and older people as well as children, not babyish.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. Plain white background. Canvas 2048 x 1536.
```

## 4. `refs/rider_reference.png`: the hero in riding gear

*Attach: `style_key.png`.*

```
Character reference sheet of an original character: The hero as a rider: the hero seen from behind in riding gear that hides who it is, so one sheet serves both heroes: a white-and-orange open-face helmet covering the hair, a rust-and-teal two-tone light jacket, olive trousers, brown boots, a small brown satchel on the back.
Top row: four full-body views on one ground line at the same scale: front, three-quarter facing right, side facing right, back. Bottom row: six head-and-shoulder expressions at the same scale: calm, curious, happy with smiling eyes, surprised and delighted, kind and encouraging, proud. Show the back view largest, because the game sees the rider from behind.
Friendly and dignified, right for adults and older people as well as children, not babyish.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. Plain white background. Canvas 2048 x 1536.
```

## 5. `refs/kili_reference.png`: Kili, character reference

*Attach: `style_key.png`.*

```
Character reference sheet of an original character: Kili, a small friendly robot sparrow, Raman's hand-made companion. Rounded body of polished copper and cream enamel plates, a soft teal chest panel with a small round speaker grille, big round glass eyes with warm amber irises (painted, no glow), short brass beak, wing feathers of thin copper leaves that fan open, two small tail fins, small brass feet, a tiny brass winding key on the back, one neat repair patch on the left wing. Looks loved and well made, never scary.
Top row: four full-body views on one ground line at the same scale: front, three-quarter facing right, side facing right, back. Bottom row: six head-and-shoulder expressions at the same scale: calm, curious, happy with smiling eyes, surprised and delighted, kind and encouraging, proud. Add one small view with the wings fully spread.
Friendly and dignified, right for adults and older people as well as children, not babyish.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. Plain white background. Canvas 2048 x 1536.
```

## 6. `refs/lakshmi_reference.png`: Grandma Lakshmi, character reference

*Attach: `style_key.png`.*

```
Character reference sheet of an original character: Grandma Lakshmi, a warm, wise village elder of about 75. Brown wrinkled skin, silver hair in a low bun with a few white jasmine flowers, round gold-rimmed glasses, a small red bindi, a gentle smile with laugh lines. Maroon cotton sari with a mustard border over a cream blouse, a thin beige shawl, a carved wooden walking stick.
Top row: four full-body views on one ground line at the same scale: front, three-quarter facing right, side facing right, back. Bottom row: six head-and-shoulder expressions at the same scale: calm, curious, happy with smiling eyes, surprised and delighted, kind and encouraging, proud.
Friendly and dignified, right for adults and older people as well as children, not babyish.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. Plain white background. Canvas 2048 x 1536.
```

## 7. `refs/helpers_reference.png`: Rao Uncle and Selvi Akka

*Attach: `style_key.png`.*

```
Character reference sheet of two original supporting characters side by side, each in front, three-quarter and back view at one scale, plus three expressions each (laughing, explaining, proud). Left: Rao Uncle, a jolly desert mechanic of about 55. Deep-brown sun-weathered skin, big curled grey moustache, bright orange turban, oil-stained blue overalls with rolled sleeves, a red cloth tied at the neck, a big spanner in the back pocket, kind crinkled eyes. Right: Selvi Akka, a strong, cheerful coastal boat builder of about 40. Dark-brown skin, hair tied up in a checked cloth, a mustard-yellow cotton sari tucked up practically at the knees over dark leggings, a carpenter's pencil behind one ear, a few wood shavings on her sleeves.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. Plain white background. Canvas 2048 x 1536.
```

## 8. `refs/rivals_reference.png`: Captain Rust, Boltbeards, Grumblets, Megha

*Attach: `style_key.png`.*

```
Reference sheet of the comic rivals, all at a consistent scale on white. Top left: Captain Rust, a comic, theatrical pirate inventor of about 50, never scary. Round belly, a huge orange-red beard braided with small brass gears, a tall battered captain's hat with a cog emblem (no skull), a long patched navy coat with too many brass buttons, a brass mechanical left hand like a little toolbox, one monocle, bushy eyebrows, a very expressive face that is mostly grumpy-funny or surprised. Shown front and three-quarter, plus three expressions (grumpy-funny, shocked, sheepish sorry). Top right: three Boltbeards standing in a row; each is a Boltbeard, one of Captain Rust's clumsy robot pirates: a small barrel-shaped robot of dented green-grey metal, one big round headlamp eye, a beard of curly copper springs, a tiny red-and-white striped bandana, spring arms with clamp hands, two short peg legs. Silly, never scary, never holds a weapon. Bottom left: three Grumblets in different grumpy moods; each is a Grumblet, a small grumpy storm-cloud drone: a round puffy dark-grey cloud body with soft white highlights on top, two big sulky eyes under heavy brows, a small brass propeller on top, two tiny metal fins underneath, a short zigzag brass antenna. Grumpy-cute, never scary. Bottom right, small: Megha, the great rain machine: a huge round engine of brass and glass shaped like a gentle face, with six petal-shaped brass shield plates around it, rain pipes hanging below like roots, small puffs of solid grey cloud around the rim. She was built long ago by the village inventor; she is sad and broken, never evil. Shown once broken (cracked glass, tired eyes) and once healed (clear glass, smiling).
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. Plain white background. Canvas 2048 x 1536.
```

## 9. `refs/guardians_reference.png`: the five Guardians

*Attach: `style_key.png`.*

```
Reference sheet of five original gentle guardian creatures standing in a row on white, each with a calm, wise face and holding or guarding a glowing almond-shaped seed painted as a solid shape: 1 Shila, a giant ancient stone tortoise whose huge mossy domed shell is carved with three concentric stone rings and old carved symbols, small flowers growing in the cracks, gentle sleepy eyes; 2 Sona, a golden desert fox with big ears, amber eyes and a small sun-shaped mark on the forehead; 3 Neela, a great blue whale shown as a head-and-eye portrait with barnacles and a kind eye; 4 Vayu, a great white eagle with silver-tipped wings and calm golden eyes; 5 Minmini, queen of the Glowlings: a taller forest spirits the size of a hand: round soft bodies like dandelion seed heads in pale mint and warm cream, big dark friendly eyes, little leaf-shaped ears, short stubby arms, each holding a tiny lantern with a solid pale-yellow light shape inside (painted solid, no haze). She wears a crown of tiny white flowers and a cloak like soft moth wings.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. Plain white background. Canvas 2560 x 1280.
```

## 10. `refs/vehicles_reference.png`: all vehicles

*Attach: `style_key.png`.*

```
Vehicle reference sheet on white, each vehicle shown in a side view and a back view at sensible relative scale, empty with no riders: 1 an old, sturdy village bicycle the hero restored: black steel frame with green and cream paint, a wicker basket on the front with a tiny perch for Kili, a brown leather saddle, a brass bell, mudguards; 2 Old Ganga, a sturdy open-top vintage-style off-road jeep of no real make: sand-yellow paint with a faded blue stripe, round headlights, a spare tyre and two jerry cans on the back, a roll bar hung with a small marigold garland; 3 Kayal, a small wooden rowing boat: teal hull with an orange stripe, a painted eye on the bow in the traditional South Indian coastal style, two long wooden oars, a folded mast, plus a small brass foam-ball cannon on the bow in a second side view; 4 Kestrel, a small friendly sky jet rebuilt from an old seaplane: rounded nose, swept wings, white and sunset-orange paint with teal trim, one bubble canopy, twin small rear engines, a tiny robot-sparrow picture painted on the tail, no military markings, no guns; 5 a round patchwork parachute in orange, cream and teal panels; 6 a raft of bamboo poles lashed with rope, a small leaf-thatch shade and one long steering oar.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. Plain white background. Canvas 2560 x 1440.
```

# Part B. Hero animation sheets

Each of these is made twice, once for Arun and once for Meera; the two prompts differ only in the character. Attach that hero's reference.

## 11. `heroes/arun_idle_front_4x4.png`: Arun, standing and breathing, facing the viewer

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, facing the viewer, very slightly turned, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-4 a slow breath in, shoulders rise slightly; 5-8 a slow breath out; 9-10 the eyes blink softly; 11-14 the weight shifts to the other foot and the head tilts a little; 15-16 back to frame 1.
Expression: calm, friendly, ready. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 12. `heroes/arun_run_back_4x4.png`: Arun, running, seen from behind

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, seen from directly behind and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: a smooth, light jogging run cycle seen from behind: 1-8 one full stride (left foot strikes at 1, right foot at 5), 9-16 the second stride, arms swinging naturally, satchel bouncing slightly, braid or shirt hem following the motion.
Expression: not visible; the head faces away from the viewer. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 13. `heroes/arun_sidestep_back_4x4.png`: Arun, stepping to the left lane, seen from behind

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, seen from directly behind and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-3 still running, the head turns to look left; 4-9 a quick, controlled side-step to the left, body leaning slightly into it; 10-13 lands and settles; 14-16 back into the run pose of frame 1.
Expression: not visible. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 14. `heroes/arun_jump_back_4x4.png`: Arun, jumping over a low obstacle, seen from behind

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, seen from directly behind and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-3 crouch while running; 4-8 push off and rise, knees tucked, arms up for balance, the body rises about 120 px in the cell; 9-11 top of the jump; 12-14 come down; 15-16 land softly and run on. The body keeps the same size; only its height in the cell changes.
Expression: not visible. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 15. `heroes/arun_strike_back_4x4.png`: Arun, striking a glowing crack in a boulder, seen from behind

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, seen from directly behind and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-3 run and slow down; 4-6 the right arm draws back, open palm; 7-9 a strong forward palm strike up and to the front, the body leans in; 10-12 holds the pose; 13-16 relaxes back to a ready stance. No impact effect; the game adds it.
Expression: not visible. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 16. `heroes/arun_place_back_4x4.png`: Arun, kneeling to place a spark stone or plant a seed

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, seen from behind at a three-quarter angle and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-4 steps forward and kneels on one knee; 5-8 both hands lower a small round object (warm-orange solid spark stone) to the ground; 9-11 hands open and lift away; 12-14 a satisfied nod; 15-16 stands back up to frame 1.
Expression: careful and focused. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 17. `heroes/arun_cheer_front_4x4.png`: Arun, victory cheer

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, facing the viewer, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-2 a small crouch; 3-6 jumps up with both arms raised, fists open, about 60 px off the ground line; 7-9 top of the jump, eyes closed with a big smile; 10-12 lands softly; 13-16 a happy fist pump with the right arm, back to standing.
Expression: joyful and proud. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 18. `heroes/arun_dance_front_4x4.png`: Arun, festival dance

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, facing the viewer, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: a cheerful South Indian folk-style festival dance in place: 1-4 step left with hands clapping at chest height; 5-8 turn a quarter and raise the right arm with a twirl of the wrist; 9-12 step right and clap; 13-16 turn back, both arms open, back to frame 1.
Expression: joyful, laughing. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 19. `heroes/arun_wave_front_4x4.png`: Arun, waving hello and goodbye

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, facing the viewer, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 raises the right hand; 4-12 three friendly side-to-side waves at shoulder height; 13-16 lowers the hand, back to frame 1.
Expression: warm smile. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 20. `heroes/arun_rest_campfire_4x4.png`: Arun, sitting by a campfire, breathing slowly

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body sitting cross-legged on the ground, side view facing right, centred at x = 256, sitting about 300 px tall, bottom on a line 60 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-6 a slow deep breath in, shoulders and chest rise gently, eyes close; 7-12 a slow breath out, shoulders relax; 13-16 eyes open softly with a small smile, back to frame 1. Very slow, peaceful motion.
Expression: peaceful and rested. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 21. `heroes/arun_trip_back_4x4.png`: Arun, a gentle stumble and recovery

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, seen from directly behind and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-3 running; 4-7 the foot catches lightly, arms windmill comically for balance; 8-11 catches the balance, one hand on the knee, shakes the head with a smile; 12-16 runs on to frame 1.
Expression: a little surprised, then laughing. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 22. `heroes/arun_chop_side_4x4.png`: Arun, chopping wood with a small axe

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, three-quarter view facing right, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-4 lifts a small wooden-handled hatchet over the right shoulder; 5-7 brings it down onto a log just in front (the log is NOT drawn); 8-10 a small bounce; 11-16 lifts again and returns to frame 1.
Expression: focused, determined. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 23. `heroes/arun_harvest_side_4x4.png`: Arun, pulling a crop from the ground

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, three-quarter view facing right, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-4 bends and grips a leafy plant at the base with both hands (plant drawn: a big leafy turnip with a purple-white root); 5-9 pulls steadily, leaning back; 10-12 the root comes free and is lifted to chest height; 13-16 a proud look at it, then lowers it, back to frame 1 with the plant hidden behind the leg.
Expression: happy effort, proud. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 24. `heroes/arun_water_side_4x4.png`: Arun, pouring water from a brass pot

*Attach: `arun_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Arun, a cheerful young Indian man of about 25 from a farming village. Warm brown skin, short wavy black hair, friendly dark-brown eyes, light stubble, lean and fit. Wears a rust-orange short kurta-style shirt with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Arun is full body, three-quarter view facing right, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 lifts a round brass water pot with both hands; 4-6 tilts it forward; 7-12 holds the tilt while five to eight solid painted water drops fall in an even rhythm; 13-16 tips it back and lowers it, back to frame 1.
Expression: caring and content. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 25. `heroes/meera_idle_front_4x4.png`: Meera, standing and breathing, facing the viewer

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, facing the viewer, very slightly turned, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-4 a slow breath in, shoulders rise slightly; 5-8 a slow breath out; 9-10 the eyes blink softly; 11-14 the weight shifts to the other foot and the head tilts a little; 15-16 back to frame 1.
Expression: calm, friendly, ready. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 26. `heroes/meera_run_back_4x4.png`: Meera, running, seen from behind

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, seen from directly behind and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: a smooth, light jogging run cycle seen from behind: 1-8 one full stride (left foot strikes at 1, right foot at 5), 9-16 the second stride, arms swinging naturally, satchel bouncing slightly, braid or shirt hem following the motion.
Expression: not visible; the head faces away from the viewer. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 27. `heroes/meera_sidestep_back_4x4.png`: Meera, stepping to the left lane, seen from behind

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, seen from directly behind and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-3 still running, the head turns to look left; 4-9 a quick, controlled side-step to the left, body leaning slightly into it; 10-13 lands and settles; 14-16 back into the run pose of frame 1.
Expression: not visible. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 28. `heroes/meera_jump_back_4x4.png`: Meera, jumping over a low obstacle, seen from behind

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, seen from directly behind and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-3 crouch while running; 4-8 push off and rise, knees tucked, arms up for balance, the body rises about 120 px in the cell; 9-11 top of the jump; 12-14 come down; 15-16 land softly and run on. The body keeps the same size; only its height in the cell changes.
Expression: not visible. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 29. `heroes/meera_strike_back_4x4.png`: Meera, striking a glowing crack in a boulder, seen from behind

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, seen from directly behind and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-3 run and slow down; 4-6 the right arm draws back, open palm; 7-9 a strong forward palm strike up and to the front, the body leans in; 10-12 holds the pose; 13-16 relaxes back to a ready stance. No impact effect; the game adds it.
Expression: not visible. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 30. `heroes/meera_place_back_4x4.png`: Meera, kneeling to place a spark stone or plant a seed

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, seen from behind at a three-quarter angle and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-4 steps forward and kneels on one knee; 5-8 both hands lower a small round object (warm-orange solid spark stone) to the ground; 9-11 hands open and lift away; 12-14 a satisfied nod; 15-16 stands back up to frame 1.
Expression: careful and focused. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 31. `heroes/meera_cheer_front_4x4.png`: Meera, victory cheer

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, facing the viewer, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-2 a small crouch; 3-6 jumps up with both arms raised, fists open, about 60 px off the ground line; 7-9 top of the jump, eyes closed with a big smile; 10-12 lands softly; 13-16 a happy fist pump with the right arm, back to standing.
Expression: joyful and proud. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 32. `heroes/meera_dance_front_4x4.png`: Meera, festival dance

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, facing the viewer, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: a cheerful South Indian folk-style festival dance in place: 1-4 step left with hands clapping at chest height; 5-8 turn a quarter and raise the right arm with a twirl of the wrist; 9-12 step right and clap; 13-16 turn back, both arms open, back to frame 1.
Expression: joyful, laughing. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 33. `heroes/meera_wave_front_4x4.png`: Meera, waving hello and goodbye

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, facing the viewer, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 raises the right hand; 4-12 three friendly side-to-side waves at shoulder height; 13-16 lowers the hand, back to frame 1.
Expression: warm smile. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 34. `heroes/meera_rest_campfire_4x4.png`: Meera, sitting by a campfire, breathing slowly

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body sitting cross-legged on the ground, side view facing right, centred at x = 256, sitting about 300 px tall, bottom on a line 60 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-6 a slow deep breath in, shoulders and chest rise gently, eyes close; 7-12 a slow breath out, shoulders relax; 13-16 eyes open softly with a small smile, back to frame 1. Very slow, peaceful motion.
Expression: peaceful and rested. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 35. `heroes/meera_trip_back_4x4.png`: Meera, a gentle stumble and recovery

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, seen from directly behind and a little above (the chase camera), centred at x = 256 in every cell, about 380 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-3 running; 4-7 the foot catches lightly, arms windmill comically for balance; 8-11 catches the balance, one hand on the knee, shakes the head with a smile; 12-16 runs on to frame 1.
Expression: a little surprised, then laughing. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 36. `heroes/meera_chop_side_4x4.png`: Meera, chopping wood with a small axe

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, three-quarter view facing right, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-4 lifts a small wooden-handled hatchet over the right shoulder; 5-7 brings it down onto a log just in front (the log is NOT drawn); 8-10 a small bounce; 11-16 lifts again and returns to frame 1.
Expression: focused, determined. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 37. `heroes/meera_harvest_side_4x4.png`: Meera, pulling a crop from the ground

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, three-quarter view facing right, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-4 bends and grips a leafy plant at the base with both hands (plant drawn: a big leafy turnip with a purple-white root); 5-9 pulls steadily, leaning back; 10-12 the root comes free and is lifted to chest height; 13-16 a proud look at it, then lowers it, back to frame 1 with the plant hidden behind the leg.
Expression: happy effort, proud. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 38. `heroes/meera_water_side_4x4.png`: Meera, pouring water from a brass pot

*Attach: `meera_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Meera, a confident young Indian woman of about 25 from a farming village. Warm brown skin, long black hair in one thick braid tied with a small yellow ribbon, bright dark-brown eyes, small gold stud earrings. Wears a teal short kurta-style tunic with rolled sleeves over a cream undershirt, a dark-green cloth band on the right wrist, a small brown leather satchel across the body, olive cargo trousers rolled at the ankle, sturdy brown strapped trail sandals.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Meera is full body, three-quarter view facing right, centred at x = 256 in every cell, standing about 400 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 lifts a round brass water pot with both hands; 4-6 tilts it forward; 7-12 holds the tilt while five to eight solid painted water drops fall in an even rhythm; 13-16 tips it back and lowers it, back to frame 1.
Expression: caring and content. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

# Part C. Riding sheets (both heroes)

The rider wears a helmet and is seen from behind, so one sheet serves Arun and Meera. Steering sheets are picked by angle, not played as a loop.

## 39. `rides/bike_steer_4x4.png`: bicycle with rider, 16 steering angles

*Attach: `vehicles_reference.png`, `rider_reference.png`, `kili_reference.png`.*

```
2D steering sprite sheet. Use the attached vehicle reference exactly.
The subject: the hero riding an old, sturdy village bicycle the hero restored: black steel frame with green and cream paint, a wicker basket on the front with a tiny perch for Kili, a brown leather saddle, a brass bell, mudguards. The rider is the hero seen from behind in riding gear that hides who it is, so one sheet serves both heroes: a white-and-orange open-face helmet covering the hair, a rust-and-teal two-tone light jacket, olive trousers, brown boots, a small brown satchel on the back. Kili sits in the front basket.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The bicycle is seen from directly behind and a little above (the chase camera). It is centred at x = 256, about 420 px tall from the bottom of the wheels or hull to the top, bottom on a line 40 px above the bottom of the cell.
The 16 frames are 16 steering angles, NOT a time loop: frame 1 = full turn to the left, frame 8 = dead straight ahead, frame 15 = full turn to the right, frame 16 = straight ahead with a small bump (used on rough ground). Each frame turns the same small step further than the one before. The game picks a frame from the angle of the board the player turns. At full turn the bicycle and rider lean 25 degrees into the turn and the front wheel turns. The rider keeps pedalling the same pose.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no road, no water surface, no shadow, no speed lines, no dust.
```

## 40. `rides/bike_pedal_4x4.png`: bicycle with rider, pedalling

*Attach: `vehicles_reference.png`, `rider_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same shape, proportions, colours and painting style.
The subject: the hero riding an old, sturdy village bicycle the hero restored: black steel frame with green and cream paint, a wicker basket on the front with a tiny perch for Kili, a brown leather saddle, a brass bell, mudguards. The rider is the hero seen from behind in riding gear that hides who it is, so one sheet serves both heroes: a white-and-orange open-face helmet covering the hair, a rust-and-teal two-tone light jacket, olive trousers, brown boots, a small brown satchel on the back. Kili sits in the front basket.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The bicycle is seen from directly behind and a little above (the chase camera). It is centred at x = 256, about 420 px tall from the bottom of the wheels or hull to the top, bottom on a line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: a full pedalling cycle uphill: 1-8 the right pedal goes down, the rider stands slightly on the pedals and leans forward; 9-16 the left pedal goes down; the body rocks gently side to side.
Expression: not visible.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 41. `rides/bike_hop_4x4.png`: bicycle with rider, hopping a log

*Attach: `vehicles_reference.png`, `rider_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same shape, proportions, colours and painting style.
The subject: the hero riding an old, sturdy village bicycle the hero restored: black steel frame with green and cream paint, a wicker basket on the front with a tiny perch for Kili, a brown leather saddle, a brass bell, mudguards. The rider is the hero seen from behind in riding gear that hides who it is, so one sheet serves both heroes: a white-and-orange open-face helmet covering the hair, a rust-and-teal two-tone light jacket, olive trousers, brown boots, a small brown satchel on the back.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The bicycle is seen from directly behind and a little above (the chase camera). It is centred at x = 256, about 420 px tall from the bottom of the wheels or hull to the top, bottom on a line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-3 the rider crouches; 4-8 bicycle and rider lift about 110 px, front wheel first; 9-11 top of the hop; 12-14 come down, back wheel first; 15-16 land with a small bounce.
Expression: not visible.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 42. `rides/jeep_steer_4x4.png`: jeep with driver, 16 steering angles

*Attach: `vehicles_reference.png`, `rider_reference.png`, `helpers_reference.png`.*

```
2D steering sprite sheet. Use the attached vehicle reference exactly.
The subject: Old Ganga, a sturdy open-top vintage-style off-road jeep of no real make: sand-yellow paint with a faded blue stripe, round headlights, a spare tyre and two jerry cans on the back, a roll bar hung with a small marigold garland, driven by the hero. The rider is the hero seen from behind in riding gear that hides who it is, so one sheet serves both heroes: a white-and-orange open-face helmet covering the hair, a rust-and-teal two-tone light jacket, olive trousers, brown boots, a small brown satchel on the back. Rao Uncle sits in the passenger seat, orange turban visible from behind. Kili perches on the roll bar.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The jeep is seen from directly behind and a little above (the chase camera). It is centred at x = 256, about 360 px tall from the bottom of the wheels or hull to the top, bottom on a line 40 px above the bottom of the cell.
The 16 frames are 16 steering angles, NOT a time loop: frame 1 = full turn to the left, frame 8 = dead straight ahead, frame 15 = full turn to the right, frame 16 = straight ahead with a small bump (used on rough ground). Each frame turns the same small step further than the one before. The game picks a frame from the angle of the board the player turns. At full turn the body rolls 6 degrees outward on its springs and the front wheels turn. The tail lights and spare tyre stay clearly visible.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no road, no water surface, no shadow, no speed lines, no dust.
```

## 43. `rides/boat_row_4x4.png`: rowing boat, rowing

*Attach: `vehicles_reference.png`, `rider_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same shape, proportions, colours and painting style.
The subject: Kayal, a small wooden rowing boat: teal hull with an orange stripe, a painted eye on the bow in the traditional South Indian coastal style, two long wooden oars, a folded mast, rowed by the hero seen from behind. The rider is the hero seen from behind in riding gear that hides who it is, so one sheet serves both heroes: a white-and-orange open-face sun hat covering the hair, a rust-and-teal two-tone light jacket, olive trousers, brown boots, a small brown satchel on the back. Kili sits on the folded mast.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The boat is seen from directly behind and a little above (the chase camera). It is centred at x = 256, about 420 px tall from the bottom of the hull to the top, bottom on a line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: one full rowing stroke with both oars: 1-4 the oars lift out of the water and reach forward; 5-8 the blades dip in; 9-12 the hero pulls back strongly; 13-16 the blades lift and return to frame 1. Only the oar blades touch the water line; no water drawn.
Expression: not visible.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 44. `rides/boat_turn_4x4.png`: rowing boat, 16 turning angles

*Attach: `vehicles_reference.png`, `rider_reference.png`.*

```
2D steering sprite sheet. Use the attached vehicle reference exactly.
The subject: Kayal, a small wooden rowing boat: teal hull with an orange stripe, a painted eye on the bow in the traditional South Indian coastal style, two long wooden oars, a folded mast, rowed by the hero seen from behind. The rider is the hero seen from behind in riding gear that hides who it is, so one sheet serves both heroes: a white-and-orange open-face sun hat covering the hair, a rust-and-teal two-tone light jacket, olive trousers, brown boots, a small brown satchel on the back.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The boat is seen from directly behind and a little above (the chase camera). It is centred at x = 256, about 420 px tall from the bottom of the hull to the top, bottom on a line 40 px above the bottom of the cell.
The 16 frames are 16 steering angles, NOT a time loop: frame 1 = full turn to the left, frame 8 = dead straight ahead, frame 15 = full turn to the right, frame 16 = straight ahead with a small bump (used on rough ground). Each frame turns the same small step further than the one before. The game picks a frame from the angle of the board the player turns. At full turn the hull yaws 30 degrees and heels 8 degrees; the oar on the inside of the turn is held in the water. No water is drawn.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no road, no water surface, no shadow, no speed lines, no dust.
```

## 45. `rides/cannon_aim_4x4.png`: foam cannon on the bow, 16 aim angles

*Attach: `vehicles_reference.png`, `rider_reference.png`.*

```
2D steering sprite sheet. Use the attached vehicle reference exactly.
The subject: a small brass foam-ball cannon on a wooden swivel mount at the bow of Kayal, a small wooden rowing boat: teal hull with an orange stripe, a painted eye on the bow in the traditional South Indian coastal style, two long wooden oars, a folded mast, seen from behind the hero's shoulder; the hero's hands hold the two brass handles at the back of the cannon.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The cannon is seen from behind and a little above. centred at x = 256, the mount's base on a line 40 px above the bottom of the cell, about 340 px tall.
The 16 frames are 16 steering angles, NOT a time loop: frame 1 = full turn to the left, frame 8 = dead straight ahead, frame 15 = full turn to the right, frame 16 = straight ahead with a small bump (used on rough ground). Each frame turns the same small step further than the one before. The game picks a frame from the angle of the board the player turns. Frame 1 aims 60 degrees to the left, frame 8 straight ahead, frame 15 60 degrees to the right; the barrel swings, the mount stays in place.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no road, no water surface, no shadow, no speed lines, no dust.
```

## 46. `rides/jet_bank_4x4.png`: Kestrel jet, 16 banking angles

*Attach: `vehicles_reference.png`.*

```
2D steering sprite sheet. Use the attached vehicle reference exactly.
The subject: Kestrel, a small friendly sky jet rebuilt from an old seaplane: rounded nose, swept wings, white and sunset-orange paint with teal trim, one bubble canopy, twin small rear engines, a tiny robot-sparrow picture painted on the tail, no military markings, no guns, flown by the hero (only the helmet shows through the canopy).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The jet is seen from directly behind and a little above, like a chase camera following it. centred at (256, 280), about 420 px wingtip to wingtip when level.
The 16 frames are 16 steering angles, NOT a time loop: frame 1 = full turn to the left, frame 8 = dead straight ahead, frame 15 = full turn to the right, frame 16 = straight ahead with a small bump (used on rough ground). Each frame turns the same small step further than the one before. The game picks a frame from the angle of the board the player turns. At full turn the jet banks 50 degrees and the nose yaws slightly into the turn. The two engine nozzles show solid warm-orange painted discs, no flame, no glow.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no road, no water surface, no shadow, no speed lines, no dust.
```

## 47. `rides/parachute_steer_4x4.png`: parachute, 16 steering angles

*Attach: `vehicles_reference.png`, `rider_reference.png`.*

```
2D steering sprite sheet. Use the attached vehicle reference exactly.
The subject: a round patchwork parachute in orange, cream and teal panels, with the hero hanging below in the harness. The rider is the hero seen from behind in riding gear that hides who it is, so one sheet serves both heroes: a white-and-orange helmet covering the hair, a rust-and-teal two-tone jacket with the satchel on the front, olive trousers, brown boots, a small brown satchel on the back.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Seen from behind and a little below the canopy. the canopy top 40 px below the top of the cell, the hero's feet 40 px above the bottom, centred at x = 256, about 430 px tall in all.
The 16 frames are 16 steering angles, NOT a time loop: frame 1 = full turn to the left, frame 8 = dead straight ahead, frame 15 = full turn to the right, frame 16 = straight ahead with a small bump (used on rough ground). Each frame turns the same small step further than the one before. The game picks a frame from the angle of the board the player turns. At full turn the canopy tilts 20 degrees and the hero swings 15 degrees outward on the lines, legs together.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no road, no water surface, no shadow, no speed lines, no dust.
```

## 48. `rides/raft_steer_4x4.png`: bamboo raft, 16 steering angles

*Attach: `vehicles_reference.png`, `rider_reference.png`.*

```
2D steering sprite sheet. Use the attached vehicle reference exactly.
The subject: a raft of bamboo poles lashed with rope, a small leaf-thatch shade and one long steering oar, steered by the hero standing at the back with the steering oar. The rider is the hero seen from behind in riding gear that hides who it is, so one sheet serves both heroes: a a cloth head wrap, a rust-and-teal two-tone light jacket, olive trousers, brown boots, a small brown satchel on the back.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The raft is seen from directly behind and a little above (the chase camera). It is centred at x = 256, about 420 px tall from the bottom of the raft to the top, bottom on a line 40 px above the bottom of the cell.
The 16 frames are 16 steering angles, NOT a time loop: frame 1 = full turn to the left, frame 8 = dead straight ahead, frame 15 = full turn to the right, frame 16 = straight ahead with a small bump (used on rough ground). Each frame turns the same small step further than the one before. The game picks a frame from the angle of the board the player turns. At full turn the raft yaws 30 degrees and the hero pushes the oar to the other side. No water drawn.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no road, no water surface, no shadow, no speed lines, no dust.
```

# Part D. Kili and the cast

## 49. `cast/kili_fly_4x4.png`: Kili, flying beside the hero

*Attach: `kili_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Kili, a small friendly robot sparrow, Raman's hand-made companion. Rounded body of polished copper and cream enamel plates, a soft teal chest panel with a small round speaker grille, big round glass eyes with warm amber irises (painted, no glow), short brass beak, wing feathers of thin copper leaves that fan open, two small tail fins, small brass feet, a tiny brass winding key on the back, one neat repair patch on the left wing. Looks loved and well made, never scary.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Kili is full body, three-quarter view facing right, centred at (256, 280) in every cell, the body (without wings) about 220 px tall.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: a gentle hovering flight loop: 1-4 wings sweep down, body rises 10 px; 5-8 wings sweep up; 9-12 down again; 13-16 up again with a small head tilt.
Expression: cheerful and alert. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 50. `cast/kili_point_4x4.png`: Kili, pointing to the next target

*Attach: `kili_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Kili, a small friendly robot sparrow, Raman's hand-made companion. Rounded body of polished copper and cream enamel plates, a soft teal chest panel with a small round speaker grille, big round glass eyes with warm amber irises (painted, no glow), short brass beak, wing feathers of thin copper leaves that fan open, two small tail fins, small brass feet, a tiny brass winding key on the back, one neat repair patch on the left wing. Looks loved and well made, never scary.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Kili is full body, three-quarter view facing right, centred at (256, 280) in every cell, the body (without wings) about 220 px tall.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 hovers; 4-7 leans forward and stretches the right wing out to the right like a pointing arm, beak pointing too; 8-12 holds and nods twice; 13-16 back to hover.
Expression: helpful, encouraging. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 51. `cast/kili_talk_4x4.png`: Kili, talking

*Attach: `kili_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Kili, a small friendly robot sparrow, Raman's hand-made companion. Rounded body of polished copper and cream enamel plates, a soft teal chest panel with a small round speaker grille, big round glass eyes with warm amber irises (painted, no glow), short brass beak, wing feathers of thin copper leaves that fan open, two small tail fins, small brass feet, a tiny brass winding key on the back, one neat repair patch on the left wing. Looks loved and well made, never scary.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Kili is full body, three-quarter view facing right, centred at (256, 280) in every cell, the body (without wings) about 220 px tall.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: hovering in place, the beak opens and closes in a natural speaking rhythm (open at 2, 5, 9, 12, 14), the head bobs slightly, one wing gestures at 7-10.
Expression: warm and friendly. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 52. `cast/kili_cheer_4x4.png`: Kili, celebrating

*Attach: `kili_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Kili, a small friendly robot sparrow, Raman's hand-made companion. Rounded body of polished copper and cream enamel plates, a soft teal chest panel with a small round speaker grille, big round glass eyes with warm amber irises (painted, no glow), short brass beak, wing feathers of thin copper leaves that fan open, two small tail fins, small brass feet, a tiny brass winding key on the back, one neat repair patch on the left wing. Looks loved and well made, never scary.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Kili is full body, three-quarter view facing right, centred at (256, 280) in every cell, the body (without wings) about 220 px tall.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-3 a quick dip; 4-8 a full happy loop-the-loop in place (body rotates 360 degrees, same size); 9-12 wings spread wide at the top, eyes closed in smiling arcs; 13-16 settles back to hover.
Expression: delighted. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 53. `cast/kili_encourage_4x4.png`: Kili, kind encouragement

*Attach: `kili_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Kili, a small friendly robot sparrow, Raman's hand-made companion. Rounded body of polished copper and cream enamel plates, a soft teal chest panel with a small round speaker grille, big round glass eyes with warm amber irises (painted, no glow), short brass beak, wing feathers of thin copper leaves that fan open, two small tail fins, small brass feet, a tiny brass winding key on the back, one neat repair patch on the left wing. Looks loved and well made, never scary.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Kili is full body, three-quarter view facing right, centred at (256, 280) in every cell, the body (without wings) about 220 px tall.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-4 hovers closer and tilts the head; 5-10 a slow nod and a soft wing pat in the air, like 'you can do it'; 11-16 a small hop upward, ready again.
Expression: kind, patient, smiling. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 54. `cast/kili_sing_4x4.png`: Kili, singing Raman's song

*Attach: `kili_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Kili, a small friendly robot sparrow, Raman's hand-made companion. Rounded body of polished copper and cream enamel plates, a soft teal chest panel with a small round speaker grille, big round glass eyes with warm amber irises (painted, no glow), short brass beak, wing feathers of thin copper leaves that fan open, two small tail fins, small brass feet, a tiny brass winding key on the back, one neat repair patch on the left wing. Looks loved and well made, never scary.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Kili is full body, three-quarter view facing right, centred at (256, 280) in every cell, the body (without wings) about 220 px tall.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: hovering, head raised, beak open in a gentle singing shape that changes slowly, wings half-open and swaying like a conductor; the chest speaker grille vibrates slightly.
Expression: peaceful, eyes softly closed. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 55. `cast/kili_wake_4x4.png`: Kili, waking up for the first time

*Attach: `kili_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Kili, a small friendly robot sparrow, Raman's hand-made companion. Rounded body of polished copper and cream enamel plates, a soft teal chest panel with a small round speaker grille, big round glass eyes with warm amber irises (painted, no glow), short brass beak, wing feathers of thin copper leaves that fan open, two small tail fins, small brass feet, a tiny brass winding key on the back, one neat repair patch on the left wing. Looks loved and well made, never scary.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Kili is full body, three-quarter view facing right, centred at (256, 280) in every cell, the body (without wings) about 220 px tall.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-4 lies switched off on its back, eyes dark grey; 5-6 the winding key turns; 7-9 the eyes switch to amber, one blinks; 10-13 rolls over and stands, shakes the wings; 14-16 looks up with a big happy face.
Expression: sleepy, then surprised and happy. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 56. `cast/lakshmi_talk_4x4.png`: Grandma Lakshmi, talking

*Attach: `lakshmi_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Grandma Lakshmi, a warm, wise village elder of about 75. Brown wrinkled skin, silver hair in a low bun with a few white jasmine flowers, round gold-rimmed glasses, a small red bindi, a gentle smile with laugh lines. Maroon cotton sari with a mustard border over a cream blouse, a thin beige shawl, a carved wooden walking stick.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Lakshmi is full body, three-quarter view facing right, centred at x = 256 in every cell, standing about 370 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: standing with the walking stick in the left hand, talking warmly: the mouth moves in a natural rhythm, the right hand gestures gently at 4-8, a nod at 10-12, a smile at 13-16.
Expression: wise, warm, hopeful. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 57. `cast/lakshmi_bless_4x4.png`: Grandma Lakshmi, blessing the hero

*Attach: `lakshmi_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Grandma Lakshmi, a warm, wise village elder of about 75. Brown wrinkled skin, silver hair in a low bun with a few white jasmine flowers, round gold-rimmed glasses, a small red bindi, a gentle smile with laugh lines. Maroon cotton sari with a mustard border over a cream blouse, a thin beige shawl, a carved wooden walking stick.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Lakshmi is full body, three-quarter view facing right, centred at x = 256 in every cell, standing about 370 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-4 raises the right hand, palm forward, in a blessing; 5-10 holds it with a gentle, proud smile and a small nod; 11-16 lowers it and wipes a happy tear with the shawl edge.
Expression: proud, moved.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 58. `cast/portraits_4x4.png`: dialogue portraits

*Attach: `lakshmi_reference.png`, `helpers_reference.png`, `rivals_reference.png`.*

```
2D sprite sheet of 16 head-and-shoulder dialogue portraits, each centred in its 512 x 512 cell, the head about 300 px tall, all at the same scale, facing three-quarter right.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Row 1, Grandma Lakshmi, a warm, wise village elder of about 75. Brown wrinkled skin, silver hair in a low bun with a few white jasmine flowers, round gold-rimmed glasses, a small red bindi, a gentle smile with laugh lines. Maroon cotton sari with a mustard border over a cream blouse, a thin beige shawl, a carved wooden walking stick. Expressions: smiling, explaining, worried but kind, proud. Row 2, Rao Uncle, a jolly desert mechanic of about 55. Deep-brown sun-weathered skin, big curled grey moustache, bright orange turban, oil-stained blue overalls with rolled sleeves, a red cloth tied at the neck, a big spanner in the back pocket, kind crinkled eyes. Expressions: laughing, explaining with a spanner, surprised, proud. Row 3, Selvi Akka, a strong, cheerful coastal boat builder of about 40. Dark-brown skin, hair tied up in a checked cloth, a mustard-yellow cotton sari tucked up practically at the knees over dark leggings, a carpenter's pencil behind one ear, a few wood shavings on her sleeves. Expressions: laughing, explaining, determined, proud. Row 4, Captain Rust, a comic, theatrical pirate inventor of about 50, never scary. Round belly, a huge orange-red beard braided with small brass gears, a tall battered captain's hat with a cog emblem (no skull), a long patched navy coat with too many brass buttons, a brass mechanical left hand like a little toolbox, one monocle, bushy eyebrows, a very expressive face that is mostly grumpy-funny or surprised. Expressions: grumpy-funny, shocked, scheming with raised eyebrow, sheepish sorry.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 59. `cast/rust_shout_4x4.png`: Captain Rust, shouting from his ship

*Attach: `rivals_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Captain Rust, a comic, theatrical pirate inventor of about 50, never scary. Round belly, a huge orange-red beard braided with small brass gears, a tall battered captain's hat with a cog emblem (no skull), a long patched navy coat with too many brass buttons, a brass mechanical left hand like a little toolbox, one monocle, bushy eyebrows, a very expressive face that is mostly grumpy-funny or surprised.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Rust is full body, three-quarter view facing right, centred at x = 256 in every cell, standing about 420 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-4 stomps a foot and shakes the brass hand in the air comically; 5-8 points dramatically to the left with the brass hand, the beard swings; 9-12 laughs with the belly bouncing, eyes squeezed; 13-16 straightens the hat, back to frame 1.
Expression: theatrical, grumpy-funny, never scary.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 60. `cast/rust_defeat_4x4.png`: Captain Rust, defeated

*Attach: `rivals_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Captain Rust, a comic, theatrical pirate inventor of about 50, never scary. Round belly, a huge orange-red beard braided with small brass gears, a tall battered captain's hat with a cog emblem (no skull), a long patched navy coat with too many brass buttons, a brass mechanical left hand like a little toolbox, one monocle, bushy eyebrows, a very expressive face that is mostly grumpy-funny or surprised.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Rust is full body, three-quarter view facing right, centred at x = 256 in every cell, standing about 420 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-4 his hat pops up off his head; 5-8 he spins once like a top, arms flailing comically; 9-12 sits down hard on his bottom, the hat lands back on his head crooked; 13-16 crosses his arms and pouts, cheeks puffed.
Expression: comically sulky, not hurt.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 61. `cast/rust_sorry_4x4.png`: Captain Rust, saying sorry

*Attach: `rivals_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Captain Rust, a comic, theatrical pirate inventor of about 50, never scary. Round belly, a huge orange-red beard braided with small brass gears, a tall battered captain's hat with a cog emblem (no skull), a long patched navy coat with too many brass buttons, a brass mechanical left hand like a little toolbox, one monocle, bushy eyebrows, a very expressive face that is mostly grumpy-funny or surprised.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Rust is full body, three-quarter view facing right, centred at x = 256 in every cell, standing about 420 px tall, feet on the same line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-4 takes off his hat and holds it to his chest; 5-10 a slow humble bow; 11-14 straightens up with a shy, hopeful smile; 15-16 puts the hat back on.
Expression: sheepish, sincere, hopeful.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 62. `cast/boltbeard_climb_4x4.png`: Boltbeard robot climbing aboard

*Attach: `rivals_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: a Boltbeard, one of Captain Rust's clumsy robot pirates: a small barrel-shaped robot of dented green-grey metal, one big round headlamp eye, a beard of curly copper springs, a tiny red-and-white striped bandana, spring arms with clamp hands, two short peg legs. Silly, never scary, never holds a weapon.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The robot is full body, front view, centred at x = 256, about 300 px tall, feet on a line 40 px above the bottom of the cell in frames 9-16.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-4 only the clamp hands and headlamp eye appear at the bottom of the cell as if over a ship's rail (the rail is NOT drawn); 5-8 it hauls itself up, peg legs scrambling; 9-11 stands up and wobbles; 12-16 waddles in place with silly arm waves.
Expression: silly, determined.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 63. `cast/boltbeard_pop_4x4.png`: Boltbeard robot falling apart

*Attach: `rivals_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: a Boltbeard, one of Captain Rust's clumsy robot pirates: a small barrel-shaped robot of dented green-grey metal, one big round headlamp eye, a beard of curly copper springs, a tiny red-and-white striped bandana, spring arms with clamp hands, two short peg legs. Silly, never scary, never holds a weapon.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The robot is full body, front view, centred at x = 256, about 300 px tall, feet on a line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-2 the headlamp eye blinks in surprise; 3-6 the spring beard boings outward; 7-10 the robot pops apart: barrel body, lid, peg legs, springs, bolts and gears fly outward a little; 11-14 the pieces fall to the bottom of the cell; 15-16 a neat small pile of gears and springs, the headlamp eye on top blinking sheepishly.
Expression: surprised, comic.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 64. `cast/grumblet_fly_4x4.png`: Grumblet drone flying

*Attach: `rivals_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: a Grumblet, a small grumpy storm-cloud drone: a round puffy dark-grey cloud body with soft white highlights on top, two big sulky eyes under heavy brows, a small brass propeller on top, two tiny metal fins underneath, a short zigzag brass antenna. Grumpy-cute, never scary.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The Grumblet is centred at (256, 256), about 300 px across.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: a grumpy hovering loop: propeller spins (four blade positions repeating), the cloud body puffs and shrinks 3 percent, the eyes glance left at 5-7 and right at 11-13, a tiny huff at 15.
Expression: grumpy-cute.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 65. `cast/grumblet_burst_4x4.png`: Grumblet bursting into rain

*Attach: `rivals_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: a Grumblet, a small grumpy storm-cloud drone: a round puffy dark-grey cloud body with soft white highlights on top, two big sulky eyes under heavy brows, a small brass propeller on top, two tiny metal fins underneath, a short zigzag brass antenna. Grumpy-cute, never scary.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The Grumblet is centred at (256, 200), about 300 px across.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-2 eyes go wide in surprise; 3-5 the cloud swells; 6-8 it bursts into eight soft solid grey cloud puffs and many solid blue rain drops; 9-13 the drops fall to the bottom of the cell while the puffs shrink; 14-15 a tiny white cloud with a small relieved smile remains; 16 it is nearly gone.
Expression: surprised, then relieved.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 66. `cast/megha_states_4x4.png`: Megha, the rain machine boss

*Attach: `rivals_reference.png`.*

```
2D sprite sheet of one large boss character in 16 states. Use the attached reference exactly.
The character: Megha, the great rain machine: a huge round engine of brass and glass shaped like a gentle face, with six petal-shaped brass shield plates around it, rain pipes hanging below like roots, small puffs of solid grey cloud around the rim. She was built long ago by the village inventor; she is sad and broken, never evil.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Megha is centred at (256, 256) in every cell, about 440 px across including the shield plates.
Cells 1-4: closed and stormy, all six shield plates closed, cracked glass face with tired eyes, frowning; each cell has a slightly different cloud puff position (loop). Cells 5-10: shield plates opening one by one, in order clockwise from the top (5 = one plate open ... 10 = all six open); each open plate shows a round brass button underneath. Cells 11-14: the glass face repairing in four steps, cracks disappearing, the eyes softening, the frown turning into a smile. Cells 15-16: healed, the glass clear, eyes kind, a gentle smile, the plates open like flower petals, solid blue rain drops falling softly from the pipes.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 67. `cast/glowlings_4x4.png`: Glowlings

*Attach: `guardians_reference.png`.*

```
2D sprite sheet. Use the attached reference exactly: same face, proportions, colours, clothing and painting style.
The character: Glowlings, small forest spirits the size of a hand: round soft bodies like dandelion seed heads in pale mint and warm cream, big dark friendly eyes, little leaf-shaped ears, short stubby arms, each holding a tiny lantern with a solid pale-yellow light shape inside (painted solid, no haze).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Four different Glowlings, one per row (pale mint, cream, light yellow, pale peach), each centred at x = 256, about 220 px tall.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: each row is a 4-frame loop of that Glowling: frame 1 floats, frame 2 rises 12 px and blinks, frame 3 lifts its lantern, frame 4 waves.
Expression: shy, sweet, curious.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 68. `cast/guardians_gift.png`: the five Guardians giving their seeds

*Attach: `guardians_reference.png`.*

```
Five separate sprites side by side on one canvas, each in its own 1024 x 1024 area, with clear space between them: the five Guardians from the attached reference (Shila the stone tortoise, Sona the golden fox, Neela the whale's head rising from a small solid wave, Vayu the white eagle with open wings, Minmini the Glowling queen), each in a gentle giving pose, holding out or offering its seed (a solid almond-shaped seed: earth brown, sun gold, water aquamarine, air pearl-white, forest emerald), each looking kindly toward the viewer.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 5120 x 1024. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 69. `cast/villagers_4x4.png`: returning villagers

*Attach: `style_key.png`, `arun_reference.png`.*

```
2D sprite sheet of 16 separate still game objects. Sixteen different friendly villagers of a South Indian farming village, each full body, three-quarter view, standing on a line 40 px above the bottom of the cell, all at one human scale (adults about 400 px tall, children and animals smaller), same style as the attached heroes.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, facing the viewer with a happy face, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a farmer with a towel on his shoulder; 2 a woman carrying a basket of flowers; 3 a potter with a clay pot; 4 a schoolgirl with a slate; 5 an old man with a walking stick and a dhoti; 6 a tea seller with a kettle; 7 a young mother holding a baby; 8 a weaver with a bundle of cloth; 9 a boy with a kite; 10 a fisherwoman with a basket on her head; 11 a blacksmith in an apron; 12 a girl carrying a small goat; 13 a musician with a nadaswaram-style horn; 14 a drummer with a barrel drum; 15 a temple flower seller; 16 Biscuit, a friendly brown-and-white village dog, sitting, tail up.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 70. `cast/dancers_4x4.png`: festival dancers

*Attach: `style_key.png`.*

```
2D sprite sheet. Use the attached reference exactly: same shape, proportions, colours and painting style.
The subject: four festival dancers from the village in bright cotton clothes: a man in a white veshti and orange shirt, a woman in a green-and-pink half-sari, a girl in yellow, an old man with a towel turban.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
One dancer per row, full body facing the viewer, centred at x = 256, about 400 px tall, feet on a line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: each row is a 4-frame folk dance loop for that dancer: 1 step and clap, 2 turn and raise an arm, 3 step back and clap, 4 open arms.
Expression: joyful, laughing. Never sad, angry, scared, mocking or ashamed.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 71. `cast/animals_4x4.png`: village and forest animals

*Attach: `style_key.png`.*

```
2D sprite sheet. Use the attached reference exactly: same shape, proportions, colours and painting style.
The subject: four small background animals, one per row: a crow, a goat, a peacock, a sleepy crocodile.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
One animal per row, side view facing right, centred at x = 256, sized naturally (crow 140 px, goat 280 px, peacock 320 px, crocodile 440 px long).
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: each row is a 4-frame loop: crow hops and flaps away; goat chews and flicks its ears; peacock pecks and lifts its head; crocodile opens a big lazy yawn and closes it.
Expression: gentle, comic.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

# Part E. Environments

Chase-view chapters use three pictures: a wide horizon that scrolls sideways, a ground tile that the game draws in perspective, and sprite sheets of roadside things. Puzzle and story places are single screens.

## 72. `world/c1_road_horizon.png`: Chapter 1, the Giant Road, horizon

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. Chapter 1, the Giant Road: green rolling hills in bright morning light, an ancient road of giant stone slabs winding into the far hills, broken stone pillars and old carved statues half covered in creepers, a huge round stone gate far away in the centre at the horizon, a few storm-fallen trees, a deep-blue sky with tall white clouds.
Composition: seen from a chase camera just behind and above the player. The horizon line is straight and level at y = 560. Above it: the sky and the far landscape described. Below it: the far landscape for the first 120 px, then plain ground colour fading smoothly to the bottom edge, with no road, track, path or objects, because the game draws the road in perspective and moves objects towards the player.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 3840 x 1080, seamless left to right: the left and right edges must join with no visible seam, because the picture scrolls sideways when the player steers. If your tool cannot make 3840 x 1080, make the middle 1920 x 1080 first and outpaint both sides. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 73. `world/c1_road_ground.png`: Chapter 1, the Giant Road, ground tile

*Attach: `style_key.png`.*

```
Seamless top-down texture for a game, large old grey-and-sand stone slabs with moss in the joints and a few small cracks. Canvas 1024 x 1024, tiles perfectly in both directions with no visible seam, even, flat, shadowless lighting with no light direction, no large single features that would repeat noticeably, no objects, no borders.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 74. `world/c1_road_props_4x4.png`: Chapter 1, the Giant Road, roadside things

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Things for the side of the path in Chapter 1, the Giant Road, seen from the chase camera (from the front and a little above).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a tall carved stone pillar; 2 a broken stone pillar; 3 an old stone milestone with carved swirls; 4 a banyan tree; 5 a coconut palm; 6 a flowering shrub with pink flowers; 7 a storm-fallen tree trunk lying across; 8 a stone elephant statue, worn and mossy; 9 a tall grass clump; 10 a stone lamp post with no lamp; 11 a small wayside shrine of stone, empty; 12 a pile of roof tiles blown by the storm; 13 a wooden cart with a broken wheel; 14 a tamarind tree; 15 a mossy boulder; 16 a cluster of yellow wildflowers.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 75. `world/c2_hills_horizon.png`: Chapter 2, Hill Trail, horizon

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. Chapter 2, Hill Trail: tea-covered hills with neat rows of bushes, a narrow dirt trail climbing between them, silver oak trees, a small waterfall on a far hill, the sun low in the sky turning everything gold, soft pink clouds.
Composition: seen from a chase camera just behind and above the player. The horizon line is straight and level at y = 560. Above it: the sky and the far landscape described. Below it: the far landscape for the first 120 px, then plain ground colour fading smoothly to the bottom edge, with no road, track, path or objects, because the game draws the road in perspective and moves objects towards the player.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 3840 x 1080, seamless left to right: the left and right edges must join with no visible seam, because the picture scrolls sideways when the player steers. If your tool cannot make 3840 x 1080, make the middle 1920 x 1080 first and outpaint both sides. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 76. `world/c2_hills_ground.png`: Chapter 2, Hill Trail, ground tile

*Attach: `style_key.png`.*

```
Seamless top-down texture for a game, packed red-brown dirt trail with small pebbles and tyre ruts. Canvas 1024 x 1024, tiles perfectly in both directions with no visible seam, even, flat, shadowless lighting with no light direction, no large single features that would repeat noticeably, no objects, no borders.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 77. `world/c2_hills_props_4x4.png`: Chapter 2, Hill Trail, roadside things

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Things for the side of the path in Chapter 2, Hill Trail, seen from the chase camera (from the front and a little above).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a tea bush; 2 a row of three tea bushes; 3 a silver oak tree; 4 a wooden fence section; 5 a wooden sign post with no writing; 6 a log lying across the trail; 7 a shallow puddle; 8 a rock outcrop; 9 a tea-picker's basket on a stand; 10 a small stone bridge rail; 11 a wild rhododendron bush with red flowers; 12 a eucalyptus tree; 13 a bamboo clump; 14 a fern clump; 15 a lantern on a pole (unlit); 16 a goat standing on a rock.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 78. `world/c3_desert_horizon.png`: Chapter 3, Desert Highway, horizon

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. Chapter 3, Desert Highway: a golden desert of tall rolling dunes, an old sandstone fort on a far ridge, a lone windmill, khejri trees, a cloudless hot blue sky, heat shimmer painted as soft colour, not haze.
Composition: seen from a chase camera just behind and above the player. The horizon line is straight and level at y = 560. Above it: the sky and the far landscape described. Below it: the far landscape for the first 120 px, then plain ground colour fading smoothly to the bottom edge, with no road, track, path or objects, because the game draws the road in perspective and moves objects towards the player.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 3840 x 1080, seamless left to right: the left and right edges must join with no visible seam, because the picture scrolls sideways when the player steers. If your tool cannot make 3840 x 1080, make the middle 1920 x 1080 first and outpaint both sides. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 79. `world/c3_desert_ground.png`: Chapter 3, Desert Highway, ground tile

*Attach: `style_key.png`.*

```
Seamless top-down texture for a game, cracked grey asphalt with drifts of golden sand blown across it and faded white edge lines. Canvas 1024 x 1024, tiles perfectly in both directions with no visible seam, even, flat, shadowless lighting with no light direction, no large single features that would repeat noticeably, no objects, no borders.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 80. `world/c3_desert_props_4x4.png`: Chapter 3, Desert Highway, roadside things

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Things for the side of the path in Chapter 3, Desert Highway, seen from the chase camera (from the front and a little above).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a cactus with three arms; 2 a short round cactus; 3 a khejri tree; 4 a dry tumbleweed bush; 5 a sand drift across the road; 6 a camel standing calmly; 7 a goat crossing; 8 a rusty oil drum; 9 a wooden road barrier painted red and white; 10 a sandstone rock; 11 a desert windmill; 12 a broken fence of wooden posts; 13 a stone milestone; 14 a fallen signboard with no writing; 15 a palm-leaf roadside shelter; 16 a pair of jerry cans.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 81. `world/c4_sea_horizon.png`: Chapter 4, the Harbour sea, horizon

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. Chapter 4, the Harbour sea: a bright calm tropical sea, a red-and-white lighthouse on a rocky island, two more small green islands, wooden fishing boats far away, seagulls as tiny shapes, white clouds.
Composition: seen from a chase camera just behind and above the player. The horizon line is straight and level at y = 560. Above it: the sky and the far landscape described. Below it: the far landscape for the first 120 px, then plain ground colour fading smoothly to the bottom edge, with no road, track, path or objects, because the game draws the road in perspective and moves objects towards the player.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 3840 x 1080, seamless left to right: the left and right edges must join with no visible seam, because the picture scrolls sideways when the player steers. If your tool cannot make 3840 x 1080, make the middle 1920 x 1080 first and outpaint both sides. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 82. `world/c4_sea_ground.png`: Chapter 4, the Harbour sea, ground tile

*Attach: `style_key.png`.*

```
Seamless top-down texture for a game, clear turquoise sea water with gentle ripples, top-down. Canvas 1024 x 1024, tiles perfectly in both directions with no visible seam, even, flat, shadowless lighting with no light direction, no large single features that would repeat noticeably, no objects, no borders.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 83. `world/c4_sea_props_4x4.png`: Chapter 4, the Harbour sea, roadside things

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Things for the side of the path in Chapter 4, the Harbour sea, seen from the chase camera (from the front and a little above).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a red buoy; 2 a yellow buoy; 3 a rock sticking out of the water; 4 a cluster of rocks; 5 a floating log; 6 a tangled fishing net with a cog symbol float; 7 a wooden post with a seagull; 8 a small island with one palm; 9 a moored fishing boat with an eye on the bow; 10 a lighthouse islet; 11 a floating crate; 12 a coral reef top; 13 a jumping fish; 14 a sea turtle swimming; 15 a floating coconut; 16 a marker pole with a flag of plain colour.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 84. `world/c5_pirates_horizon.png`: Chapter 5, Pirate Attack sea, horizon

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. Chapter 5, Pirate Attack sea: the open sea under a dramatic sky, dark storm clouds on one side and sunlight breaking through on the other, big rolling waves, the pirate ship far away on the horizon (a large comic steampunk ship shaped a little like a crab, with gear wheels, patched sails and puffing chimneys).
Composition: seen from a chase camera just behind and above the player. The horizon line is straight and level at y = 560. Above it: the sky and the far landscape described. Below it: the far landscape for the first 120 px, then plain ground colour fading smoothly to the bottom edge, with no road, track, path or objects, because the game draws the road in perspective and moves objects towards the player.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 3840 x 1080, seamless left to right: the left and right edges must join with no visible seam, because the picture scrolls sideways when the player steers. If your tool cannot make 3840 x 1080, make the middle 1920 x 1080 first and outpaint both sides. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 85. `world/c5_pirates_ground.png`: Chapter 5, Pirate Attack sea, ground tile

*Attach: `style_key.png`.*

```
Seamless top-down texture for a game, deep blue rolling sea water with white wave crests, top-down. Canvas 1024 x 1024, tiles perfectly in both directions with no visible seam, even, flat, shadowless lighting with no light direction, no large single features that would repeat noticeably, no objects, no borders.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 86. `world/c5_pirates_props_4x4.png`: Chapter 5, Pirate Attack sea, roadside things

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Things for the side of the path in Chapter 5, Pirate Attack sea, seen from the chase camera (from the front and a little above).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a large wave crest; 2 a small wave crest; 3 floating barrel; 4 floating gears; 5 a rock; 6 a broken mast floating; 7 a lifebuoy; 8 a red cannonball (solid, comic); 9 a blue water balloon; 10 a seagull; 11 a dolphin jumping; 12 a patched sail floating; 13 a crate of gears; 14 a net float; 15 a whale's tail rising; 16 a pirate rowing boat, empty.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 87. `world/c6_sky_horizon.png`: Chapter 6, Storm Skies, horizon

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. Chapter 6, Storm Skies: high above the clouds: snowy mountain ranges far below, a curved horizon, a bright clean sky above, and in the centre at the horizon a huge dark storm cloud with a faint brass fortress inside it.
Composition: seen from a chase camera just behind and above the player. The horizon line is straight and level at y = 560. Above it: the sky and the far landscape described. Below it: the far landscape for the first 120 px, then plain ground colour fading smoothly to the bottom edge, with no road, track, path or objects, because the game draws the road in perspective and moves objects towards the player.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 3840 x 1080, seamless left to right: the left and right edges must join with no visible seam, because the picture scrolls sideways when the player steers. If your tool cannot make 3840 x 1080, make the middle 1920 x 1080 first and outpaint both sides. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 88. `world/c6_sky_ground.png`: Chapter 6, Storm Skies, ground tile

*Attach: `style_key.png`.*

```
Seamless top-down texture for a game, a sea of soft white clouds seen from above. Canvas 1024 x 1024, tiles perfectly in both directions with no visible seam, even, flat, shadowless lighting with no light direction, no large single features that would repeat noticeably, no objects, no borders.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 89. `world/c6_sky_props_4x4.png`: Chapter 6, Storm Skies, roadside things

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Things for the side of the path in Chapter 6, Storm Skies, seen from the chase camera (from the front and a little above).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a large cloud; 2 a small cloud; 3 a wisp cloud; 4 a solid golden flying ring, open in the middle; 5 a solid teal flying ring; 6 a dark storm cloud; 7 a brass floating pylon; 8 a hot-air balloon basket with a patched balloon; 9 a flock of three birds; 10 a white eagle gliding; 11 a storm cloud with lightning (solid yellow bolt); 12 a rainbow arc section; 13 a sun-pulse orb (solid warm yellow ball); 14 a floating brass gear; 15 a piece of fortress wall on a cloud; 16 a weather vane.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 90. `world/c7_river_horizon.png`: Chapter 7, the forest river, horizon

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. Chapter 7, the forest river: a wide jungle river flowing towards the viewer between tall rainforest trees, hanging vines, mist painted as soft colour, a waterfall far away, the evening sky orange through the canopy.
Composition: seen from a chase camera just behind and above the player. The horizon line is straight and level at y = 560. Above it: the sky and the far landscape described. Below it: the far landscape for the first 120 px, then plain ground colour fading smoothly to the bottom edge, with no road, track, path or objects, because the game draws the road in perspective and moves objects towards the player.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 3840 x 1080, seamless left to right: the left and right edges must join with no visible seam, because the picture scrolls sideways when the player steers. If your tool cannot make 3840 x 1080, make the middle 1920 x 1080 first and outpaint both sides. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 91. `world/c7_river_ground.png`: Chapter 7, the forest river, ground tile

*Attach: `style_key.png`.*

```
Seamless top-down texture for a game, green-brown river water with gentle currents, top-down. Canvas 1024 x 1024, tiles perfectly in both directions with no visible seam, even, flat, shadowless lighting with no light direction, no large single features that would repeat noticeably, no objects, no borders.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 92. `world/c7_river_props_4x4.png`: Chapter 7, the forest river, roadside things

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Things for the side of the path in Chapter 7, the forest river, seen from the chase camera (from the front and a little above).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a river rock; 2 a fallen log; 3 a lily pad cluster; 4 a reed clump; 5 a sleeping crocodile (friendly, comic); 6 a hanging vine; 7 a riverside tree with roots; 8 a floating leaf; 9 a small rapid of white water; 10 a kingfisher on a branch; 11 a bamboo clump; 12 a firefly cluster (solid yellow dots); 13 a mossy stone; 14 a wooden fish trap; 15 a big lotus; 16 a turtle on a rock.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 93. `world/c1_boulders_4x4.png`: Chapter 1, boulders to break

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Keep the same boulder size across its row. Four rolling boulders, one per row, each shown in four states left to right: whole with a bright orange painted crack, cracking wider, split in two, a small pile of rubble with three gold coins on top. Row 1 small round boulder, row 2 medium flat boulder, row 3 large mossy boulder, row 4 huge boulder with a carved swirl.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 94. `world/c1_gate_lock.png`: Chapter 1, the tortoise gate puzzle

*Attach: `style_key.png`, `guardians_reference.png`.*

```
Full-screen painted game background with no characters. The Giant Gate seen straight on: it is Shila, a giant ancient stone tortoise, lying in a cliff gap with her huge carved shell facing the viewer, her gentle sleepy head resting to the left. The shell has three concentric round recessed tracks where stone rings sit, but the rings themselves are NOT painted (the game draws them). Moss, small flowers, warm morning light, blue sky above the cliffs.
Composition: the shell centre at (960, 560), the outer ring track 820 px across.
Keep clear: the rings area.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 95. `world/c1_gate_rings.png`: Chapter 1, three stone rings

*Attach: `c1_gate_lock.png`.*

```
Single 2D game sprite. Three separate concentric carved stone rings laid out side by side on one canvas, seen straight on: outer ring 820 px, middle ring 600 px, inner disc 380 px across, each with six carved symbols (leaf, sun, wave, feather, seed, flower) evenly spaced, and one bright carved arrow mark at the top. Each ring is a flat face, lit evenly from the top left so it still looks right when the game rotates it.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 2048 x 1024. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

## 96. `world/c1_chests_4x4.png`: Chapter 1, six chests and keys

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Treasure chests and keys for a find-the-match puzzle.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a stone chest with a leaf carving, closed; 2 a stone chest with a sun carving, closed; 3 a stone chest with a wave carving, closed; 4 a stone chest with a feather carving, closed; 5 a stone chest with a seed carving, closed; 6 a stone chest with a flower carving, closed; 7 a golden key with a leaf-shaped bow; 8 a golden key with a sun-shaped bow; 9 a golden key with a wave-shaped bow; 10 a golden key with a feather-shaped bow; 11 a golden key with a seed-shaped bow; 12 a golden key with a flower-shaped bow; 13 an open stone chest, empty; 14 an open stone chest with gold coins; 15 a stone chest lid only; 16 a little pile of stone dust.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 97. `world/c2_repair_bench.png`: Chapter 2, bicycle repair bench

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. A gatehouse workshop at the start of the hill trail: a wooden workbench seen from above at an angle, the old bicycle upside down on it with its chain missing, tools hanging on the wall, warm light through a small window.
Composition: the bicycle's chain ring in the middle of the screen.
Keep clear: a 1000 x 300 band across the lower middle where the game lays out the chain parts.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 98. `world/c2_bike_parts_4x4.png`: Chapter 2, chain and bike parts

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Bicycle repair parts, clean and shiny.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a chain link; 2 a chain section; 3 a gear ring; 4 a small gear; 5 a pedal; 6 a bell; 7 a brake lever; 8 a spanner; 9 an oil can; 10 a screwdriver; 11 a bolt; 12 a nut; 13 a spring; 14 a wheel spoke; 15 a tyre patch; 16 a pump.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 99. `world/c3_fuel_station.png`: Chapter 3, Rust's locked fuel station

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. An old roadside fuel station in the desert: three vintage fuel pumps painted red, cream and teal, each with a big round brass coin-lock on the front showing a cog symbol, a tin roof, a sleepy dog in the shade, dunes behind. The lock dials are blank (the game writes the sums).
Composition: the three pumps evenly across the middle, each lock face about 220 px across.
Keep clear: the lock faces, and a 900 x 200 band at the bottom for answer pads.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 100. `world/c3_stepwell.png`: Chapter 3, the hidden stepwell

*Attach: `style_key.png`, `guardians_reference.png`.*

```
Full-screen painted game background with no characters. Looking down into an ancient sandstone stepwell revealed by a sandstorm: zigzag flights of carved steps going down in many levels to a small pool of clear water, carved arches, golden light from above, a small golden fox waiting at the bottom by a glowing almond-shaped seed (solid gold).
Composition: symmetrical, the pool at (960, 900).
Keep clear: six landing platforms on the steps where the game places step targets.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 101. `world/c4_harbour.png`: Chapter 4, the harbour

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. A colourful South Indian fishing harbour in the morning: wooden boats with painted eyes, Selvi's boat-building shed with a half-built hull, nets with cog-shaped floats tangled everywhere, palm trees, the red-and-white lighthouse on its island in the distance, gulls.
Composition: the jetty leading from the bottom centre into the water.
Keep clear: the water in the lower half for fish and floats.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 102. `world/c4_fish_4x4.png`: Chapter 4, fish to catch

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Fish and sea things to catch, side view facing right, bright and friendly.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a silver sardine; 2 a yellow-striped fish; 3 a red snapper; 4 a blue parrotfish; 5 a small pomfret; 6 a crab; 7 a prawn; 8 a squid; 9 an old boot (comic); 10 a tin can (comic); 11 a starfish; 12 a seashell; 13 a bottle with a rolled paper map inside; 14 a pearl oyster; 15 a jellyfish (friendly); 16 a small octopus.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 103. `world/c4_whale_net.png`: Chapter 4, Neela in the nets

*Attach: `style_key.png`, `guardians_reference.png`.*

```
Full-screen painted game background with no characters. Top-down view from above the sea: the great blue whale Neela lies at the surface, tangled in a big fishing net held down by eight thick wooden net pegs with cog-shaped floats around her, her kind eye looking up, clear turquoise water, sun glints painted as solid shapes.
Composition: the whale centred, the eight pegs spaced around her about 300 px apart.
Keep clear: each peg's top, where the game places a target.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 104. `world/c5_rust_ship.png`: Chapter 5, the Clanking Crab ship

*Attach: `style_key.png`, `rivals_reference.png`.*

```
Single 2D game sprite. Captain Rust's comic steampunk pirate ship, the Clanking Crab, seen from the front-left at sea level: a round brass-and-wood hull shaped a little like a crab with two big claw-shaped bow rams, patched sails, puffing chimneys with solid grey smoke puffs, gear wheels on the sides, and on the hull a big round lock with four separate brass wheels arranged in a square, each wheel with an arrow mark. Comic, never scary, no skull flags.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 2048 x 1536, the ship filling it. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

## 105. `world/c5_deck.png`: Chapter 5, the boat's deck in battle

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. The deck of the little boat Kayal seen from above at a steep angle, with wooden planks, coiled ropes, the brass foam cannon at the front, the sea on every side with splashes, the pirate ship close behind on the right, a dramatic sky.
Composition: the deck fills the middle, the rail all around it with clear spots where robots climb over.
Keep clear: the rail on all four sides.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 106. `world/c6_fortress.png`: Chapter 6, the storm fortress

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. Inside the heart of a huge storm cloud: a round floating fortress of brass rings and cloud, rain falling in solid streaks, lightning shown as solid yellow bolts far away, and an empty glowing round platform in the centre where Megha sits (Megha is NOT painted; the game draws her).
Composition: the empty centre at (960, 500), 600 px across.
Keep clear: the centre.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 107. `world/c7_forest_from_above.png`: Chapter 7, the forest from the parachute

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. Top-down view straight down from a parachute high above a deep green rainforest at dusk: a sea of tree tops, a winding river, a rocky waterfall, and one round grassy clearing lit by soft golden light near the centre.
Composition: the clearing at (960, 620), about 300 px across.
Keep clear: the clearing.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 108. `world/c7_camp.png`: Chapter 7, the forest camp

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. A small forest clearing at dusk: a flat open ground of earth and leaves in the middle, a fallen tree on the left, a stream on the right, big trees and ferns all around, fireflies as tiny solid yellow dots, the sky turning orange-purple above the trees.
Composition: the open ground fills the middle and lower half.
Keep clear: the middle 1200 x 600 area for the fire, shelter and berries.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 109. `world/c7_night_path.png`: Chapter 7, the night path

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. The same forest at night under a big moon: dark blue trees, soft silver moonlight, and a scatter of twelve round flat mossy stones across the ground that make several possible paths from the bottom to a tree with a vine at the top.
Composition: the stones spread across the whole screen.
Keep clear: each stone.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 110. `world/c7_survival_4x4.png`: Chapter 7, survival items and berries

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Forest survival items and berries.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a short log; 2 a pile of firewood; 3 a flat stone; 4 a campfire of solid painted flames (unlit version next); 5 an unlit campfire of sticks; 6 a big leaf for the roof; 7 a bamboo pole; 8 a coil of vine rope; 9 red round berries on a twig (safe); 10 blue berries on a twig (safe); 11 yellow star-shaped berries (safe); 12 purple spotted berries (not safe, but still friendly-looking); 13 white waxy berries (not safe); 14 a banana bunch; 15 a coconut; 16 a clay water pot.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 111. `world/c8_village_square.png`: Chapter 8, the village square, dry

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. Malarpuram's village square after the storm: a dry stone well in the centre with a missing wheel, empty houses with tiled roofs, some broken, a big banyan tree with a stone platform, dry flower beds, an empty market lane, a temple gopuram far behind, hills and the long stone road in the distance.
Composition: the well at (960, 600).
Keep clear: five planting spots in a ring around the well.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 112. `world/c8_village_alive.png`: Chapter 8, the village square, alive

*Attach: `c8_village_square.png`.*

```
Full-screen painted game background with no characters. The same village square as the attached picture, fully restored: the well wheel repaired, houses painted and roofs whole, colourful kolam patterns on the ground, mango leaf garlands, flowers everywhere, market stalls with fruit, lanterns hung between houses, five young glowing trees around the well, a soft light rain falling and a rainbow.
Composition: match the attached dry version exactly in layout and camera.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 113. `world/c8_farm_fields.png`: Chapter 8, the farm fields from above

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. Top-down view of a small farm beside the village: a 4 x 3 grid of twelve square field plots of dry brown earth with low mud borders, a water channel along the top, a scarecrow, a straw hut and a coconut palm at the edges.
Composition: the 12 plots fill the middle 1500 x 780, each plot the same size.
Keep clear: each plot.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 114. `world/c8_crops_4x4.png`: Chapter 8, crops in four growth stages

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Four crops, one per row, each shown in four stages from left to right: seed in a small hole, sprout, young plant, ripe and ready. Row 1 paddy rice, row 2 sugarcane, row 3 turnip, row 4 marigold flowers. Same plant scale across each row, seen from above at an angle.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 115. `world/c8_houses_4x4.png`: Chapter 8, houses being rebuilt

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Four village houses, one per row, each in four stages from left to right: broken by the storm, being repaired with bamboo scaffolding, repaired, decorated for the festival with lights and garlands. Row 1 a tiled-roof farmhouse, row 2 a thatched hut, row 3 a two-storey house with a balcony, row 4 a small shop.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 116. `world/world_map.png`: the world map

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. An old hand-painted map of the whole journey on warm parchment, seen from above: the village Malarpuram at the bottom right, the Giant Road through green hills, the tea hills, the golden desert with a fort, the harbour and the sea with the lighthouse, a big storm cloud over the mountains, the deep forest and river leading back to the village. A dotted path joins eight empty round location badges (the game puts icons on them). Painted, not text.
Composition: the path makes a big loop around the map, the eight badges evenly spaced.
Keep clear: the eight badges.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

## 117. `world/rest_campfire.png`: rest scene background

*Attach: `style_key.png`.*

```
Full-screen painted game background with no characters. A calm night clearing: a ring of stones with a small campfire made of solid painted flames, a log to sit on, a big starry sky, fireflies as solid dots, distant hills; peaceful and cosy.
Composition: the fire at (1100, 760); the hero will sit on the left of it.
Keep clear: the log at (760, 790).
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

# Part F. Effects

Solid painted pieces only. The game adds glow, scaling, fading and screen shake itself (rule 2).

## 118. `fx/fx_dust_4x4.png`: Dust kicked up by running feet or wheels

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. Dust kicked up by running feet or wheels: soft sand-brown puffs with crisp outlines.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: 1-4 three small puffs appear low; 5-10 they grow and drift up and back; 11-16 they shrink and thin out.
Plays once: frame 1 is small, frame 16 is empty or nearly gone.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 119. `fx/fx_splash_4x4.png`: A water splash

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A water splash: solid white-and-turquoise water shapes and round drops.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: 1-3 a small crown of water rises; 4-8 it opens into a tall splash with drops; 9-13 the drops fall; 14-16 small ripples.
Plays once: frame 1 is small, frame 16 is empty or nearly gone.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 120. `fx/fx_rock_break_4x4.png`: A boulder breaking into stone chunks and gold coins

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A boulder breaking into stone chunks and gold coins, comic and satisfying, no fire.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: 1-2 a bright orange crack spreads; 3-5 the rock splits; 6-10 chunks and four gold coins burst outward; 11-16 chunks fall and shrink, coins spin.
Plays once: frame 1 is small, frame 16 is empty or nearly gone.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 121. `fx/fx_spark_pop_4x4.png`: A friendly 'spark stone' pop

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A friendly 'spark stone' pop: a round puff of solid orange and cream cloud shapes with small stars, like a party popper, not an explosion, no fire.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: 1-3 a small orange dot; 4-8 it pops into a round puffy cloud ring with stars; 9-16 the puffs drift out and shrink.
Plays once: frame 1 is small, frame 16 is empty or nearly gone.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 122. `fx/fx_gears_4x4.png`: Gears

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. Gears, springs and bolts flying out (a robot popping apart).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: 1-3 a few pieces appear at the centre; 4-9 they fly outward, spinning; 10-16 they fall downwards and shrink.
Plays once: frame 1 is small, frame 16 is empty or nearly gone.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 123. `fx/fx_rain_burst_4x4.png`: A cloud bursting into rain

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A cloud bursting into rain: solid grey puffs and many blue rain drops falling.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: 1-4 a puff splits; 5-10 drops fall in a curtain; 11-16 the last drops fall and small green sprouts appear at the bottom.
Plays once: frame 1 is small, frame 16 is empty or nearly gone.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 124. `fx/fx_lightning_4x4.png`: A lightning bolt drawn as a solid jagged yellow-white shape with a darker yellow edge (no glow).

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A lightning bolt drawn as a solid jagged yellow-white shape with a darker yellow edge (no glow).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: 1-2 a short zigzag starts at the top; 3-6 it strikes down to the bottom; 7-10 it branches; 11-16 it breaks into short pieces that vanish.
Plays once: frame 1 is small, frame 16 is empty or nearly gone.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 125. `fx/fx_sprout_4x4.png`: A seed planted in soil sprouting into a small plant with two leaves and a flower.

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A seed planted in soil sprouting into a small plant with two leaves and a flower.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: 1-3 a small mound of soil; 4-7 a green shoot comes up; 8-12 two leaves unfold; 13-16 a small yellow flower opens.
Plays once: frame 1 is small, frame 16 is empty or nearly gone.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 126. `fx/fx_confetti_4x4.png`: A celebration burst of solid paper confetti in marigold

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A celebration burst of solid paper confetti in marigold, teal, pink and white, plus small paper stars.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: 1-3 a small cluster; 4-8 it bursts upward and outward; 9-16 pieces tumble down and shrink.
Plays once: frame 1 is small, frame 16 is empty or nearly gone.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 127. `fx/fx_firework_4x4.png`: A festival firework drawn as solid petals and dots of colour in a flower shape (marigold

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A festival firework drawn as solid petals and dots of colour in a flower shape (marigold, teal and pink), no glow.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: 1-3 a small dot rises; 4-7 it opens into a round flower of petals; 8-12 the petals spread and droop; 13-16 they fall as dots.
Plays once: frame 1 is small, frame 16 is empty or nearly gone.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 128. `fx/fx_star_trail_4x4.png`: A trail of small solid gold four-pointed stars and dots

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A trail of small solid gold four-pointed stars and dots, for collected stars flying to the score.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: a loop of the trail: stars appear at the right and drift left, shrinking.
Frame 16 flows smoothly into frame 1.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 129. `fx/fx_campfire_4x4.png`: A cosy campfire of solid painted flame shapes in orange

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A cosy campfire of solid painted flame shapes in orange, yellow and red on a few logs, flames with a crisp edge (no glow, no smoke).
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: a gentle loop of the flames dancing; the logs stay still.
Frame 16 flows smoothly into frame 1.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 130. `fx/particles_4x4.png`: particles for every celebration

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Sixteen separate small particle pieces for a game's effects, each a solid painted shape with a crisp edge and no glow.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a gold five-pointed star; 2 a gold four-pointed sparkle; 3 a gold coin, front; 4 a gold coin, edge-on; 5 a teal gem; 6 a marigold petal; 7 a jasmine petal; 8 a green leaf; 9 a blue water drop; 10 a small brass gear; 11 a copper spring; 12 a confetti square (pink); 13 a confetti strip (teal); 14 a round soft dust puff with a hard edge; 15 a small heart; 16 a tiny almond seed (gold).
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 131. `fx/speed_lines.png`: speed lines overlay

*Attach: `style_key.png`.*

```
Single 2D game sprite. A full-screen overlay of thin white speed streaks radiating from the centre toward the edges, only near the edges, with the middle 60 percent of the screen completely empty. Solid white streaks with crisp ends.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 1920 x 1080. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

## 132. `fx/sandstorm_tile.png`: sandstorm overlay tile

*Attach: `style_key.png`.*

```
Seamless top-down texture for a game, drifting streaks and clumps of golden sand blown sideways, solid painted shapes on a transparent background (if transparency is impossible, on flat pure blue #0000FF). Canvas 1024 x 1024, tiles perfectly in both directions with no visible seam, even, flat, shadowless lighting with no light direction, no large single features that would repeat noticeably, no objects, no borders.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

# Part G. Rewards

## 133. `rewards/seeds_of_life.png`: the five Seeds of Life

*Attach: `style_key.png`.*

```
Single 2D game sprite. Five separate almond-shaped magical seeds side by side, each 400 px tall, polished, with an inner light painted as a solid brighter core (no glow, no rays): 1 Seed of Earth, warm brown stone with a green sprout-shaped vein; 2 Seed of Sun, golden amber with sun-ray grain; 3 Seed of Water, clear aquamarine with a small wave inside; 4 Seed of Air, pearl white with a feather swirl; 5 Seed of Forest, deep emerald with leaf veins. Below each, a dull grey stone version of the same seed (not found yet).
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 2560 x 1024, a row of five bright seeds on top, five grey ones below, evenly spaced. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

## 134. `rewards/coin_spin_4x4.png`: spinning gold coin

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A gold coin with a stamped seed emblem, 300 px across when facing the viewer.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: one full turn: 1 face on, 4 three-quarter, 5 edge on, 8 back face, 12 edge on, 16 almost face on again.
Frame 16 flows smoothly into frame 1.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 135. `rewards/star_spin_4x4.png`: spinning star

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A chunky gold five-pointed star with soft bevelled edges, 300 px across.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: one full turn around the vertical axis in 16 even steps.
Frame 16 flows smoothly into frame 1.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 136. `rewards/chest_open_4x4.png`: treasure chest opening

*Attach: `style_key.png`.*

```
2D sprite sheet. Use the attached reference exactly: same shape, proportions, colours and painting style.
The subject: a carved wooden treasure chest with brass corners and a round brass lock.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The chest is centred at x = 256, 360 px wide, its base on a line 40 px above the bottom of the cell.
The camera never moves or zooms. The subject is EXACTLY the same size in all 16 cells: do not shrink it to make room when an arm, wing or prop goes up, and do not rescale single frames. Same colours, markings and light in every frame. Natural motion with a slow start, faster middle and slow finish, small follow-through in hair, cloth, feathers or ropes, no sudden jumps between neighbouring frames. Plays once; frame 16 is a calm pose the game can hold.
Motion: 1-3 the chest wobbles; 4-6 the lock pops open; 7-10 the lid swings open; 11-16 gold coins and gems rise above the rim and settle, piled high.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no ground shadow, no scenery, no sparkles.
```

## 137. `rewards/badges_4x4.png`: badges

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Sixteen round reward badges like enamel pins with a brass rim, no text, each with one clear picture.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, facing the viewer flat, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a turning ring (100 rotations); 2 a reaching hand (new reach record); 3 a flame (7-day streak); 4 a stopwatch (fast reactions); 5 a peg board (100 placements); 6 a sweeping wave (smooth sweep); 7 a brain with a leaf (memory); 8 a coin stack (maths); 9 a heart (came back after a break); 10 a sun (morning session); 11 a moon (evening session); 12 Kili's face (first session); 13 a bicycle; 14 a boat; 15 a jet; 16 a house (village rebuilt).
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 138. `rewards/collectibles_4x4.png`: collectibles and pickups

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Things to collect during play, chunky and readable.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a gold coin pile; 2 a gem (teal); 3 a gem (pink); 4 a jerry can of fuel; 5 a lantern coin (coin with a lamp emblem); 6 a map piece; 7 a memory chip (small brass and teal chip with a bird emblem); 8 a brass key; 9 a gear; 10 a seed packet; 11 a water pot; 12 a heart; 13 a shield badge; 14 a speed boot; 15 a magnet; 16 a clock.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 139. `rewards/outfits_4x4.png`: outfit and paint shop items

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Shop items for the heroes and vehicles, as neat icons.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, seen from the front and a little above, standing upright, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 a red turban; 2 a straw hat; 3 a festive silk shirt; 4 a festive silk tunic; 5 a gold wrist band; 6 a flower garland; 7 sunglasses; 8 a scarf; 9 a bicycle paint can (green); 10 a jeep paint can (red); 11 a boat paint can (blue); 12 a jet decal of a star; 13 a jet decal of a lotus; 14 a bell; 15 a flag of plain colours; 16 a horn.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 140. `rewards/result_stars.png`: result stars

*Attach: `style_key.png`.*

```
Single 2D game sprite. Three large chunky stars side by side: the left one empty (only a grey outline and a pale fill), the middle one gold and full, the right one gold, full and with a small gold rim. Each 360 px.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 1280 x 448. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

## 141. `rewards/hero_statue.png`: Hero of Malarpuram statue

*Attach: `style_key.png`.*

```
Single 2D game sprite. A bronze statue on a carved stone pedestal decorated with garlands: the hero (keep it gender-neutral: a figure in a long cape-like shawl, face up toward the sky, one arm raised holding a seed) with a little robot sparrow on the shoulder. The pedestal front has an empty plaque (the game writes the name).
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 1024 x 1536. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

# Part H. Game screen pieces

The shared game shell still draws Home, Pause and Sound and the status pill. These pieces are only for the journey's own screens.

## 142. `ui/target_ring_4x4.png`: touch target ring

*Attach: `style_key.png`.*

```
2D effect sprite sheet for a game. A round target marker for a touch table, 400 px across: a thick solid teal ring with four small solid triangles pointing inward, a lighter inner ring.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The effect is centred at (256, 256) in every cell and grows to at most 440 px across.
Frames: a gentle pulse loop: the triangles move in 10 px and out again, the inner ring turns 90 degrees.
Frame 16 flows smoothly into frame 1.
Built only from solid, clearly painted pieces with crisp edges (chunks, drops, petals, puffs with a hard outline). The game adds glow and fading itself.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 143. `ui/turn_dial.png`: turn dial

*Attach: `style_key.png`.*

```
Single 2D game sprite. A round dial seen straight on, 700 px: a brass rim, a cream face with a thick green arc showing the target range, small tick marks every 15 degrees, an empty centre where the game draws the board and a pointer.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 1024 x 1024. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

## 144. `ui/hold_meter.png`: hold meter

*Attach: `style_key.png`.*

```
Single 2D game sprite. A round charge meter, 500 px: an empty thick ring track in dark teal with a brass rim, and separately on the right of the canvas a solid fill arc piece in bright marigold that the game rotates and masks.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 1024 x 512. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

## 145. `ui/radar.png`: compass and mini-map

*Attach: `style_key.png`.*

```
Single 2D game sprite. A round compass mini-map frame 500 px: a dark translucent-looking (painted solid dark blue) disc with fine grid rings, four small letter-free arrow marks at north, east, south and west, a brass rim.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 512 x 512. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

## 146. `ui/progress_bar.png`: session progress bar

*Attach: `style_key.png`.*

```
Single 2D game sprite. A long rounded progress bar frame 1200 x 80 with a brass edge and a dark inner track, plus separately below it a bright green fill strip and a gold fill strip of the same inner size, and a small round seed icon cap for the left end.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 1280 x 384. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

## 147. `ui/dialogue_box.png`: dialogue box with portrait frame

*Attach: `style_key.png`.*

```
Single 2D game sprite. A wide speech panel 1500 x 300 with a warm cream fill, a soft brass and teal border, rounded corners, and a round portrait frame on the left 260 px across that overlaps the edge.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 1600 x 400. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

## 148. `ui/chapter_card_4x4.png`: chapter cards

*Attach: `style_key.png`.*

```
2D sprite sheet of 16 separate still game objects. Sixteen small painted chapter scenes in rounded card frames with a brass edge, no text.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Each object is centred in its own cell, facing the viewer flat, filling about 70 percent of the cell, the same light from the top left on all of them, painted at one consistent scale where they are the same kind of thing.
The 16 cells: 1 the village in the storm; 2 the Giant Road; 3 the hill trail at sunset; 4 the desert highway; 5 the harbour; 6 the pirate battle; 7 the storm skies; 8 the forest; 9 the village festival; 10 a padlock (locked chapter); 11 a seed slot empty; 12 a seed slot filled; 13 a star frame; 14 a camp; 15 a postcard frame; 16 a map pin.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadows, no scenery.
```

## 149. `ui/postcard_frame.png`: postcard frame

*Attach: `style_key.png`.*

```
Single 2D game sprite. An old-fashioned postcard 1400 x 900 with a cream paper border, a small painted stamp of a robot sparrow in the top right corner, a postmark ring, and an empty rectangle for a picture.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no glow, no haze, no light rays, no see-through areas, no loose wisps.
Canvas 1536 x 1024. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No ground, no shadow, no scenery.
```

## 150. `ui/layout_chase.png`: layout picture of a chase level

*Attach: `style_key.png`, `c1_road_horizon.png`, `arun_run_back_4x4.png`.*

```
Full-screen painted game background with no characters. A mock-up of a finished chase-view game screen on a 43-inch touch table: the Giant Road horizon, a stone road in perspective from the bottom centre to the horizon, the hero running seen from behind at the bottom centre about 300 px tall, two boulders coming with bright cracks, a teal target ring on one crack, Kili flying at the upper left, a thin progress bar at the top centre, a small round compass top left, stars scattered on the road.
Composition: a clear, readable game screen.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary. No people, animals or vehicles unless named above.
```

# Part I. Story cutscene panels

No speech bubbles; the game shows subtitles and plays the voice.

## 151. `story/p0_1.png`: Prologue 1

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. Malarpuram at dusk before the storm: green fields, lanterns in windows, children playing, a brown-and-white dog asleep by the village gate, the hero on a cart smiling, a huge dark cloud far away on the hills. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 152. `story/p0_2.png`: Prologue 2

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. The great storm hits: a huge dark storm cloud with a faint sad face rolls over the village, solid lightning bolts, palm trees bending, roof tiles flying, villagers running inside. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 153. `story/p0_3.png`: Prologue 3

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. Inside the shaking granary: the hero holds the big wooden door shut with the right arm and shoulder against the wind, Grandma Lakshmi pulls two children to safety behind sacks of seed. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 154. `story/p0_4.png`: Prologue 4

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. Morning after: brown fields, a dry well, families leaving on bullock carts, the hero standing in the square with the right arm in a cotton sling, Grandma's hand on their shoulder. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 155. `story/p0_5.png`: Prologue 5

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. In the broken granary a shaft of morning light falls on a little copper robot sparrow lying switched off among the straw; the hero kneels and gently reaches for its brass winding key. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 156. `story/p0_6.png`: Prologue 6

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. Grandma Lakshmi unrolls an old hand-painted map on a wooden table in her house, five glowing seed shapes marked across it; the hero and the robot sparrow lean in, amazed. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 157. `story/p1_end.png`: Chapter 1 ending

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. The giant stone tortoise Shila lifts her ancient head out of the cliff, the great gate opens behind her, and she gently places a brown glowing seed into the hero's open hands; Kili cheers. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 158. `story/p2_end.png`: Chapter 2 ending

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. The hero rides the old bicycle over a firefly-lit wooden bridge at dusk, the tea hills behind, a small town and an old jeep visible in the far valley. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 159. `story/p3_end.png`: Chapter 3 ending

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. Deep in a sandstone stepwell, a golden fox sits beside the hero and Rao Uncle; an open chest of gold coins and a golden seed shine in the hero's hands. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 160. `story/p4_end.png`: Chapter 4 ending

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. The great blue whale Neela rises beside the little teal boat, free of the nets, spraying a fountain of water; the hero and Selvi wave from the boat. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 161. `story/p5_end.png`: Chapter 5 ending

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. Captain Rust sits sulking on a sandbank, soaking wet, his hat crooked, his robots in a pile of gears; on the boat the hero holds an aquamarine seed while Rao and Selvi start rebuilding a seaplane on the beach. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 162. `story/p6_end.png`: Chapter 6 ending

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. High in the sky the healed rain machine Megha smiles through clear glass, a gentle rainbow behind her; the hero falls under a bright patchwork parachute while a great white eagle carrying the robot sparrow flies alongside with a pearl seed. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 163. `story/p7_end.png`: Chapter 7 ending

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. On a bamboo raft on the evening river, the hero and Kili see a thin line of chimney smoke and a temple tower above the trees; Glowlings wave goodbye from the riverbank holding tiny lanterns. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 164. `story/p8_1.png`: Finale 1

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. The brown-and-white village dog runs joyfully toward the hero at the village gate, Grandma Lakshmi behind with tears of joy. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 165. `story/p8_2.png`: Finale 2

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. Five people plant five glowing seeds in a ring around the village well while the first gentle rain begins, everyone looking up at the sky smiling. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```

## 166. `story/p8_3.png`: Finale 3

*Attach: `style_key.png` and the references of the characters in it.*

```
Cinematic comic-book panel for a story cutscene, painted, one single panel filling the canvas, no speech bubbles, no captions, no panel border. The harvest festival: kolam patterns, a clay pot boiling over with sweet rice, villagers dancing, fireworks of marigold colours launched by a cheerful Captain Rust, and a bronze statue of the hero with the robot sparrow being unveiled. Use the attached references for every character.
Style: premium painted 2D game art with a bright, cinematic, semi-realistic look, like a high-quality modern mobile adventure game: strong warm sunlight from the top left, clear deep-blue skies, rich natural colours, believable materials (painted metal, worn wood, wet rock, water, cotton, leather), stylised friendly characters with natural human proportions about 7 heads tall, clean painted edges, shapes that read clearly from 2 metres away. Painted 2D, not a 3D render, not flat vector, not pixel art, not anime, not a photo. Match the attached style key.
Canvas 1920 x 1080, 16:9. Keep the bottom 200 px calm and darker for subtitles. No text, letters, numbers, logo, watermark or signature. No real brands, vehicle makes, flags or military insignia. No resemblance to any existing film, cartoon or game, or to their characters, vehicles or places. No weapons pointed at people, no blood, no fire damage, nothing scary.
```
