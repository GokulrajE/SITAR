# Journey Home — Rehab Adventure Game Design

Nov 26, 2026 · Living version: https://claude.ai/artifact/Dq4ikRtiMg8KwbzF5pDuW3

Full story (names, guardians, twist, every chapter's set pieces): [JOURNEY_HOME_STORY.md](JOURNEY_HOME_STORY.md).
2D art prompts for every character, sheet, background, effect and reward: [JOURNEY_HOME_ART_PROMPTS.md](JOURNEY_HOME_ART_PROMPTS.md).

## Vision and therapy goals

*Journey Home* is a third-person (TPP) story adventure. A hero travels across eight worlds, from a broken giant road to a peaceful farming village, and every heroic act is a real therapy movement on the pegboard hardware. The story gives patients a reason to repeat movements hundreds of times, and each chapter adds one new motor skill and one new cognitive skill.

**Who it is for:** adults and children recovering upper-limb function after stroke, brain injury, cerebral palsy or hand surgery. Seated play only, 10–20 minute sessions, used in the clinic or at home.

**Core design rules**

- Every game action is a therapy movement, and there are no keyboard or mouse shortcuts in play.
- One chapter = 4–6 short levels of 2–4 minutes each, with a rest scene between levels.
- Difficulty adapts to the patient's measured range, speed and accuracy, not to a fixed level number.
- The story never punishes. A failed attempt slows the scene and gives a hint, and the hero never dies.
- Progress is visible: the world itself grows greener, richer and more populated as the patient improves.

| Goal type | What the game trains |
| --- | --- |
| Motor | Reach, point-to-point accuracy, pinch and grasp of pegs, wrist/forearm rotation (pronation–supination), bimanual coordination, sustained hold, speed |
| Cognitive | Attention, visual search, working memory, sequencing, planning, simple arithmetic, inhibition (go/no-go), dual-tasking |

## Hardware input map

The game uses seven input gestures, each mapped to one therapy movement and reused across every chapter so patients learn them once. The hero is never steered with a joystick: touching a target on the board makes the hero run, jump or act toward the matching point in the 3D world.

| Input gesture | Hardware action | In-game action | Therapy target |
| --- | --- | --- | --- |
| **Tap** | Touch a lit hole or pad | Hero runs/jumps to that lane or spot; punch an obstacle | Reach, pointing accuracy, reaction time |
| **Peg place** | Pick a peg and insert it in a lit hole | Plant a bomb, fix a bridge plank, plant a seed | Pinch grasp, fine motor, eye–hand coordination |
| **Peg pull** | Remove a peg from a hole | Pull a lever, harvest a crop, release an anchor | Grip strength, controlled release |
| **Rotate** | Turn the rotating pegboard or knob (angle sensor) | Turn a vault lock, steer a bike or car, aim a cannon, raise a drawbridge | Wrist pronation–supination, range of motion |
| **Hold** | Keep a finger or peg on a pad for 2–10 s | Charge a power shot, keep a shield up, refuel | Sustained isometric control, endurance |
| **Sweep** | Slide the hand across a row of pads | Collect stars and coins, clear fog, wipe a map | Shoulder/elbow range, smooth trajectories |
| **Two-board** | Act on two pegboards at once or in turn | Pilot plus gunner, row both oars, two-hand lock | Bimanual coordination, crossing the midline |

**Board layout zones:** split each board into left, centre and right lanes plus near and far rows. This lets the game ask for exact reach distances and directions, and record a reach map for the therapist.

**Feedback on the device:** if the board has LEDs, light the target hole in the same colour as the in-game target. Add a soft vibration or chime on success so the patient feels and hears it, not only sees it.

**Open questions about the hardware**

- How many holes per board, and does each hole sense touch, peg presence or both?
- Is rotation continuous (encoder) or limited to a fixed range, and what is its angle resolution?
- How many boards can connect at once, and over USB, Bluetooth or serial?

## Story and characters

The hero's home village lost its harvest and its water after a great storm. The hero sets out to bring back the **Seeds of Life**, five glowing seeds scattered across the land. Each world returns one seed, and the final chapter is planting them so the village blooms again. The story is a mirror of recovery: things that are broken are rebuilt, step by step, by the player's own hands.

**Characters**

| Character | Role | Notes |
| --- | --- | --- |
| **Hero (Arun or Meera)** | Player character, chosen at start, shown in third person | Male or female; skin tone, hair and outfit customisable; outfit pieces unlocked as rewards |
| **Pip, the robot sparrow** | Companion and guide | Speaks hints, points at the next target, celebrates wins; voices the therapist's goals in story form ("Ten more planks and the bridge holds!") |
| **Grandma Lakshmi** | Village elder, quest giver | Appears in the intro, chapter breaks and finale; gives the daily mission |
| **Captain Rust** | Ocean pirate boss (chapter 5) | Comic, not scary; his robots fall apart into gears when hit |
| **Storm Drones** | Sky enemies (chapter 6) | Small grey clouds with eyes; burst into rain that waters the land below |
| **Forest spirits (Glowlings)** | Helpers in the forest (chapter 7) | Ask memory and sorting puzzles; reward with light and food |
| **Villagers** | Return in the finale | Each one comes back when the player completes a milestone, so the village fills up visibly |

**Story arc:** Call (village in trouble) → Journey across land, road, sea, sky and forest → Return home with all seeds → Celebration harvest festival. Each chapter ends with a short 2D comic-panel cutscene (10–20 s, skippable) so reading load stays low for patients with cognitive fatigue.

**Tone:** hopeful, warm, light humour, no violence against people. Enemies are robots, drones or rocks that break into coins and stars.

**Language:** short voice-over lines with subtitles, and support for regional languages (for example Tamil, Hindi, English) from the first release.

## Chapter-by-chapter level design

There are eight chapters, each introducing one new vehicle or environment and one new hardware gesture, while all earlier gestures stay in use. Five chapters (1, 3, 5, 6, 7) each return one Seed of Life, and chapter 8 plants them all.

### Chapter 1 — The Giant Road (on foot)

- **Story:** The storm has blocked the ancient Giant Road with boulders and a huge stone gate. Pip wakes the hero: "Let's open the road!"
- **Gameplay:** Third-person run along three lanes. Tap the lit lane to dodge or move. Tap a boulder's glowing crack to smash it. Place pegs to drop "spark stones" that blow up larger rocks.
- **Lock puzzle:** The giant gate has three stone rings. Rotate the pegboard to turn each ring until its symbols line up. Each ring needs a different angle, and the last ring turns the other way.
- **Star rain:** After every 60 s a shower of stars falls. Sweep the hand across the pads to collect them.
- **Key hunt:** The gate key is hidden in one of six chests. Pip shows the key's shape; the player finds and taps the matching chest (visual search).
- **Reward:** Seed of Earth + the old bike in the gatehouse.
- **Trains:** reach, tap accuracy, rotation, visual search.

### Chapter 2 — Hill Trail (bike)

- **Story:** The hero repairs an old bike to cross the hills before sunset.
- **Gameplay:** Rotate the board to steer left and right along a winding trail. Hold a pad to pedal faster uphill. Tap to jump over logs.
- **Repair mini-game:** Place pegs in the right order to fix the chain (sequence memory: 3, then 4, then 5 steps).
- **Collectibles:** coins on curves reward smooth, controlled rotation, not fast jerks.
- **Reward:** Map piece showing the town and a car.
- **Trains:** graded rotation range, sustained hold, sequencing.

### Chapter 3 — Desert Highway (car and fuel)

- **Story:** The bike is too slow for the desert. A mechanic lends the hero a jeep, but the fuel pumps are locked.
- **Gameplay:** Steer by rotation; dodge cactus and sand storms by tapping lanes.
- **Fuel puzzle:** Each pump shows a sum (for example 7 + 5). The player places the right number of pegs, or taps the pad showing the answer, to unlock the fuel. Levels progress from counting, to addition, to subtraction, to money ("Fuel costs 3 coins per litre; you need 4 litres").
- **Refuel:** Hold a pad to fill the tank; release on the green mark (timing and inhibition).
- **Reward:** Seed of Sun + a treasure chest of gold coins, now the hero is rich.
- **Trains:** rotation, calculation, inhibition, dual-task (steer and count).

### Chapter 4 — The Harbour (boat)

- **Story:** With the gold, the hero buys a boat to cross the sea.
- **Gameplay:** Two-board rowing: left board = left oar, right board = right oar. Alternate taps go straight; one side turns the boat. Later, rotate to use the rudder.
- **Fishing:** Place a peg to drop the line; pull it out at the right moment to catch fish (grip and release timing).
- **Navigation:** Remember the lighthouse light pattern (for example red–green–red) and steer to the island with the same pattern (working memory).
- **Reward:** Ship upgrade and a cannon.
- **Trains:** bimanual rhythm, grip/release, working memory.

### Chapter 5 — Pirate Attack (boat battle)

- **Story:** Captain Rust and his robot pirates attack to steal the gold.
- **Gameplay:** Rotate the board to aim the cannon; place a peg to load; tap to fire. Pirate robots climb on deck from different sides; tap where they appear (reaction and reach to all zones).
- **Shield:** Hold a pad to raise a shield when Pip warns of a cannonball (go/no-go: only block red balls, let blue water balloons through).
- **Boss:** Captain Rust's ship has a lock of four rotating wheels on its hull. Rotate each to the angle shown to sink it.
- **Reward:** Seed of Water + a captured seaplane.
- **Trains:** aiming rotation, multi-zone reach, inhibition, attention.

### Chapter 6 — Storm Skies (fighter jet)

- **Story:** The storm's source is a cloud fortress. The hero flies to stop it.
- **Gameplay:** Rotate one board to bank and turn; tap the other board to fire at Storm Drones. Burst drones rain down and turn deserts below green.
- **Rings:** Fly through glowing rings by touching the ring's position on the board (target reach in space).
- **Boss:** The Storm Core's shield opens in a pattern; repeat the pattern on the board to break it (Simon-style memory, 3–7 steps).
- **Reward:** Seed of Air. The jet is hit by the last lightning bolt, and the hero bails out.
- **Trains:** bimanual control, speed, pattern memory.

### Chapter 7 — Parachute and Forest Survival

- **Story:** The hero parachutes into a deep forest at dusk.
- **Parachute:** Rotate to guide the parachute and tap to collect stars falling past; land on the glowing clearing.
- **Survival tasks:** Collect wood (peg pull = chop), build a fire (place pegs in a triangle pattern), find food (sort berries: tap only the safe ones Pip described), build a shelter (place pegs as a sequence of pieces).
- **Day and night:** At night Glowlings light paths; remember the path and repeat it the next morning.
- **River:** The hero follows the river, builds a raft (peg placement) and steers downstream by rotation.
- **Reward:** Seed of Forest, and the hero sees smoke from a village across the river.
- **Trains:** fine motor variety, categorisation, planning, spatial memory.

### Chapter 8 — The Village Farm (finale)

- **Story:** The village has dry fields and empty houses. The hero plants the five seeds and brings the village back to life.
- **Farming loop:**
  1. Plough: sweep across the board rows.
  2. Sow: place one peg per seed hole, following a colour pattern.
  3. Water: rotate the well wheel; hold to pour.
  4. Protect: tap crows away (gentle, they fly off).
  5. Harvest: pull pegs out as crops ripen.
  6. Market: count and sell crops for coins (calculation).
- **Living village:** Each harvest brings villagers home, rebuilds houses and unlocks a festival. This chapter becomes an endless home-practice mode, with daily farm tasks that match the patient's therapy plan.
- **Ending:** Harvest festival with fireworks, dancing villagers and a "Hero of the Village" statue showing the player's chosen hero.
- **Trains:** every gesture combined, planning, money maths, long-term engagement.

## Cognitive and motor skill matrix

Each chapter has one new main skill (●) and keeps practising earlier ones (○), so difficulty grows gradually and nothing learned is dropped.

| Skill | 1 Road | 2 Bike | 3 Car | 4 Boat | 5 Pirates | 6 Jet | 7 Forest | 8 Farm |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Reach and tap accuracy | ● | ○ | ○ | ○ | ● | ○ | ○ | ○ |
| Peg pinch and place | ○ | ● | ○ | ○ | ○ |  | ● | ● |
| Grip and release (peg pull) |  |  |  | ● |  |  | ● | ● |
| Wrist rotation | ● | ● | ● | ○ | ● | ● | ○ | ○ |
| Sustained hold |  | ● | ○ |  | ○ |  |  | ○ |
| Sweep (shoulder/elbow range) | ○ |  |  |  |  |  | ○ | ● |
| Bimanual (two boards) |  |  |  | ● | ○ | ● |  | ○ |
| Visual search and attention | ● | ○ | ○ | ○ | ● | ○ | ○ | ○ |
| Working and sequence memory |  | ● |  | ● |  | ● | ● | ○ |
| Calculation and money |  |  | ● |  |  |  |  | ● |
| Inhibition (go/no-go) |  |  | ● |  | ● |  | ○ | ○ |
| Planning and categorisation |  |  |  |  |  |  | ● | ● |
| Dual-tasking |  |  | ● | ○ | ○ | ● |  | ○ |

**Therapist mode** lets a clinician lock a session to one skill (for example "rotation only, 40 reps"). The game then picks matching levels from any unlocked chapter, so story progress and the therapy plan never conflict.

## Rewards, points and celebrations

Rewards are tied to effort and quality of movement, not only to winning, so a patient with very limited movement still earns visible progress every session.

| Reward | How it is earned | What the player sees |
| --- | --- | --- |
| **Points** | Every correct action; bonus for accuracy, smoothness and full range | Floating "+10" numbers, combo counter (x2, x3) |
| **Stars (1–3 per level)** | 1 = completed, 2 = target accuracy, 3 = target accuracy plus personal best | Stars fly into the level card with a chime |
| **Coins** | Collected in the world; earned from calculation puzzles | Spent in the shop on outfits, vehicle paint, farm decorations |
| **Seeds of Life** | One per completed world | Glowing seed on the world map; the home village visibly changes |
| **Badges** | Milestones: "100 rotations", "7-day streak", "New reach record" | Badge wall in the hero's house |
| **Personal bests** | Beating own range, speed or accuracy record | Golden flash, Pip cheers, therapist is notified |
| **Daily streak** | Playing the prescribed session on consecutive days | Streak flame; no penalty for missed days, the streak only pauses |

**Celebration moments**

- **Small win (each action):** spark particles, short sound, screen shake of 0.1 s.
- **Level complete:** confetti burst, hero victory animation (jump, fist pump or dance), stars count up, Pip loops around the hero.
- **Chapter complete:** comic-panel cutscene, fireworks, seed-planting animation, new vehicle reveal with a spotlight.
- **Personal best:** slow-motion replay of the best movement with a gold trail.
- **Finale:** village festival with villagers dancing, lanterns rising and the hero statue unveiled.

**Motivation rules:** show progress bars for each session goal ("18 / 30 rotations"); always show the next reward; celebrate the patient's improvement over time, never compare patients with each other unless they opt in to a friendly leaderboard.

## Art direction: 2D plus 3D

Use low-poly stylised 3D for the world, hero and vehicles, seen from a third-person camera, and 2D sprites for UI, effects and cutscenes. Low-poly keeps the game fast on clinic laptops and makes free assets from different packs look consistent.

| Layer | Style | Used for |
| --- | --- | --- |
| **3D world** | Low-poly, bright toon shading, soft shadows | Road, hills, desert, sea, sky, forest, village |
| **3D characters and vehicles** | Rigged low-poly, humanoid skeleton | Hero, Pip, villagers, pirates, bike, jeep, boat, jet, parachute |
| **PBR textures (light use)** | Stylised over photoreal | Ground, water, wood and stone where close to the camera |
| **2D sprites (billboards)** | Flat, outlined | Stars, coins, sparks, confetti, hit effects, target rings |
| **2D UI** | Large rounded buttons, high contrast, icons with text | HUD, progress bars, rewards, menus, therapist panel |
| **2D cutscenes** | Comic panels with light animation | Chapter intros and endings |

**Third-person camera rules**

- Camera sits behind and slightly above the hero, and moves slowly: no sudden turns, to avoid motion sickness.
- The on-screen target always matches the board position (left hole = left side of screen) so the patient's mental map stays simple.
- Comfort settings: reduce camera motion, reduce effects, larger targets, colour-blind palettes.

**Accessibility:** minimum 48 px touch-equivalent targets on screen, no meaning given by colour alone (add shapes), subtitles on all speech, adjustable game speed from 50% to 150%.

## Online asset sources

Almost every asset can come from free CC0 libraries, which allow commercial use with no attribution. Check the licence on each pack's own page before shipping, because mixed-licence sites list non-CC0 items too.

| Source | What to take | Licence | Best for chapters |
| --- | --- | --- | --- |
| [Kenney](https://kenney.nl/assets/particle-pack) | Particle Pack (~80 VFX sprites), UI packs, car kit, nature kit, characters, audio | CC0 | All: effects, UI, vehicles, village |
| [Quaternius](https://gamefromscratch.com/quaternius-free-3d-assets/) ([OpenGameArt list](https://opengameart.org/content/all-cc0-uploader-quaternius)) | Rigged and animated characters, animals, vehicles, nature, farm and pirate packs | CC0 | Hero, villagers, pirates, forest, farm |
| [Poly Pizza](https://dev.to/dook/the-5-best-sites-for-free-low-poly-3d-models-for-unity-44lb) | Searchable low-poly models (bike, boat, jet, parachute, props) | Mostly CC0 / CC-BY, check each | Vehicles and one-off props |
| [itch.io CC0 low-poly](https://itch.io/game-assets/assets-cc0/tag-low-poly) | Vehicle packs, environment packs | Filtered to CC0 | Bike, jeep, boat |
| [itch.io CC0 2D](https://itch.io/game-assets/assets-cc0/tag-2d) and [CC0 UI](https://itch.io/game-assets/assets-cc0/tag-2d/tag-gui/tag-user-interface) | 2D animated characters, UI kits, icons | Filtered to CC0 | Cutscenes, HUD, badges |
| [OpenGameArt CC0](https://opengameart.org/content/cc0-public-domain) | Sprites, music, sound effects | CC0 (filter) | Celebrations, ambience |
| [Poly Haven](https://polyhaven.com) | PBR textures (8k+), HDRI skies (16k+), some models | CC0 ([FAQ](https://polyhaven.com/faq)) | Skies, sea, desert, forest ground |
| [ambientCG](https://ambientcg.com) | Seamless PBR materials up to 8K | CC0 | Road stone, wood, sand, grass |
| [Mixamo](https://www.donmccurdy.com/2017/11/06/creating-animated-gltf-characters-with-mixamo-and-blender) | Run, jump, punch, celebrate, dance, row, farm animations for the hero | Free with Adobe account; royalty-free in games (approximate, confirm terms) | Hero and villager animations |
| [Free character animations (CMU mocap)](https://rancidmilk.itch.io/free-character-animations) | Large glTF animation library | Free (check page) | Extra villager and celebration motions |
| [awesome-cc0 list](https://www.github.com/madjin/awesome-cc0) | Index of more CC0 sources | — | Gap filling |

**Pipeline for the hero:** model (Quaternius or Kenney character) → animations from Mixamo as FBX "without skin" → combine in Blender → export one **.glb**. glTF/GLB is Godot's preferred format, and Godot also imports FBX ([Godot forum](https://forum.godotengine.org/t/mixamo-character-separate-animation-files-one-glb-for-godot-without-blender/145654)). Plugins such as [Mixamo Animation Batcher](https://godotengine.org/asset-library/asset/5079) can automate the import.

**Hero animation list:** idle, run, jump, punch, cheer, victory dance, sit-ride (bike/car), row, pilot, parachute hang, chop, plant, water, harvest, wave.

## Adaptive difficulty, safety and therapist dashboard

A two-minute calibration at the start of each session sets every target to the patient's ability that day. The game then keeps the success rate near 70–80% by adjusting one variable at a time.

**Calibration (2 minutes, framed as "Pip's warm-up")**

- Reach map: tap every hole the patient can comfortably reach.
- Rotation range: turn the board fully left and right, three times.
- Hold time: keep a finger on a pad as long as is comfortable.
- Reaction speed: tap 10 lit targets as they appear.

**What adapts**

| Variable | Easier | Harder |
| --- | --- | --- |
| Target position | Inside the comfortable reach map | 10% beyond the best recorded reach |
| Rotation needed | 50% of measured range | 100–110% of range |
| Time window | No time limit | Shorter window, faster obstacles |
| Hold duration | 2 s | Up to 10 s |
| Memory/sequence length | 2–3 items | 6–7 items |
| Maths | Counting 1–5 | Two-step sums, money |
| Distractors | None | Decoys and go/no-go items |

**Safety**

- Auto-pause after a set number of reps or minutes; a rest scene (hero sits by a campfire) with breathing guidance.
- Fatigue detection: when speed or accuracy drops by more than a set amount, the game slows down and offers a break.
- Compensation check (optional webcam): detect trunk lean or shoulder hiking and ask Pip to remind "sit tall".
- Pain check: a simple face scale before and after each session.

**Therapist dashboard**

- Per session: reps by gesture, reach map heatmap, rotation range, reaction times, accuracy, hold times, cognitive scores.
- Trends over weeks, with export to CSV or PDF for clinical records.
- Prescribe goals ("3 sessions per week, focus rotation") that the game turns into story missions.
- Patient data stays on the device or a clinic server, with consent and anonymised IDs.

## Implementation roadmap and open questions

Start with a Chapter 1 vertical slice that proves the pegboard input and the fun, then add chapters in gated phases. Each phase starts only after its gate is met with real patients and therapists.

| Phase | Scope | Gate to move on |
| --- | --- | --- |
| **1 Prototype** | Pegboard input bridge; Chapter 1 vertical slice + calibration | A patient plays 10 min without help |
| **2 Core gameplay** | Chapters 2 to 4; rewards and badges; adaptive difficulty | Therapists approve reps and fun |
| **3 Full story** | Chapters 5 to 8; comic cutscenes; therapist dashboard | Full story runs on a clinic laptop |
| **4 Pilot and release** | Clinic pilot study; languages, home mode; polish and release | — |

**Suggested tech:** Godot 4 (free, glTF-native, exports to Windows, Android and Linux), with a small hardware bridge that reads the pegboard over serial or Bluetooth and emits the seven gestures as game events. A keyboard simulator of the same events lets developers test without the board.

**Open questions**

- [ ] What exactly does each pegboard sense (touch, peg presence, rotation angle), and how many boards connect at once?
- [ ] Target patient group first: adult stroke, children with cerebral palsy, or both?
- [ ] Hero names and village setting: keep the Indian village theme, or make it region-neutral?
- [ ] Which languages are needed for the first release?
- [ ] Clinic only, or home use as well, and does the therapist dashboard need cloud sync?
- [ ] Which clinical outcome measures should the pilot track (for example Box and Block Test, Nine-Hole Peg Test)?

## Sources

- [Kenney Particle Pack](https://kenney.nl/assets/particle-pack) · [Quaternius overview](https://gamefromscratch.com/quaternius-free-3d-assets/) · [Quaternius on OpenGameArt](https://opengameart.org/content/all-cc0-uploader-quaternius)
- [Poly Haven](https://polyhaven.com) and [FAQ](https://polyhaven.com/faq) · [ambientCG](https://ambientcg.com)
- [itch.io CC0 low-poly](https://itch.io/game-assets/assets-cc0/tag-low-poly) · [itch.io CC0 2D](https://itch.io/game-assets/assets-cc0/tag-2d) · [OpenGameArt CC0](https://opengameart.org/content/cc0-public-domain) · [awesome-cc0](https://www.github.com/madjin/awesome-cc0)
- [Mixamo to glTF workflow](https://www.donmccurdy.com/2017/11/06/creating-animated-gltf-characters-with-mixamo-and-blender) · [Mixamo to one GLB for Godot](https://forum.godotengine.org/t/mixamo-character-separate-animation-files-one-glb-for-godot-without-blender/145654) · [Mixamo Animation Batcher](https://godotengine.org/asset-library/asset/5079) · [Free character animations](https://rancidmilk.itch.io/free-character-animations)
