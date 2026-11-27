# SITAR Play Studio

Open `project.godot` in Godot 4.6 and press **F5**. Everything is laid out on a 1920 × 1080 canvas and plays on a TV with an infrared touch frame, a mouse or a touchscreen. The original hand-tracking experiment is preserved under `games/hand_tracking/`.

## Game library

The library has two steps. First, six skill rows: Attention, Memory, Perception, Movement, Numbers and Pegboard. A tap shows only that skill's games as moving picture cards. Home from a game returns to the same skill. The gear opens the touch test, full screen and credits.

| Skill | Games |
| --- | --- |
| Attention | Focus Finder, Dosa Master |
| Memory | Memory Meadow, Melody Steps |
| Perception | Listen & Discover, Connect & Draw |
| Movement | Ocean Rescue, Seed Quest |
| Numbers | Quick Sums, Market Basket |
| Pegboard | Shape Match, Shape Spots, Hand & Shape |

Each game opens its own scene. The launcher is `scenes/ui/launcher.tscn` (`scripts/shared/launcher.gd`, rows in `category_tile.gd`, cards in `game_card.gd`, neon theme in `assets/themes/neon_theme.tres`).

## The same frame in every game

`scripts/shared/game_shell.gd` gives every game the same controls, so they are learnt once. Each game keeps its own art behind it.

- **Start screen:** the game's name, one card per level with a short note, one big Start button.
- **While playing:** Home at the top left, Pause and Sound at the top right, and one status pill (for example "Served 3 of 10 • 1:42").
- **Pause:** Continue or End game. Escape and losing window focus also pause.
- **Results:** up to three stars, one line of figures, then Next level, Play again or Levels.

Rounds move on by themselves; there are no Next buttons. Short messages ("Not quite. Try again.") fade on their own instead of paragraphs of instructions. A game uses the shell by creating it, setting `title`, `levels`, `notes` and `accent`, and connecting `start_pressed`, `pause_changed` and `stop_pressed`; it calls `finish(stars, headline, line)` at the end.

## Games

| Game | Level 1 | Level 2 | Level 3 |
| --- | --- | --- | --- |
| Focus Finder | 5 objects, 6 choices, 90 s | 8 objects, 9 choices, 60 s | 12 look-alikes, 45 s; errors cost 3 s |
| Dosa Master | 6 orders, 2 pans | 10 orders, 4 pans | 14 orders, 6 pans |
| Memory Meadow | 4 pairs, no clock | 6 pairs, 180 s | 8 pairs, 120 s |
| Melody Steps | 4 notes, slow | 6 notes | 8 notes, fast |
| Listen & Discover | 2 pictures, 4 sounds | 3 pictures, 6 sounds | 4 similar sounds, 9 rounds, 3 s clips |
| Connect & Draw | Connect: tap numbered dots in order | Copy: draw beside the guide | From memory: the guide hides after 4 s |
| Shape Match | Match | Shape only | Clues, Remember, Sequence (5 levels) |
| Ocean Rescue | 8 items, 2 buoys, 90 s | 12 items, 4 buoys, 80 s | 16 items, 6 buoys, 70 s |
| Seed Quest | 10 seeds, 75 s | 14 seeds, 70 s | 18 seeds, 65 s, heavier drone traffic |
| Quick Sums | Up to 20 | Up to 100, and times | Two steps, like 6 × 4 − 9 |
| Market Basket | Add two prices | Prices and quantities | Pay with a note, count the change |
| Shape Spots | 8 spots, one at a time | 10 spots in pairs | 10 spots, each moves on after 8 s |
| Hand & Shape | 12 bubbles, 2 at a time, slow | 14 bubbles, 3 at a time | 16 bubbles, 4 at a time, faster |

- **Dosa Master:** a ring around each pan fills while the dosa cooks, glows green when it is ready and turns red as it burns. Perfect and slightly late dosas serve a customer; early ones are too soft and do not. The round ends when every order is served or after 2½ minutes.
- **Memory Meadow, Melody Steps, Focus Finder:** one engine (`games/cognitive/scripts/cognitive_hub.gd`) and three scenes that set `game`. Each has its own painted world and host (Moti, Nila, Tashi). Two touches within 0.22 s and 120 px count as one, because a finger can break the infrared beams twice.
- **Listen & Discover:** the sound plays by itself; the big speaker replays it. Hard puts similar sounds side by side (guitar and piano, rain and waves).
- **Connect & Draw:** lines and dots only, from 28 patterns. A copy is checked automatically once enough dots are placed; position and size may differ, shape and order may not. A wrong copy clears itself.
- **Quick Sums and Market Basket:** ten questions with 3 or 4 large answers; wrong answers fade, and the right one moves on. One script (`games/numbers/scripts/numbers.gd`) with a chalkboard and a market stall.
- **Pegboard games:** physical boards, each carrying an object, stand on the screen. Nothing about the boards is fixed in the code: **"Record boards"** (on each pegboard game's start screen) records every board fresh. Stand a board in the circle; once its three legs are still, tap the object on it, and that leg pattern is saved for that object. Record again whenever boards or objects change; "Start fresh" forgets all recordings, and tapping a recorded card removes just that one. Up to three boards; a board too similar to one already recorded is refused, because the games could confuse them. There is no rest area: a board can be put down anywhere. Once it has stood still for 1.5 s it is resting and never counts as a wrong answer.
  - **Shape Match:** left to right, the shape to find, the round detection pad, then Pip. Boards are read only on the pad; the rest of the screen is ignored. Session summaries are saved for the therapist.
  - **Shape Spots:** a spot with an object appears somewhere on the screen and waits; stand that board on it. A wrong board counts once. After 10 s the spot shows the object's name. New spots appear away from boards that are standing on the screen.
  - **Hand & Shape:** bubbles drift under water. Tap hand bubbles with a finger; catch object bubbles by standing that board on them (a board can also wait for a bubble to drift under it). Bubbles bounce off resting boards that do not match them.
- **Ocean Rescue and Seed Quest:** real-time 3D. Tap or drag to steer. In Seed Quest, double-tap or Pulse clears nearby drones.

## Saved data

Best scores only: `user://cognitive_progress.cfg`, `adventure_progress.cfg`, `ocean_progress.cfg`, `sensory_progress.cfg`, `numbers_progress.cfg`, `peg_targets_progress.cfg`, plus the pegboard setup and session log. No personal or medical data is collected. Scores measure game performance, not clinical improvement; these games are practice activities, not validated medical treatments.

## Project folders

- `games/<game>/scenes` and `scripts`: one folder per game.
- `scenes/ui`, `scripts/shared`: launcher, game shell, touch helpers, shared effects.
- `scenes/environments`: the three night worlds of Seed Quest.
- `assets`: models, audio, fonts, images, shaders and themes. Sources and licenses: `docs/ASSET_CREDITS.md`, sounds: `docs/SENSORY_GAMES.md`.
- `tests`: regression checks (`test_*.gd`, run headless) and capture scripts (`capture_*.gd`, need a graphics-capable Godot).

## Verification

```
Godot --headless --path D:/sitar --script tests/test_navigation.gd
Godot --headless --path D:/sitar --script tests/test_sensory.gd
Godot --path D:/sitar --script tests/capture_games.gd -- quick_sums dosa
```

`test_navigation.gd` opens all fourteen games from the library and checks the shell in each. `test_sensory.gd` plays Listen & Discover, Connect & Draw, both calculation games and Dosa Master through the shell. The other `test_*.gd` files cover the cognitive games, Seed Quest, Ocean Rescue and the pegboard games (`test_peg_match.gd`, `test_peg_targets.gd`, driven by simulated board contacts). `capture_games.gd` saves start and play screenshots to `user://shots/`. Physical IR-frame behaviour and sound balance still need testing on the TV.
