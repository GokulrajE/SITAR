# Dosa Master – Attention Training Game
## Complete Godot 4.6 Game Implementation Prompt

Act as an expert Godot 4.6 game developer specializing in GDScript, 2D game architecture, sprite animation, touchscreen interaction, and rehabilitation-based attention games.

Develop a polished, responsive 2D dosa cooking attention game using the provided sprites and animation sprite sheets.

The game must support multiple dosas cooking simultaneously on one large tawa, with each dosa having an independent cooking cycle.

The primary objective is to identify and pick up each dosa during its perfectly cooked stage, before it becomes overcooked or burnt.

## 1. Main Game Concept

Create a continuous attention-training game where:

- A large traditional dosa tawa occupies the central gameplay area.
- The first dosa automatically starts cooking when gameplay begins.
- After a configurable delay, another dosa starts cooking at a different position.
- New dosas continue appearing while previous dosas are still cooking.
- Each dosa independently progresses through different cooking stages.
- Multiple dosas can be raw, partially cooked, ready, or burnt at the same time.
- The player must observe all active dosas and select the ones that are perfectly cooked.
- Selecting a dosa removes only that dosa, without affecting other active dosas.
- Burnt dosas automatically crumble and disappear.
- Empty positions are reused for new dosas.

**Important:** Do not implement sequential gameplay where the next dosa appears only after the previous one finishes. All dosa cooking cycles must overlap.

## 2. Godot Scene Architecture

Create the following reusable scenes:

### MainGame.tscn
```text
MainGame (Control)
├── Background (TextureRect)
├── GameArea (Control)
│   ├── Tawa (TextureRect)
│   ├── DosaContainer (Node2D)
│   └── EffectsContainer (Node2D)
├── UI (CanvasLayer)
│   ├── TopBar (Control)
│   │   ├── ScoreLabel
│   │   ├── TimerLabel
│   │   └── PauseButton
│   ├── FeedbackLabel
│   └── GameOverPanel
└── AudioManager
```

### Dosa.tscn
```text
Dosa (Area2D)
├── VisualRoot (Node2D)
│   ├── DosaSprite (AnimatedSprite2D)
│   ├── SteamSprite (AnimatedSprite2D)
│   ├── SmokeSprite (AnimatedSprite2D)
│   └── DestructionSprite (AnimatedSprite2D)
├── CollisionShape2D
└── AnimationPlayer
```

Create these scripts:

- `main_game.gd` – Controls the overall game lifecycle.
- `dosa.gd` – Handles individual dosa cooking, animation, and selection.
- `dosa_spawner.gd` – Controls staggered spawning and available positions.
- `game_manager.gd` – Handles scoring, difficulty, and game states.
- `sprite_loader.gd` – Loads sprite sheets and creates SpriteFrames.
- `audio_manager.gd` – Handles sound effects and audio settings.

Use signals for communication between individual dosas and the main game.

## 3. Sprite Sheet Integration

Use the supplied sprite assets.

| Asset | Purpose | Animation |
|---|---|---|
| `tawa.png` | Large stationary tawa | Static |
| `dosa_pouring.png` | Batter pouring and spreading | 16 frames |
| `dosa_cooking.png` | Raw to perfectly cooked | 16 frames |
| `dosa_burning.png` | Ready to completely burnt | 16 frames |
| `dosa_destroy.png` | Crumbling and disappearing | 16 frames |
| `steam.png` | Evaporation | 16 frames, looping |
| `smoke.png` | Burning smoke | 16 frames, looping |
| `dosa_pickup.png` | Spatula pickup | 16 frames |

Assume each animation sprite sheet contains 4 columns and 4 rows.

Implementation requirements:

- Load the actual PNG textures using Godot resources.
- Split sprite sheets into individual frames using `AtlasTexture` or `SpriteFrames`.
- Use `AnimatedSprite2D` for playback.
- Ensure animations play in the correct frame order.
- Use the same sprite dimensions and alignment across cooking stages.
- Do not stretch individual frames inconsistently.
- Keep the dosa centered when transitioning between animations.
- Steam and smoke must render above the dosa.
- The tawa must remain below all dosas.
- Keep the final cooking frame visible until the next stage begins.
- Use transparent sprites without unwanted backgrounds.

Do not generate placeholder circles or procedural dosa artwork when valid sprite assets are provided.

If a required sprite file is missing, report the missing file clearly and use a temporary fallback without breaking gameplay.

## 4. Individual Dosa State Machine

Implement the following states:

```gdscript
enum DosaState {
    POURING,
    RAW,
    COOKING,
    ALMOST_READY,
    READY,
    OVERCOOKED,
    BURNT,
    DESTROYING,
    PICKED
}
```

Each dosa must maintain its own:

- Unique instance ID.
- Spawn position.
- Current cooking state.
- Cooking elapsed time.
- Cooking duration.
- Ready window duration.
- Current animation.
- Steam and smoke effects.
- Selection status.
- Removal status.

State progression:

```text
POURING
   ↓
RAW
   ↓
COOKING
   ↓
ALMOST_READY
   ↓
READY ────────────→ Successful Pickup
   ↓
OVERCOOKED ───────→ Late Pickup
   ↓
BURNT
   ↓
DESTROYING
   ↓
REMOVED
```

Selecting a dosa during RAW, COOKING, or ALMOST_READY must register an early pickup.

Once a dosa is picked, stop its cooking process and play its pickup animation.

Prevent repeated clicks or duplicate scoring on the same dosa.

## 5. Continuous Cooking Animation Logic

Cooking must be based on elapsed time rather than simply waiting for animations to finish.

Use a configurable cooking timeline.

Example:

| Stage | Duration |
|---|---:|
| Pouring | 1.0 s |
| Raw | 1.0 s |
| Cooking | 2.0 s |
| Almost Ready | 1.0 s |
| Ready | 1.5 s |
| Overcooked | 1.5 s |
| Burnt | 1.0 s |
| Destruction | 0.8 s |

These durations are defaults, not fixed values.

Every dosa must have its own timing configuration.

Use `_process(delta)` or a dedicated timer to update the elapsed cooking time.

Calculate the correct animation frame using normalized stage progress:

```gdscript
var progress: float = clamp(
    stage_elapsed / stage_duration,
    0.0,
    1.0
)

var frame_index: int = mini(
    int(progress * frame_count),
    frame_count - 1
)
```

The animation should progress smoothly from white batter to golden brown, then dark brown and black.

Ensure no visible flickering or restarting between stages.

Use the cooking sprite sheet across RAW, COOKING, ALMOST_READY, and READY.

Use the burning sprite sheet for OVERCOOKED and BURNT.

Do not reset the visual frame to raw batter when transitioning from READY to OVERCOOKED.

## 6. Staggered Multi-Dosa Spawning

Create a `DosaSpawner` system.

The spawner must:

- Start the first dosa immediately.
- Spawn the next dosa after a configurable interval.
- Continue spawning while existing dosas are cooking.
- Randomize intervals within configured limits.
- Never exceed the maximum active dosa count.
- Never spawn on top of an existing dosa.
- Reuse positions after dosas are removed.
- Stop spawning when the game is paused or completed.

Example:

```text
Time 0.0s  → Dosa A starts
Time 2.0s  → Dosa B starts
Time 4.5s  → Dosa C starts
Time 6.0s  → Dosa A becomes ready
Time 7.0s  → Dosa D starts
Time 8.5s  → Dosa B becomes ready
Time 9.0s  → Dosa A burns if ignored
```

Use predefined valid spawn positions distributed across the tawa.

The number of available positions should be configurable, supporting up to six dosas.

Validate that each position lies within the visible cooking surface and that dosa sprites do not overlap.

When a dosa is removed, immediately release its occupied position.

If all positions are occupied, defer spawning until one becomes free.

## 7. Player Interaction

Support both:

- Mouse clicks on desktop.
- Single-finger touchscreen taps.

Use `Area2D` input detection or equivalent Godot input handling.

When the player selects a dosa:

**Early Selection**
- Register an early attempt.
- Display "Too Early".
- Play a gentle incorrect feedback effect.
- Remove the selected dosa with an appropriate animation.

**Perfect Selection**
- Register a successful attempt.
- Display "Perfect!".
- Play the spatula pickup animation.
- Add points.
- Remove the selected dosa.

**Late Selection**
- Register a late attempt.
- Display "Too Late".
- Play an appropriate feedback animation.
- Remove the selected dosa.

**Burnt Dosa**
- Automatically register a missed dosa when its pickup window has passed and it reaches the destruction stage without selection.
- Play burning and destruction animations.
- Remove the dosa automatically.

Selection must affect only the selected dosa.

Avoid double processing mouse and touch events generated by the same physical tap.

Use generous but non-overlapping hitboxes suitable for rehabilitation users.

## 8. Scoring and Attention Metrics

Implement configurable scoring:

| Player action | Score |
|---|---:|
| Perfect pickup | +10 |
| Early pickup | 0 |
| Late pickup | 0 |
| Burnt / missed | 0 |

Track:

- Total dosas spawned.
- Total successful pickups.
- Early pickups.
- Late pickups.
- Missed dosas.
- Accuracy percentage.
- Average reaction time.
- Best reaction time.
- Maximum simultaneous active dosas.

Accuracy formula:

```text
Accuracy (%) =
Successful Pickups / Total Resolved Dosas × 100
```

Count only resolved dosas in the denominator, not dosas still cooking.

Reaction time should be measured relative to the beginning of the READY state.

Store results in a structured dictionary that can later be exported to CSV or JSON.

## 9. Difficulty System

Create three configurable difficulty levels.

| Parameter | Easy | Medium | Hard |
|---|---|---|---|
| Maximum active dosas | 2 | 4 | 6 |
| Spawn interval | 3–5 s | 2–3 s | 1–2 s |
| Time until ready | 7 s | 6 s | 5 s |
| Ready window | 2.5 s | 1.8 s | 1.2 s |
| Cooking speed variation | Low | Medium | High |

Allow the game manager to modify these values without changing individual dosa scripts.

Prevent unavoidable failures by avoiding simultaneous ready-window conflicts that exceed the player's configured response capacity.

Do not use rapid flashing effects or distracting visual indicators.

## 10. Steam, Smoke, and Destruction Effects

Implement separate animated effects for every dosa.

**Steam**
- Begins during cooking.
- Uses the `steam.png` sprite sheet.
- Loops continuously.
- Gradually fades near the READY stage.

**Smoke**
- Begins during OVERCOOKED.
- Uses the `smoke.png` sprite sheet.
- Increases in opacity during BURNT.
- Stops after the dosa disappears.

**Destruction**
- Begins when the dosa reaches DESTROYING.
- Uses `dosa_destroy.png`.
- Plays once.
- Removes the dosa after the animation finishes.

Effects must remain attached to the correct dosa and must not interfere with other dosas.

## 11. Game Lifecycle

Implement these states:

```gdscript
enum GameState {
    WAITING,
    STARTING,
    PLAYING,
    PAUSED,
    FINISHING,
    GAME_OVER
}
```

Game flow:

```text
START
  ↓
Initialize Game
  ↓
Spawn First Dosa
  ↓
PLAYING
  ├── Spawn Additional Dosas
  ├── Update Independent Cooking
  ├── Handle Player Selections
  ├── Update Score
  └── Remove Completed Dosas
  ↓
Session Timer Ends
  ↓
Stop New Spawns
  ↓
Resolve or Cancel Remaining Dosas
  ↓
Display Results
  ↓
Restart / Exit
```
## Assets
res://assets/images/dosa_cooking_game_transparent_pngs
res://assets/images/dosa_game_background_stove_fire_pngs

Provide a configurable session duration, defaulting to 120 seconds.

When the timer ends, stop spawning and allow a short completion period for existing dosas. Do not count forcibly cancelled dosas as missed.

Pause must freeze cooking progress, spawning, animations, and the session timer consistently.

## 12. Responsive UI

Target a base resolution of 1280×800 while supporting other desktop and touchscreen resolutions.

- Use Godot Control containers and anchors for UI.
- Keep the tawa centered.
- Scale the game area proportionally.
- Maintain correct dosa spawn positions after resizing.
- Keep the top score and timer readable.
- Provide large touch-friendly pause and restart buttons.
- Avoid unnecessary text inside the cooking area.
- Use soft, warm colors and rounded UI panels.
- Keep animations smooth and visually clear.

## 13. Code Quality Requirements

- Use Godot 4.6-compatible GDScript.
- Use typed variables and explicit return types where appropriate.
- Avoid hardcoded node paths where exported references are more suitable.
- Avoid unnecessary per-frame allocations.
- Use signals for event communication.
- Ensure all timers and animations respect pause.
- Free removed dosa nodes safely using `queue_free()`.
- Disconnect or clean up signals when necessary.
- Avoid spawning duplicate instances.
- Prevent input processing after a dosa has been selected.
- Handle missing sprites gracefully.
- Avoid deprecated Godot APIs.

## 14. Testing and Validation

Verify the following scenarios:

1. The first dosa starts immediately.
2. Additional dosas appear before previous dosas finish.
3. Every dosa cooks independently.
4. Multiple dosas display different cooking stages simultaneously.
5. Picking one dosa does not affect the others.
6. Selecting too early produces early feedback.
7. Selecting during READY produces successful feedback.
8. Selecting after READY produces late feedback.
9. Burnt dosas disappear automatically.
10. Empty spawn positions are reused.
11. Smoke and steam animations follow their respective dosas.
12. Pausing freezes all gameplay consistently.
13. Restarting resets the complete game state.
14. Mouse and touchscreen controls both work.
15. Scoring and accuracy calculations are correct.
16. The game works at multiple screen resolutions.
17. No overlapping dosas, duplicate scoring, or invalid node errors occur.

## 15. Expected Deliverables

Generate:

1. Complete Godot scene hierarchy.
2. All required `.gd` scripts.
3. Sprite sheet loading and animation configuration.
4. Reusable dosa scene.
5. Independent cooking state machine.
6. Staggered spawning system.
7. Mouse and touchscreen input handling.
8. Steam, smoke, pickup, and destruction animations.
9. Scoring and attention metrics.
10. Responsive game UI.
11. Difficulty configuration.
12. Testing instructions.

Inspect the existing Godot project structure before implementation. Reuse existing architecture, UI conventions, and asset paths where possible. Do not overwrite unrelated scenes or scripts.

**Final requirement:** Deliver a fully functional, continuous multi-dosa attention game. Multiple dosas must cook independently and simultaneously, with smooth sprite-based transitions and accurate player selection detection. Prioritize reliable gameplay, clear cooking-state visuals, and accessible interaction over unnecessary visual effects.