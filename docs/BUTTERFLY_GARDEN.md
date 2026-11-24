# Butterfly Garden

Open **Library → Attention → Butterfly Garden → Play**. Match the reference butterfly by tapping or clicking a butterfly in the garden. A correct match lands on a flower, awards 100 points once, and enables Next. Incorrect choices give a gentle hint without penalties. There is no timer.

- Easy: 2 stationary choices, 5 rounds.
- Medium: 3 slowly moving choices, 7 rounds.
- Hard: 4 slowly moving choices, 9 rounds.
- Reduced motion freezes wing and flower animation and keeps choices stationary. Correct matches move directly to their flower.
- Pause/Resume, Finish, Library, shared mute, Escape and F11 are supported. Losing application focus pauses play.
- Best scores and reduced-motion preference are stored in `user://butterfly_garden.cfg`.

The game is a visual-attention practice activity; gameplay scores are not clinical outcome measures. Real IR-frame testing is still required on the target TV. Physical touch events are handled separately from mouse-emulated touch to prevent duplicate choices. Buttons also support mouse and keyboard focus.

## Art and animation

Created with the built-in OpenAI image-generation tool. Original generated PNGs are preserved in `assets/images/butterfly_garden/`:

- `garden.png`: painted garden background.
- `butterflies.png`: transparent 4-row sheet, four wing poses per butterfly. Atlas bounds account for the generated artwork's nonuniform horizontal spacing; transparent margins keep a stable frame canvas.
- `flowers.png`: transparent 4-column, 2-row sheet for flower sway and pollen celebration.

Godot `AnimatedSprite2D` and `SpriteFrames` animate the actual atlas frames. Position interpolation moves the butterfly to a flower; wings are not simulated with scaling. Names describe game artwork, not a biological identification guide. Confirmation audio reuses the project's existing `confirmation_001.ogg` (see ASSET_CREDITS.md).

## Validation

Run with Godot 4.6:

```powershell
& D:/Godot_v4.6.2-stable_win64_console.exe --headless --path D:/sitar --script res://tests/test_butterfly_garden.gd
& D:/Godot_v4.6.2-stable_win64_console.exe --headless --path D:/sitar --script res://tests/test_navigation.gd
& D:/Godot_v4.6.2-stable_win64_console.exe --path D:/sitar --script res://tests/preview_butterfly_garden.gd
```

The preview script saves menu, game, match and library screenshots under `.test-data/`. Automated tests cover all levels, injected physical-touch events, wrong choices, duplicate scoring prevention, landing, pause/resume, session completion, reduced motion, sprite frames and library routing. They do not validate physical hardware tracking.

## Generation prompts

1. Production 2D game sprite sheet, transparent background, exactly 4 columns and 4 rows, 16 equal square cells in a square image. Each row is a four-frame looping wing flap animation of ONE butterfly seen from directly above, head pointing up. Row 1 amber orange monarch with black veins and white dotted borders. Row 2 sky blue butterfly with rounded broad wings, dark blue border and two large ivory circular spots. Row 3 violet swallowtail with clearly pointed tails and pale lavender stripes. Row 4 golden yellow butterfly with scalloped wings and brown crescent markings. In every row columns show: wings fully spread, wings halfway folded upward (narrower), wings nearly closed upright (very narrow), wings halfway reopening. Same centered body location and same scale across all frames. Each butterfly entirely inside its cell with 15 percent clear transparent margin, no cell borders, no labels, no text, no flowers, no cast shadows. Premium hand-painted 2D game sprites, crisp detailed wing veins, vibrant natural colors, adult botanical illustration, soft shading. Frames must genuinely differ in wing pose; not just four identical butterflies. Precisely aligned equal grid.

2. Production 2D game sprite sheet with transparent background. Square image, exactly 4 columns x 2 rows of equal rectangular cells. Eight animation frames total. Row 1 four sequential frames of one pink cosmos flower gently swaying left, upright, right, upright, flower head and short green stem and leaves, consistent base pivot centered near bottom of each cell. Row 2 four sequential frames of a small golden pollen celebration burst: a tight group of pollen dots, expanding ring of tiny botanical sparkles, wider softer sparkles, sparse fading dots. Each frame isolated entirely inside its own cell with 15 percent transparent padding. Elegant polished hand-painted 2D sprite art matching a botanical butterfly garden, warm pink petals and green foliage, no butterflies, no labels, no grid lines, no text, no background.

3. High quality hand-painted 2D landscape background for a relaxing touchscreen butterfly garden game, landscape 16:9 composition. Warm morning sunlight, pale turquoise sky across upper fifth, distant soft sage hills, a tranquil meadow across the broad center with extremely low contrast soft pale mint grass and large uncluttered open space where interactive butterfly sprites will be placed. Beautiful detailed botanical border only around bottom edge and outer corners: pink cosmos, ivory daisies, lavender, ferns, rounded leaves, a few smooth stones, tiny winding garden path at bottom. Elegant adult illustrated storybook aesthetic, crisp foreground and subtle depth through painted layers, rich harmonious natural colors, sophisticated polished game art, NOT 3D render, no butterflies, no animals, no text, no buttons, no UI, no people. Center 75 percent stays light and quiet for visual clarity. No strong focal object in center.

