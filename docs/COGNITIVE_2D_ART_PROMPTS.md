# Memory Meadow, Melody Steps and Focus Finder: 2D art prompts

70 prompts. Each one is complete: copy the whole block into the image generator and
attach the pictures named above it. Save the result under the given path inside
`assets/images/cognitive/`.

## Look

Realistic painted nature, the same look as the Butterfly Garden pictures. Each game
has its own world and its own host with real expressions:

| Game | World | Host | What the player touches |
|---|---|---|---|
| Memory Meadow | flower meadow: morning, golden afternoon, moonlight | Moti, baby elephant | closed flowers that open and show an object |
| Melody Steps | stream: sunny, after rain, lantern evening | Nila, peacock | six animal musicians on stepping stones |
| Focus Finder | forest: clearing, autumn, bamboo dawn | Tashi, red panda | objects on wooden discs; the target is inside a magnifying glass |

## Rules for good sheets

These come from checking the Pip sheets and the butterfly sheets already in the project.

1. **One scale for the whole sheet.** In `pip_cheer_4x4.png` every frame was rescaled to
   the same height, so Pip's body is 270 px wide at the start and 208 px when the star
   goes up. If frames are cut out or cleaned up afterwards, move them, but never resize them
   one by one. Line frames up by the feet.
2. **No glow, haze or light rays in sprites.** They do not survive background removal:
   `vfx_correct_burst_4x4.png` has a grey disc with a checkerboard in it, and its second
   frame is cut off. The game adds glow itself and builds celebrations from the
   solid pieces in `particles_4x4.png`. That is also smoother than 16 drawn frames.
3. **Small motion belongs to the game.** Breathing, hopping, swaying, spinning and fading of
   objects are done by the game at 60 frames a second. Sheets are for changes of pose and face.
4. **Removal colour.** Each prompt names a fallback colour that does not occur in that picture.
   Use that one and not always magenta, or pink flowers get holes.
5. **Check each sheet:** exact canvas size; 16 cells; same head size in every cell; feet on one
   line; nothing cut off; frame 16 fits frame 1; transparent corners; no text. Redo it if one fails.
6. **If a sheet drifts,** make its 16 frames in two halves (frames 1-8, then 9-16 with the first
   half attached) and put them together on the 2048 x 2048 canvas.

## Try these 6 first

Prompts 1, 2, 5, 8, 24 and 36 (style key, Moti reference, idle, happy, meadow, lotus).
Put Moti and an open lotus on the meadow and look at them together. If the look is right,
continue; if not, change the style sentence once and use the new one everywhere.

## Speeds

| Kind | Speed |
|---|---|
| idle, think, listen, search, encourage | 10 frames a second |
| happy, found, dance, cheer, conduct, water | 12 frames a second |
| flower opening | 20 frames a second (0.8 s), backwards to close |
| musician playing | 8 frames in 0.6 s, or faster on higher levels |
| ambient life | 8 frames a second; still when "Reduced motion" is on |

`nila_cheer_4x4.png` has a smaller body so the open tail fits. The game draws that sheet
1.6 times larger so Nila stays the same size.

## Batch 1: enough to play all three games in 2D (42 pictures)

| # | File | What it is | Use in game |
|---|---|---|---|
| 1 | `style_key.png` | style key picture | reference only, not loaded |
| 2 | `meadow/moti_reference.png` | Moti, character reference | reference only, not loaded |
| 3 | `melody/nila_reference.png` | Nila, character reference | reference only, not loaded |
| 4 | `focus/tashi_reference.png` | Tashi, character reference | reference only, not loaded |
| 5 | `meadow/moti_idle_4x4.png` | Moti, calm waiting | waiting, menu, pause |
| 6 | `meadow/moti_think_4x4.png` | Moti, remembering with the player | one card is open |
| 8 | `meadow/moti_happy_4x4.png` | Moti, happy at a matched pair | a pair is found |
| 10 | `meadow/moti_encourage_4x4.png` | Moti, kind encouragement after a miss | two cards differ |
| 11 | `meadow/moti_cheer_4x4.png` | Moti, level finished | level complete |
| 12 | `melody/nila_idle_4x4.png` | Nila, calm waiting | waiting, menu, pause |
| 13 | `melody/nila_conduct_4x4.png` | Nila, 'watch and listen' | the melody plays |
| 14 | `melody/nila_listen_4x4.png` | Nila, 'your turn' | player repeats |
| 15 | `melody/nila_happy_4x4.png` | Nila, happy at a correct step sequence | sequence correct |
| 16 | `melody/nila_encourage_4x4.png` | Nila, kind encouragement after a wrong step | sequence repeats |
| 17 | `melody/nila_cheer_4x4.png` | Nila, level finished, opening the tail | level complete |
| 18 | `focus/tashi_idle_4x4.png` | Tashi, calm waiting | waiting, menu, pause |
| 19 | `focus/tashi_search_4x4.png` | Tashi, searching with the magnifying glass | player is searching |
| 20 | `focus/tashi_found_4x4.png` | Tashi, happy at a found object | object found |
| 22 | `focus/tashi_encourage_4x4.png` | Tashi, kind encouragement after a miss | wrong object |
| 23 | `focus/tashi_cheer_4x4.png` | Tashi, level finished | level complete |
| 24 | `meadow/bg_meadow_1.png` | Memory Meadow, level 1, spring morning | level 1 |
| 27 | `melody/bg_stream_1.png` | Melody Steps, level 1, sunny stream | level 1 |
| 30 | `focus/bg_forest_1.png` | Focus Finder, level 1, bright forest clearing | level 1 |
| 36 | `meadow/cover_lotus_4x4.png` | lotus opening | hidden card |
| 39 | `melody/musicians_reference.png` | the six musicians, reference | reference only, not loaded |
| 40 | `melody/robin_4x4.png` | robin, idle, play and happy | plays its note |
| 41 | `melody/frog_4x4.png` | frog, idle, play and happy | plays its note |
| 42 | `melody/owl_4x4.png` | owl, idle, play and happy | plays its note |
| 43 | `melody/duckling_4x4.png` | duckling, idle, play and happy | plays its note |
| 44 | `melody/squirrel_4x4.png` | squirrel, idle, play and happy | plays its note |
| 45 | `melody/rabbit_4x4.png` | rabbit, idle, play and happy | plays its note |
| 46 | `melody/stones.png` | six stepping stones | under each musician |
| 47 | `focus/lens_frame.png` | large magnifying glass that holds the target | holds the object to find |
| 48 | `focus/holder_wood.png` | wooden disc under each choice | under each choice |
| 50 | `objects/fruits_4x4.png` | fruits and vegetables | both games |
| 51 | `objects/home_4x4.png` | familiar household things | both games |
| 52 | `objects/nature_4x4.png` | nature finds | both games |
| 61 | `shared/particles_4x4.png` | particles for all effects | all celebrations |
| 62 | `shared/ui_bar.png` | top bar | all three games |
| 63 | `shared/ui_panel.png` | result and menu panel | all three games |
| 64 | `shared/ui_buttons.png` | three buttons | all three games |
| 66 | `shared/ui_icons_4x4.png` | icons | all three games |

## Batch 2: more variety (28 pictures)

| # | File | What it is | Use in game |
|---|---|---|---|
| 7 | `meadow/moti_water_4x4.png` | Moti, watering the flowers | new board grows in |
| 9 | `meadow/moti_dance_4x4.png` | Moti, second celebration, for variety | alternates with happy |
| 21 | `focus/tashi_dance_4x4.png` | Tashi, second celebration, for variety | alternates with found |
| 25 | `meadow/bg_meadow_2.png` | Memory Meadow, level 2, golden afternoon | level 2 |
| 26 | `meadow/bg_meadow_3.png` | Memory Meadow, level 3, moonlit evening | level 3 |
| 28 | `melody/bg_stream_2.png` | Melody Steps, level 2, after the rain | level 2 |
| 29 | `melody/bg_stream_3.png` | Melody Steps, level 3, lantern evening | level 3 |
| 31 | `focus/bg_forest_2.png` | Focus Finder, level 2, autumn forest | level 2 |
| 32 | `focus/bg_forest_3.png` | Focus Finder, level 3, misty bamboo dawn | level 3 |
| 33 | `meadow/fg_meadow.png` | foreground plants that sway in the wind | gentle sway, drawn by the game |
| 34 | `melody/fg_stream.png` | foreground plants that sway in the wind | gentle sway, drawn by the game |
| 35 | `focus/fg_forest.png` | foreground plants that sway in the wind | gentle sway, drawn by the game |
| 37 | `meadow/cover_marigold_4x4.png` | marigold opening | hidden card |
| 38 | `meadow/cover_hibiscus_4x4.png` | hibiscus opening | hidden card |
| 49 | `focus/holder_leaf.png` | leaf plate for variety | levels 2 and 3 |
| 53 | `objects/creatures_4x4.png` | small creatures | both games |
| 54 | `objects/music_4x4.png` | music and play | both games |
| 55 | `objects/travel_4x4.png` | travel and outdoors | both games |
| 56 | `objects/lookalike_a_4x4.png` | look-alikes for the hardest level | Focus Finder level 3 |
| 57 | `objects/lookalike_b_4x4.png` | look-alikes for the hardest level | Focus Finder level 3 |
| 58 | `meadow/ambient_4x4.png` | meadow life, 4 animations | small life at the edges |
| 59 | `melody/ambient_4x4.png` | stream life, 4 animations | small life at the edges |
| 60 | `focus/ambient_4x4.png` | forest life, 4 animations | small life at the edges |
| 65 | `shared/ui_card.png` | game card for the menu | all three games |
| 67 | `meadow/layout_reference.png` | Memory Meadow layout | reference only, not loaded |
| 68 | `melody/layout_reference.png` | Melody Steps layout | reference only, not loaded |
| 69 | `focus/layout_reference.png` | Focus Finder layout | reference only, not loaded |
| 70 | `shared/layout_menu.png` | menu layout | reference only, not loaded |

---

# Part A. Characters

Make these first. Everything else copies their style.

## 1. `style_key.png`: style key picture

*Attach: `garden.png` and `butterflies.png` from `assets/images/butterfly_garden/`.*

```
One painted key picture that sets the style for three games. Three original animal friends stand together in a sunny meadow beside a small stream at the edge of a forest: Moti, a gentle baby Asian elephant who tends a flower meadow. Soft warm-grey wrinkled skin with a faint pink tint on the ears, trunk tip and forehead, large rounded ears, short thick legs, tiny tail with a dark tuft, large kind brown eyes with long lashes, a few soft baby hairs on the head painted inside a crisp edge. Wears one small mustard-yellow cotton scarf tied at the neck, with nothing on the head; Nila, an elegant young Indian peacock who conducts music beside a stream. Deep royal-blue neck and breast with fine scale-like feathers, small crown of fan-tipped crest feathers, white patches above and below warm brown eyes, bronze and cream wings, folded green-gold train with a few eye spots, slim grey legs. Expression is shown by eyes, brow feathers, crest, beak, neck and wings. No clothes; Tashi, a curious young red panda who explores the forest. Rich rust-red fur, cream face with rust tear marks, white-edged rounded ears, dark chocolate legs and belly, thick ringed tail, bright dark eyes, small black nose. Wears one small olive canvas satchel across the body and carries a round brass magnifying glass with a wooden handle, clear and empty glass.
All three look at the viewer with warm, calm faces. Morning light, pink cosmos, lavender and daisies in the foreground, smooth stepping stones in the stream.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. Canvas 1920 x 1080, 16:9.
```

## 2. `meadow/moti_reference.png`: Moti, character reference

*Attach: `garden.png` and `butterflies.png` from `assets/images/butterfly_garden/` (style only).*

```
Character reference sheet of an original character: Moti, a gentle baby Asian elephant who tends a flower meadow. Soft warm-grey wrinkled skin with a faint pink tint on the ears, trunk tip and forehead, large rounded ears, short thick legs, tiny tail with a dark tuft, large kind brown eyes with long lashes, a few soft baby hairs on the head painted inside a crisp edge. Wears one small mustard-yellow cotton scarf tied at the neck, with nothing on the head.
Top row: four full-body views on one ground line at the same scale: front, three-quarter facing right, side facing right, back.
Bottom row: six head-and-shoulder expressions at the same scale: calm, curious, happy with closed smiling eyes, surprised and delighted, kind and encouraging, proud.
Friendly and dignified, suitable for adults and older people as well as children, not babyish.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. Plain white background. Canvas 2048 x 1536.
```

## 3. `melody/nila_reference.png`: Nila, character reference

*Attach: `garden.png` and `butterflies.png` from `assets/images/butterfly_garden/` (style only).*

```
Character reference sheet of an original character: Nila, an elegant young Indian peacock who conducts music beside a stream. Deep royal-blue neck and breast with fine scale-like feathers, small crown of fan-tipped crest feathers, white patches above and below warm brown eyes, bronze and cream wings, folded green-gold train with a few eye spots, slim grey legs. Expression is shown by eyes, brow feathers, crest, beak, neck and wings. No clothes.
Top row: four full-body views on one ground line at the same scale: front, three-quarter facing right, side facing right, back.
Bottom row: six head-and-shoulder expressions at the same scale: calm, curious, happy with closed smiling eyes, surprised and delighted, kind and encouraging, proud.
Friendly and dignified, suitable for adults and older people as well as children, not babyish.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. Plain white background. Canvas 2048 x 1536.
```

## 4. `focus/tashi_reference.png`: Tashi, character reference

*Attach: `garden.png` and `butterflies.png` from `assets/images/butterfly_garden/` (style only).*

```
Character reference sheet of an original character: Tashi, a curious young red panda who explores the forest. Rich rust-red fur, cream face with rust tear marks, white-edged rounded ears, dark chocolate legs and belly, thick ringed tail, bright dark eyes, small black nose. Wears one small olive canvas satchel across the body and carries a round brass magnifying glass with a wooden handle, clear and empty glass.
Top row: four full-body views on one ground line at the same scale: front, three-quarter facing right, side facing right, back.
Bottom row: six head-and-shoulder expressions at the same scale: calm, curious, happy with closed smiling eyes, surprised and delighted, kind and encouraging, proud.
Friendly and dignified, suitable for adults and older people as well as children, not babyish.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. Plain white background. Canvas 2048 x 1536.
```


### Moti, the Memory Meadow elephant

## 5. `meadow/moti_idle_4x4.png`: Moti, calm waiting

*Attach: `moti_reference.png`.*

```
2D sprite sheet. Use the attached Moti reference exactly: same face, proportions, markings, clothing and painting style.
The character: Moti, a gentle baby Asian elephant who tends a flower meadow. Soft warm-grey wrinkled skin with a faint pink tint on the ears, trunk tip and forehead, large rounded ears, short thick legs, tiny tail with a dark tuft, large kind brown eyes with long lashes, a few soft baby hairs on the head painted inside a crisp edge. Wears one small mustard-yellow cotton scarf tied at the neck, with nothing on the head.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Moti is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-4 a slow breath in, the chest rises 2 percent, ears drift slightly forward; 5-8 a slow breath out, ears drift back; 9-11 the eyes close and open softly; 12-14 the trunk tip curls and uncurls, the tail swings once; 15-16 settle back to frame 1.
Expression: calm, patient, soft smile.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 6. `meadow/moti_think_4x4.png`: Moti, remembering with the player

*Attach: `moti_reference.png`.*

```
2D sprite sheet. Use the attached Moti reference exactly: same face, proportions, markings, clothing and painting style.
The character: Moti, a gentle baby Asian elephant who tends a flower meadow. Soft warm-grey wrinkled skin with a faint pink tint on the ears, trunk tip and forehead, large rounded ears, short thick legs, tiny tail with a dark tuft, large kind brown eyes with long lashes, a few soft baby hairs on the head painted inside a crisp edge. Wears one small mustard-yellow cotton scarf tied at the neck, with nothing on the head.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Moti is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 the trunk tip rises to touch the chin; 4-7 the eyes look up to the right, the head tilts 6 degrees; 8-9 the eyes come back to the centre; 10-13 the eyes look up to the left, one ear lifts; 14-16 the trunk lowers and the head returns to frame 1.
Expression: curious and interested, gently raised brows.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 7. `meadow/moti_water_4x4.png`: Moti, watering the flowers

*Attach: `moti_reference.png`.*

```
2D sprite sheet. Use the attached Moti reference exactly: same face, proportions, markings, clothing and painting style.
The character: Moti, a gentle baby Asian elephant who tends a flower meadow. Soft warm-grey wrinkled skin with a faint pink tint on the ears, trunk tip and forehead, large rounded ears, short thick legs, tiny tail with a dark tuft, large kind brown eyes with long lashes, a few soft baby hairs on the head painted inside a crisp edge. Wears one small mustard-yellow cotton scarf tied at the neck, with nothing on the head.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Moti is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell. The watering can is small and stands beside the front foot in frame 1; character and can stay inside 450 px width.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 the trunk picks up a small copper watering can with no water in it yet; 4-6 lifts and tilts it to the right; 7-12 holds the tilt while five to eight solid, clearly painted round water drops fall from the spout in an even rhythm, eyes happy, body swaying gently; 13-14 tips the can back; 15-16 lowers it to its place beside the front foot, ending as in frame 1.
Expression: caring and content.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 8. `meadow/moti_happy_4x4.png`: Moti, happy at a matched pair

*Attach: `moti_reference.png`.*

```
2D sprite sheet. Use the attached Moti reference exactly: same face, proportions, markings, clothing and painting style.
The character: Moti, a gentle baby Asian elephant who tends a flower meadow. Soft warm-grey wrinkled skin with a faint pink tint on the ears, trunk tip and forehead, large rounded ears, short thick legs, tiny tail with a dark tuft, large kind brown eyes with long lashes, a few soft baby hairs on the head painted inside a crisp edge. Wears one small mustard-yellow cotton scarf tied at the neck, with nothing on the head.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Moti is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-2 a soft crouch, ears back; 3-6 the body rises, the front feet lift slightly and the trunk sweeps up in a graceful S-curve; 7-9 the top of the pose, eyes closed in smiling curves, ears wide; 10-12 the feet come down softly, ears flap once with follow-through; 13-16 a small happy sway left and right, back to frame 1.
Expression: delighted, warm open smile.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 9. `meadow/moti_dance_4x4.png`: Moti, second celebration, for variety

*Attach: `moti_reference.png`.*

```
2D sprite sheet. Use the attached Moti reference exactly: same face, proportions, markings, clothing and painting style.
The character: Moti, a gentle baby Asian elephant who tends a flower meadow. Soft warm-grey wrinkled skin with a faint pink tint on the ears, trunk tip and forehead, large rounded ears, short thick legs, tiny tail with a dark tuft, large kind brown eyes with long lashes, a few soft baby hairs on the head painted inside a crisp edge. Wears one small mustard-yellow cotton scarf tied at the neck, with nothing on the head.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Moti is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-4 the weight shifts to the left legs, the right front foot lifts, the trunk draws a slow circle; 5-8 the weight shifts to the right legs, the left front foot lifts, the trunk draws the circle the other way; 9-12 the same step left again with ears swinging; 13-16 a small bow of the head with the trunk curled in, then back to frame 1.
Expression: playful, joyful, graceful.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 10. `meadow/moti_encourage_4x4.png`: Moti, kind encouragement after a miss

*Attach: `moti_reference.png`.*

```
2D sprite sheet. Use the attached Moti reference exactly: same face, proportions, markings, clothing and painting style.
The character: Moti, a gentle baby Asian elephant who tends a flower meadow. Soft warm-grey wrinkled skin with a faint pink tint on the ears, trunk tip and forehead, large rounded ears, short thick legs, tiny tail with a dark tuft, large kind brown eyes with long lashes, a few soft baby hairs on the head painted inside a crisp edge. Wears one small mustard-yellow cotton scarf tied at the neck, with nothing on the head.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Moti is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 the brows lift in the middle, the ears relax, the head tilts 5 degrees; 4-7 a slow warm nod with a soft closed-mouth smile; 8-12 the trunk reaches gently to the right with an open, inviting curl and the eyes follow it; 13-16 the trunk returns, a second tiny nod, back to frame 1.
Expression: kind and reassuring, 'nearly, try again'.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 11. `meadow/moti_cheer_4x4.png`: Moti, level finished

*Attach: `moti_reference.png`.*

```
2D sprite sheet. Use the attached Moti reference exactly: same face, proportions, markings, clothing and painting style.
The character: Moti, a gentle baby Asian elephant who tends a flower meadow. Soft warm-grey wrinkled skin with a faint pink tint on the ears, trunk tip and forehead, large rounded ears, short thick legs, tiny tail with a dark tuft, large kind brown eyes with long lashes, a few soft baby hairs on the head painted inside a crisp edge. Wears one small mustard-yellow cotton scarf tied at the neck, with nothing on the head.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Moti is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: Moti holds one pink lotus flower, without leaves, in the trunk in every frame. 1-4 lift the lotus from chest height to above the head; 5-8 a slow proud sway to the left, eyes closed and smiling; 9-12 a slow proud sway to the right with ears open wide; 13-16 lower the lotus to the chest and bow the head, ending as in frame 1.
Expression: proud of the player, deeply happy.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```


### Nila, the Melody Steps peacock

## 12. `melody/nila_idle_4x4.png`: Nila, calm waiting

*Attach: `nila_reference.png`.*

```
2D sprite sheet. Use the attached Nila reference exactly: same face, proportions, markings, clothing and painting style.
The character: Nila, an elegant young Indian peacock who conducts music beside a stream. Deep royal-blue neck and breast with fine scale-like feathers, small crown of fan-tipped crest feathers, white patches above and below warm brown eyes, bronze and cream wings, folded green-gold train with a few eye spots, slim grey legs. Expression is shown by eyes, brow feathers, crest, beak, neck and wings. No clothes.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Nila is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 300 px tall, feet on the same line 48 px above the bottom of the cell. The folded train curves down and behind inside the cell; the whole bird stays inside 460 px width.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-5 a slow breath, the breast rises, the neck lengthens slightly; 6-8 breathe out; 9-10 a soft blink; 11-13 the head turns a little to the viewer and the crest feathers open slightly; 14-16 back to frame 1.
Expression: serene and friendly.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 13. `melody/nila_conduct_4x4.png`: Nila, 'watch and listen'

*Attach: `nila_reference.png`.*

```
2D sprite sheet. Use the attached Nila reference exactly: same face, proportions, markings, clothing and painting style.
The character: Nila, an elegant young Indian peacock who conducts music beside a stream. Deep royal-blue neck and breast with fine scale-like feathers, small crown of fan-tipped crest feathers, white patches above and below warm brown eyes, bronze and cream wings, folded green-gold train with a few eye spots, slim grey legs. Expression is shown by eyes, brow feathers, crest, beak, neck and wings. No clothes.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Nila is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 300 px tall, feet on the same line 48 px above the bottom of the cell. The folded train curves down and behind inside the cell; the whole bird stays inside 460 px width.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 the right wing opens and lifts like a conductor's arm; 4-7 the wing draws one smooth arc down and to the right, the head follows it; 8-11 the wing draws the arc back up to the left, the neck flows in an S-curve; 12-14 a small finishing flick of the wing tip; 15-16 the wing folds back to frame 1.
Expression: focused, graceful, expressive eyes.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 14. `melody/nila_listen_4x4.png`: Nila, 'your turn'

*Attach: `nila_reference.png`.*

```
2D sprite sheet. Use the attached Nila reference exactly: same face, proportions, markings, clothing and painting style.
The character: Nila, an elegant young Indian peacock who conducts music beside a stream. Deep royal-blue neck and breast with fine scale-like feathers, small crown of fan-tipped crest feathers, white patches above and below warm brown eyes, bronze and cream wings, folded green-gold train with a few eye spots, slim grey legs. Expression is shown by eyes, brow feathers, crest, beak, neck and wings. No clothes.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Nila is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 300 px tall, feet on the same line 48 px above the bottom of the cell. The folded train curves down and behind inside the cell; the whole bird stays inside 460 px width.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 the head leans 8 degrees to the right; 4-6 the right wing tip comes up beside the head as if cupping an ear; 7-12 listening, with two very small nods in rhythm and an interested blink; 13-16 the wing folds down and the head returns to frame 1.
Expression: attentive, encouraging, small open-beak smile.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 15. `melody/nila_happy_4x4.png`: Nila, happy at a correct step sequence

*Attach: `nila_reference.png`.*

```
2D sprite sheet. Use the attached Nila reference exactly: same face, proportions, markings, clothing and painting style.
The character: Nila, an elegant young Indian peacock who conducts music beside a stream. Deep royal-blue neck and breast with fine scale-like feathers, small crown of fan-tipped crest feathers, white patches above and below warm brown eyes, bronze and cream wings, folded green-gold train with a few eye spots, slim grey legs. Expression is shown by eyes, brow feathers, crest, beak, neck and wings. No clothes.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Nila is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 300 px tall, feet on the same line 48 px above the bottom of the cell. The folded train curves down and behind inside the cell; the whole bird stays inside 460 px width.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-2 a soft crouch; 3-6 both wings open half-way and the bird rises on its toes; 7-9 two light steps in place with the crest fully open and eyes closed in smiling curves; 10-12 one elegant turn of the neck and head; 13-16 the wings fold with soft follow-through, back to frame 1.
Expression: bright, joyful.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 16. `melody/nila_encourage_4x4.png`: Nila, kind encouragement after a wrong step

*Attach: `nila_reference.png`.*

```
2D sprite sheet. Use the attached Nila reference exactly: same face, proportions, markings, clothing and painting style.
The character: Nila, an elegant young Indian peacock who conducts music beside a stream. Deep royal-blue neck and breast with fine scale-like feathers, small crown of fan-tipped crest feathers, white patches above and below warm brown eyes, bronze and cream wings, folded green-gold train with a few eye spots, slim grey legs. Expression is shown by eyes, brow feathers, crest, beak, neck and wings. No clothes.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Nila is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 300 px tall, feet on the same line 48 px above the bottom of the cell. The folded train curves down and behind inside the cell; the whole bird stays inside 460 px width.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-4 the head tilts 6 degrees, the brow feathers lift in the middle, crest relaxed; 5-8 one slow warm nod; 9-13 the right wing opens low with the tip pointing to the right, inviting the player to watch again; 14-16 the wing folds back to frame 1.
Expression: gentle and patient, 'let us hear it again'.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 17. `melody/nila_cheer_4x4.png`: Nila, level finished, opening the tail

*Attach: `nila_reference.png`.*

```
2D sprite sheet. Use the attached Nila reference exactly: same face, proportions, markings, clothing and painting style.
The character: Nila, an elegant young Indian peacock who conducts music beside a stream. Deep royal-blue neck and breast with fine scale-like feathers, small crown of fan-tipped crest feathers, white patches above and below warm brown eyes, bronze and cream wings, folded green-gold train with a few eye spots, slim grey legs. Expression is shown by eyes, brow feathers, crest, beak, neck and wings. No clothes.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Nila is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 300 px tall, feet on the same line 48 px above the bottom of the cell. For this sheet only, the body is about 190 px tall in ALL 16 cells so that the fully open fan, about 440 px wide, fits inside the cell. Face the viewer in every frame.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 the folded train lifts; 4-8 the train opens evenly into a complete round fan of green, gold and blue eye feathers behind the body; 9-12 the open fan shimmers with a slow gentle sway left and right, eyes closed in smiling curves; 13-16 the fan closes evenly back to frame 1.
Expression: proud and radiant.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```


### Tashi, the Focus Finder red panda

## 18. `focus/tashi_idle_4x4.png`: Tashi, calm waiting

*Attach: `tashi_reference.png`.*

```
2D sprite sheet. Use the attached Tashi reference exactly: same face, proportions, markings, clothing and painting style.
The character: Tashi, a curious young red panda who explores the forest. Rich rust-red fur, cream face with rust tear marks, white-edged rounded ears, dark chocolate legs and belly, thick ringed tail, bright dark eyes, small black nose. Wears one small olive canvas satchel across the body and carries a round brass magnifying glass with a wooden handle, clear and empty glass.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Tashi is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell. The magnifying glass is always in the right paw and always the same size.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-4 a slow breath in, the chest rises, the tail curls slightly; 5-8 a slow breath out; 9-10 a soft blink; 11-13 one ear turns and the nose twitches; 14-16 the tail tip sways and settles, back to frame 1.
Expression: calm, friendly, alert.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 19. `focus/tashi_search_4x4.png`: Tashi, searching with the magnifying glass

*Attach: `tashi_reference.png`.*

```
2D sprite sheet. Use the attached Tashi reference exactly: same face, proportions, markings, clothing and painting style.
The character: Tashi, a curious young red panda who explores the forest. Rich rust-red fur, cream face with rust tear marks, white-edged rounded ears, dark chocolate legs and belly, thick ringed tail, bright dark eyes, small black nose. Wears one small olive canvas satchel across the body and carries a round brass magnifying glass with a wooden handle, clear and empty glass.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Tashi is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell. The magnifying glass is always in the right paw and always the same size.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 the magnifying glass rises in front of the right eye; 4-8 the glass, head and eyes move slowly together to the right, leaning 8 degrees; 9-13 they move slowly together to the left; 14-16 the glass lowers and the body returns to frame 1. The glass is clear and shows the face behind it.
Expression: curious and concentrated, bright eyes.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 20. `focus/tashi_found_4x4.png`: Tashi, happy at a found object

*Attach: `tashi_reference.png`.*

```
2D sprite sheet. Use the attached Tashi reference exactly: same face, proportions, markings, clothing and painting style.
The character: Tashi, a curious young red panda who explores the forest. Rich rust-red fur, cream face with rust tear marks, white-edged rounded ears, dark chocolate legs and belly, thick ringed tail, bright dark eyes, small black nose. Wears one small olive canvas satchel across the body and carries a round brass magnifying glass with a wooden handle, clear and empty glass.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Tashi is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell. The magnifying glass is always in the right paw and always the same size.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-2 ears prick up and eyes widen; 3-6 a light hop on the toes with the left paw pointing up to the right; 7-9 the top of the hop, eyes closed in smiling curves, tail high; 10-12 a soft landing with follow-through in the tail; 13-16 a happy nod, back to frame 1.
Expression: surprised, then delighted.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 21. `focus/tashi_dance_4x4.png`: Tashi, second celebration, for variety

*Attach: `tashi_reference.png`.*

```
2D sprite sheet. Use the attached Tashi reference exactly: same face, proportions, markings, clothing and painting style.
The character: Tashi, a curious young red panda who explores the forest. Rich rust-red fur, cream face with rust tear marks, white-edged rounded ears, dark chocolate legs and belly, thick ringed tail, bright dark eyes, small black nose. Wears one small olive canvas satchel across the body and carries a round brass magnifying glass with a wooden handle, clear and empty glass.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Tashi is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell. The magnifying glass is always in the right paw and always the same size.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-4 a step to the left with the tail swinging to the right; 5-8 a step to the right with the tail swinging to the left; 9-12 one slow full arm wave with the left paw, the body swaying; 13-16 the paw comes to the chest, a small bow, back to frame 1.
Expression: playful, joyful, graceful.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 22. `focus/tashi_encourage_4x4.png`: Tashi, kind encouragement after a miss

*Attach: `tashi_reference.png`.*

```
2D sprite sheet. Use the attached Tashi reference exactly: same face, proportions, markings, clothing and painting style.
The character: Tashi, a curious young red panda who explores the forest. Rich rust-red fur, cream face with rust tear marks, white-edged rounded ears, dark chocolate legs and belly, thick ringed tail, bright dark eyes, small black nose. Wears one small olive canvas satchel across the body and carries a round brass magnifying glass with a wooden handle, clear and empty glass.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Tashi is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell. The magnifying glass is always in the right paw and always the same size.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: 1-3 the ears relax outward, the brows lift in the middle, the head tilts 6 degrees; 4-7 a slow warm nod; 8-12 the magnifying glass is offered a little towards the right, inviting another look, while the left paw rests on the chest; 13-16 back to frame 1.
Expression: kind and supportive, 'look once more'.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```

## 23. `focus/tashi_cheer_4x4.png`: Tashi, level finished

*Attach: `tashi_reference.png`.*

```
2D sprite sheet. Use the attached Tashi reference exactly: same face, proportions, markings, clothing and painting style.
The character: Tashi, a curious young red panda who explores the forest. Rich rust-red fur, cream face with rust tear marks, white-edged rounded ears, dark chocolate legs and belly, thick ringed tail, bright dark eyes, small black nose. Wears one small olive canvas satchel across the body and carries a round brass magnifying glass with a wooden handle, clear and empty glass.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Tashi is full body, three-quarter view facing right, body centred at x = 256 in every cell, standing body about 330 px tall, feet on the same line 48 px above the bottom of the cell. The magnifying glass is always in the right paw and always the same size.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames. Frame 16 flows smoothly into frame 1.
Motion: Tashi holds one golden maple leaf in the left paw in every frame. 1-4 lift the leaf from the chest to above the head; 5-8 rise on the toes, tail high, eyes closed and smiling; 9-12 sway slowly left and right; 13-16 lower the leaf to the chest and nod, ending as in frame 1.
Expression: proud, warm, joyful.
Never sad, angry, scared, mocking or ashamed.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no ground shadow, no scenery, no sparkles or stars.
```


---

# Part B. Backgrounds

One for each level of each game. Make the first of a game, then attach it to the next two so the place stays the same and only light and season change.

## 24. `meadow/bg_meadow_1.png`: Memory Meadow, level 1, spring morning

*Attach: `style_key.png`.*

```
Wide 2D game background, exactly 1920 x 1080, fully painted, no transparency.
A wide open flower meadow seen slightly from above. Pale blue morning sky only at the very top, distant soft hills, light fresh-green short grass filling the play area, cosmos, daisies and lavender along the left and right edges, a smooth stone at the lower left corner.
Composition for a 1920 x 1080 touch screen: the top 120 px is plain sky or soft foliage for the score bar. The area from x = 440 to x = 1880 and y = 140 to y = 1040 is the play area: plain, even, softly lit, low contrast, no objects, so that pictures placed on it are easy to see. A calm open standing place for a character at the lower left, x = 40 to 420, ground line at y = 1000. Detail only along the edges and corners.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no people, no characters, no buttons, no frame, no cards.
```

## 25. `meadow/bg_meadow_2.png`: Memory Meadow, level 2, golden afternoon

*Attach: `meadow/bg_meadow_1.png`.*

```
Wide 2D game background, exactly 1920 x 1080, fully painted, no transparency.
Repaint the attached meadow as a warm golden late afternoon in summer. Same camera, same hills, same empty places. Honey-coloured light, soft long shadows at the edges, marigolds and sunflowers along the sides, a few seed heads. The play area becomes plain light straw-green grass.
Composition for a 1920 x 1080 touch screen: the top 120 px is plain sky or soft foliage for the score bar. The area from x = 440 to x = 1880 and y = 140 to y = 1040 is the play area: plain, even, softly lit, low contrast, no objects, so that pictures placed on it are easy to see. A calm open standing place for a character at the lower left, x = 40 to 420, ground line at y = 1000. Detail only along the edges and corners.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no people, no characters, no buttons, no frame, no cards.
```

## 26. `meadow/bg_meadow_3.png`: Memory Meadow, level 3, moonlit evening

*Attach: `meadow/bg_meadow_1.png`.*

```
Wide 2D game background, exactly 1920 x 1080, fully painted, no transparency.
Repaint the attached meadow as a peaceful moonlit evening. Same camera, same hills, same empty places. Deep blue-teal sky with a round moon at the far right top corner, white jasmine and blue flowers along the sides, small painted lantern lights near the edges. The play area becomes plain medium blue-green grass, clearly lit, never black.
Composition for a 1920 x 1080 touch screen: the top 120 px is plain sky or soft foliage for the score bar. The area from x = 440 to x = 1880 and y = 140 to y = 1040 is the play area: plain, even, softly lit, low contrast, no objects, so that pictures placed on it are easy to see. A calm open standing place for a character at the lower left, x = 40 to 420, ground line at y = 1000. Detail only along the edges and corners.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no people, no characters, no buttons, no frame, no cards.
```

## 27. `melody/bg_stream_1.png`: Melody Steps, level 1, sunny stream

*Attach: `style_key.png`.*

```
Wide 2D game background, exactly 1920 x 1080, fully painted, no transparency.
A calm clear shallow stream seen from above at a 60 degree angle, filling the play area with quiet pale turquoise water and only very soft ripples. Grassy bank with reeds along the left side, where the character stands. Ferns, smooth pebbles and a few pink water lilies along the top and right edges. No stepping stones in the play area.
Composition for a 1920 x 1080 touch screen: the top 120 px is plain sky or soft foliage for the score bar. The area from x = 440 to x = 1880 and y = 140 to y = 1040 is the play area: plain, even, softly lit, low contrast, no objects, so that pictures placed on it are easy to see. A calm open standing place for a character at the lower left, x = 40 to 420, ground line at y = 1000. Detail only along the edges and corners.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no people, no characters, no buttons, no frame, no cards.
```

## 28. `melody/bg_stream_2.png`: Melody Steps, level 2, after the rain

*Attach: `melody/bg_stream_1.png`.*

```
Wide 2D game background, exactly 1920 x 1080, fully painted, no transparency.
Repaint the attached stream just after summer rain. Same camera, same banks, same empty places. Fresh green leaves with round water drops at the edges, pale silver-blue water, a very soft rainbow low in the top left sky reflection. The play area stays quiet plain water.
Composition for a 1920 x 1080 touch screen: the top 120 px is plain sky or soft foliage for the score bar. The area from x = 440 to x = 1880 and y = 140 to y = 1040 is the play area: plain, even, softly lit, low contrast, no objects, so that pictures placed on it are easy to see. A calm open standing place for a character at the lower left, x = 40 to 420, ground line at y = 1000. Detail only along the edges and corners.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no people, no characters, no buttons, no frame, no cards.
```

## 29. `melody/bg_stream_3.png`: Melody Steps, level 3, lantern evening

*Attach: `melody/bg_stream_1.png`.*

```
Wide 2D game background, exactly 1920 x 1080, fully painted, no transparency.
Repaint the attached stream at early evening. Same camera, same banks, same empty places. Lavender and peach sky reflection, small floating oil lamps along the far edges only, warm light on the reeds. The play area is plain medium lavender-blue water, clearly lit.
Composition for a 1920 x 1080 touch screen: the top 120 px is plain sky or soft foliage for the score bar. The area from x = 440 to x = 1880 and y = 140 to y = 1040 is the play area: plain, even, softly lit, low contrast, no objects, so that pictures placed on it are easy to see. A calm open standing place for a character at the lower left, x = 40 to 420, ground line at y = 1000. Detail only along the edges and corners.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no people, no characters, no buttons, no frame, no cards.
```

## 30. `focus/bg_forest_1.png`: Focus Finder, level 1, bright forest clearing

*Attach: `style_key.png`.*

```
Wide 2D game background, exactly 1920 x 1080, fully painted, no transparency.
A sunlit forest clearing seen slightly from above. The play area is a plain soft mat of pale moss and fine sand-coloured earth. Tall friendly tree trunks, ferns and small mushrooms only along the left, right and top edges, dappled light only at the edges.
Composition for a 1920 x 1080 touch screen: the top 120 px is plain sky or soft foliage for the score bar. The area from x = 440 to x = 1880 and y = 140 to y = 1040 is the play area: plain, even, softly lit, low contrast, no objects, so that pictures placed on it are easy to see. A calm open standing place for a character at the lower left, x = 40 to 420, ground line at y = 1000. Detail only along the edges and corners.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no people, no characters, no buttons, no frame, no cards.
```

## 31. `focus/bg_forest_2.png`: Focus Finder, level 2, autumn forest

*Attach: `focus/bg_forest_1.png`.*

```
Wide 2D game background, exactly 1920 x 1080, fully painted, no transparency.
Repaint the attached clearing in autumn. Same camera, same trunks, same empty places. Amber and russet leaves on the trees and in small piles at the edges, warm afternoon light. The play area is plain pale cream-brown earth with no leaves on it.
Composition for a 1920 x 1080 touch screen: the top 120 px is plain sky or soft foliage for the score bar. The area from x = 440 to x = 1880 and y = 140 to y = 1040 is the play area: plain, even, softly lit, low contrast, no objects, so that pictures placed on it are easy to see. A calm open standing place for a character at the lower left, x = 40 to 420, ground line at y = 1000. Detail only along the edges and corners.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no people, no characters, no buttons, no frame, no cards.
```

## 32. `focus/bg_forest_3.png`: Focus Finder, level 3, misty bamboo dawn

*Attach: `focus/bg_forest_1.png`.*

```
Wide 2D game background, exactly 1920 x 1080, fully painted, no transparency.
Repaint the attached clearing as a misty bamboo forest at dawn. Same camera and same empty places, bamboo stems instead of trunks along the edges. Cool blue-green mist, one soft peach light at the top left. The play area is plain pale grey-green moss.
Composition for a 1920 x 1080 touch screen: the top 120 px is plain sky or soft foliage for the score bar. The area from x = 440 to x = 1880 and y = 140 to y = 1040 is the play area: plain, even, softly lit, low contrast, no objects, so that pictures placed on it are easy to see. A calm open standing place for a character at the lower left, x = 40 to 420, ground line at y = 1000. Detail only along the edges and corners.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no people, no characters, no buttons, no frame, no cards.
```

## 33. `meadow/fg_meadow.png`: foreground plants that sway in the wind

*Attach: `bg_meadow_1.png`.*

```
Foreground plant layer for a 2D game, exactly 1920 x 1080.
Only two groups of tall grasses, cosmos, lavender and daisies: one growing up from the lower left corner inside x = 0 to 300, y = 780 to 1080, and one growing up from the lower right corner inside x = 1700 to 1920, y = 760 to 1080. Everything else is completely empty. Leaves and stems are larger and slightly darker than in the background because they are closer.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no ground.
```

## 34. `melody/fg_stream.png`: foreground plants that sway in the wind

*Attach: `bg_stream_1.png`.*

```
Foreground plant layer for a 2D game, exactly 1920 x 1080.
Only two groups of reeds, ferns and two large lily leaves: one growing up from the lower left corner inside x = 0 to 300, y = 780 to 1080, and one growing up from the lower right corner inside x = 1700 to 1920, y = 760 to 1080. Everything else is completely empty. Leaves and stems are larger and slightly darker than in the background because they are closer.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no ground.
```

## 35. `focus/fg_forest.png`: foreground plants that sway in the wind

*Attach: `bg_forest_1.png`.*

```
Foreground plant layer for a 2D game, exactly 1920 x 1080.
Only two groups of fern fronds, hanging ivy and two leafy twigs: one growing up from the lower left corner inside x = 0 to 300, y = 780 to 1080, and one growing up from the lower right corner inside x = 1700 to 1920, y = 760 to 1080. Everything else is completely empty. Leaves and stems are larger and slightly darker than in the background because they are closer.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No animals, no ground.
```


---

# Part C. Memory Meadow pieces

Every hidden card is a closed flower. Tapping it makes the flower open and the object appears in its centre. The game plays the same sheet backwards to close it. One flower kind is used for the whole board, so a flower never gives a clue.

## 36. `meadow/cover_lotus_4x4.png`: lotus opening

*Attach: `style_key.png`.*

```
2D sprite sheet of one flower OPENING: a pink lotus with one round floating leaf under it, seen from above at a 65 degree angle.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The flower base is at exactly the same point, x = 256, y = 300, in all 16 cells. The camera never zooms; the leaves keep the same size and place in every frame. The fully open flower is 460 px wide, the closed bud about 250 px wide and 300 px tall.
Motion, very graceful and even: 1 a full, beautiful closed bud; 2-4 the bud loosens and its tip opens; 5-9 the outer petals fold outward one after another; 10-13 the inner petals fold outward; 14-15 the last petals settle with a tiny bounce; 16 completely open.
IMPORTANT: from frame 12 on, the centre of the flower is a plain, smooth, pale cream disc 250 px wide and 235 px high with no stamens or pattern, because an object is drawn on it. The petals form a ring around it.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No pot, no water, no ground, no shadow, no insects, no sparkles.
```

## 37. `meadow/cover_marigold_4x4.png`: marigold opening

*Attach: `style_key.png`.*

```
2D sprite sheet of one flower OPENING: a large orange and gold marigold with four green leaves under it, seen from above at a 65 degree angle.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The flower base is at exactly the same point, x = 256, y = 300, in all 16 cells. The camera never zooms; the leaves keep the same size and place in every frame. The fully open flower is 460 px wide, the closed bud about 250 px wide and 300 px tall.
Motion, very graceful and even: 1 a full, beautiful closed bud; 2-4 the bud loosens and its tip opens; 5-9 the outer petals fold outward one after another; 10-13 the inner petals fold outward; 14-15 the last petals settle with a tiny bounce; 16 completely open.
IMPORTANT: from frame 12 on, the centre of the flower is a plain, smooth, pale cream disc 250 px wide and 235 px high with no stamens or pattern, because an object is drawn on it. The petals form a ring around it.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No pot, no water, no ground, no shadow, no insects, no sparkles.
```

## 38. `meadow/cover_hibiscus_4x4.png`: hibiscus opening

*Attach: `style_key.png`.*

```
2D sprite sheet of one flower OPENING: a white hibiscus with a soft peach centre and five green leaves under it, seen from above at a 65 degree angle.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The flower base is at exactly the same point, x = 256, y = 300, in all 16 cells. The camera never zooms; the leaves keep the same size and place in every frame. The fully open flower is 460 px wide, the closed bud about 250 px wide and 300 px tall.
Motion, very graceful and even: 1 a full, beautiful closed bud; 2-4 the bud loosens and its tip opens; 5-9 the outer petals fold outward one after another; 10-13 the inner petals fold outward; 14-15 the last petals settle with a tiny bounce; 16 completely open.
IMPORTANT: from frame 12 on, the centre of the flower is a plain, smooth, pale cream disc 250 px wide and 235 px high with no stamens or pattern, because an object is drawn on it. The petals form a ring around it.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No pot, no water, no ground, no shadow, no insects, no sparkles.
```


---

# Part D. Melody Steps pieces

Six animal musicians sit on six stepping stones. Each has its own shape, colour and sound, so the sequence can be followed by sight, by place or by ear. Make the group picture first.

## 39. `melody/musicians_reference.png`: the six musicians, reference

*Attach: `style_key.png`.*

```
Character line-up of six original small animal musicians on one ground line, all drawn at the same height of about 420 px, three-quarter view facing the viewer, in this order from left to right: 1 a plump robin with an orange-red breast and brown back; 2 a smooth leaf-green tree frog with a cream belly and golden eyes; 3 a round violet-grey owlet with large amber eyes and a pale face disc; 4 a fluffy yellow duckling with an orange beak and feet; 5 a slim grey-brown palm squirrel with three pale stripes along the back and a bushy tail; 6 a white rabbit with long upright pale-pink ears.
The rabbit holds a small brass hand bell; the squirrel holds two acorn shells. The six silhouettes must be clearly different from each other even without colour. Warm, calm, natural faces with lively eyes.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. Plain white background. Canvas 3072 x 768.
```

## 40. `melody/robin_4x4.png`: robin, idle, play and happy

*Attach: `musicians_reference.png`.*

```
2D sprite sheet of one original small animal musician: a plump robin with an orange-red breast and brown back. Use the attached musicians reference exactly.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Full body, three-quarter view facing the viewer, centred at x = 256, body about 330 px tall, feet on the same line 60 px above the bottom in every cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames.
Row 1, frames 1-4, IDLE LOOP: a slow breath, one blink in frame 3; frame 4 flows into frame 1.
Rows 2 and 3, frames 5-12, PLAYING ONCE: it opens the beak wide and sings with the head raised, throat feathers moving, wings lifting slightly; frames 5-6 prepare, 7-10 the sound itself, 11-12 return to the pose of frame 1.
Row 4, frames 13-16, HAPPY LOOP: a light hop with eyes closed in smiling curves, 13 crouch, 14 up, 15 highest point 30 px above the ground line, 16 soft landing.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No stone, no ground, no shadow, no music notes.
```

## 41. `melody/frog_4x4.png`: frog, idle, play and happy

*Attach: `musicians_reference.png`.*

```
2D sprite sheet of one original small animal musician: a smooth leaf-green tree frog with a cream belly and golden eyes. Use the attached musicians reference exactly.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Full body, three-quarter view facing the viewer, centred at x = 256, body about 330 px tall, feet on the same line 60 px above the bottom in every cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames.
Row 1, frames 1-4, IDLE LOOP: a slow breath, one blink in frame 3; frame 4 flows into frame 1.
Rows 2 and 3, frames 5-12, PLAYING ONCE: it fills a round pale throat pouch and croaks, the pouch swelling and shrinking twice; frames 5-6 prepare, 7-10 the sound itself, 11-12 return to the pose of frame 1.
Row 4, frames 13-16, HAPPY LOOP: a light hop with eyes closed in smiling curves, 13 crouch, 14 up, 15 highest point 30 px above the ground line, 16 soft landing.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No stone, no ground, no shadow, no music notes.
```

## 42. `melody/owl_4x4.png`: owl, idle, play and happy

*Attach: `musicians_reference.png`.*

```
2D sprite sheet of one original small animal musician: a round violet-grey owlet with large amber eyes and a pale face disc. Use the attached musicians reference exactly.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Full body, three-quarter view facing the viewer, centred at x = 256, body about 330 px tall, feet on the same line 60 px above the bottom in every cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames.
Row 1, frames 1-4, IDLE LOOP: a slow breath, one blink in frame 3; frame 4 flows into frame 1.
Rows 2 and 3, frames 5-12, PLAYING ONCE: it leans forward and hoots twice with the beak open and wings slightly out; frames 5-6 prepare, 7-10 the sound itself, 11-12 return to the pose of frame 1.
Row 4, frames 13-16, HAPPY LOOP: a light hop with eyes closed in smiling curves, 13 crouch, 14 up, 15 highest point 30 px above the ground line, 16 soft landing.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No stone, no ground, no shadow, no music notes.
```

## 43. `melody/duckling_4x4.png`: duckling, idle, play and happy

*Attach: `musicians_reference.png`.*

```
2D sprite sheet of one original small animal musician: a fluffy yellow duckling with an orange beak and feet. Use the attached musicians reference exactly.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Full body, three-quarter view facing the viewer, centred at x = 256, body about 330 px tall, feet on the same line 60 px above the bottom in every cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames.
Row 1, frames 1-4, IDLE LOOP: a slow breath, one blink in frame 3; frame 4 flows into frame 1.
Rows 2 and 3, frames 5-12, PLAYING ONCE: it stretches up, quacks twice and flaps its small wings; frames 5-6 prepare, 7-10 the sound itself, 11-12 return to the pose of frame 1.
Row 4, frames 13-16, HAPPY LOOP: a light hop with eyes closed in smiling curves, 13 crouch, 14 up, 15 highest point 30 px above the ground line, 16 soft landing.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No stone, no ground, no shadow, no music notes.
```

## 44. `melody/squirrel_4x4.png`: squirrel, idle, play and happy

*Attach: `musicians_reference.png`.*

```
2D sprite sheet of one original small animal musician: a slim grey-brown palm squirrel with three pale stripes along the back and a bushy tail. Use the attached musicians reference exactly.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Full body, three-quarter view facing the viewer, centred at x = 256, body about 330 px tall, feet on the same line 60 px above the bottom in every cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames.
Row 1, frames 1-4, IDLE LOOP: a slow breath, one blink in frame 3; frame 4 flows into frame 1.
Rows 2 and 3, frames 5-12, PLAYING ONCE: it taps two acorn shells together three times in front of the chest, tail bouncing in rhythm; frames 5-6 prepare, 7-10 the sound itself, 11-12 return to the pose of frame 1.
Row 4, frames 13-16, HAPPY LOOP: a light hop with eyes closed in smiling curves, 13 crouch, 14 up, 15 highest point 30 px above the ground line, 16 soft landing.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No stone, no ground, no shadow, no music notes.
```

## 45. `melody/rabbit_4x4.png`: rabbit, idle, play and happy

*Attach: `musicians_reference.png`.*

```
2D sprite sheet of one original small animal musician: a white rabbit with long upright pale-pink ears. Use the attached musicians reference exactly.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
Full body, three-quarter view facing the viewer, centred at x = 256, body about 330 px tall, feet on the same line 60 px above the bottom in every cell.
The camera never moves or zooms. The head and body are EXACTLY the same size in all 16 cells: do not shrink the character to make room when a limb, tail or prop goes up, and do not rescale single frames. Same markings, colours and light in every frame. Graceful, natural motion: slow start, faster middle, slow finish, small follow-through in ears, tail or feathers, no sudden jumps between neighbouring frames.
Row 1, frames 1-4, IDLE LOOP: a slow breath, one blink in frame 3; frame 4 flows into frame 1.
Rows 2 and 3, frames 5-12, PLAYING ONCE: it swings one small brass hand bell left and right three times, ears following softly; frames 5-6 prepare, 7-10 the sound itself, 11-12 return to the pose of frame 1.
Row 4, frames 13-16, HAPPY LOOP: a light hop with eyes closed in smiling curves, 13 crouch, 14 up, 15 highest point 30 px above the ground line, 16 soft landing.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No stone, no ground, no shadow, no music notes.
```

## 46. `melody/stones.png`: six stepping stones

*Attach: `bg_stream_1.png`.*

```
Six smooth river stepping stones seen from above at a 60 degree angle. Canvas exactly 1536 x 1024, strict grid of 3 columns by 2 rows, each cell exactly 512 x 512, one stone centred in each cell, all the same size, 440 px wide and 300 px high, with a nearly flat top.
Each stone has a different natural tint and one large simple carved and painted flower-like mark around the rim, so they differ by colour AND shape: 1 coral with round petals; 2 leaf green with leaves; 3 violet with stars of five soft points; 4 golden yellow with sun rays; 5 sky blue with waves; 6 rose pink with hearts. The middle of every stone, 260 px wide, is plain because an animal sits there.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
The sky-blue stone is pale and soft.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No water, no moss outside the stone, no shadow.
```


---

# Part E. Focus Finder pieces

## 47. `focus/lens_frame.png`: large magnifying glass that holds the target

*Attach: `style_key.png`.*

```
One large round magnifying glass seen straight from the front, exactly 1024 x 1024. A finely crafted brass ring with a thin engraved leaf pattern and a warm wooden handle pointing to the lower right. The outer ring is a perfect circle 700 px wide, centre at x = 430, y = 430, ring 56 px thick. The inside of the ring is completely empty and transparent (or the plain background colour): no glass, no reflection, no object.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No hand, no shadow.
```

## 48. `focus/holder_wood.png`: wooden disc under each choice

*Attach: `bg_forest_1.png`.*

```
One round slice of pale birch wood seen from directly above, exactly 512 x 512, perfectly circular, 470 px wide, centred. Thin natural bark rim about 24 px wide with two tiny moss patches on the rim. The inside is pale cream, smooth and almost plain, with very faint growth rings, so that an object placed on it is easy to see.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No object, no shadow.
```

## 49. `focus/holder_leaf.png`: leaf plate for variety

*Attach: `bg_forest_1.png`.*

```
One round stitched leaf plate (made from dried sal leaves) seen from directly above, exactly 512 x 512, almost circular, 470 px wide, centred. Light golden-brown, softly wavy rim, the inner 360 px pale and almost plain so that an object placed on it is easy to see.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No food, no object, no shadow.
```


---

# Part F. Objects (used by Memory Meadow and Focus Finder)

96 objects in six themes, plus 32 look-alikes. Each session picks one theme, so the games stay fresh. Today there are only 8 objects.

## 50. `objects/fruits_4x4.png`: fruits and vegetables

*Attach: `style_key.png`.*

```
Picture sheet of 16 different single objects, theme: fruits and vegetables.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
One object centred in each cell. The longest side of every object is 410 px, so all look equally large. Clear natural three-quarter view unless stated. Every object must have an outline that is easy to recognise at 130 px and clearly different from the other 15. Good contrast against a pale cream background.
Cells in order, left to right, top to bottom: 1 ripe yellow mango; 2 bunch of two bananas; 3 red apple; 4 whole orange with a leaf; 5 triangular watermelon slice; 6 pineapple; 7 bunch of purple grapes; 8 pomegranate cut open; 9 half coconut; 10 half papaya with seeds; 11 red tomato; 12 orange carrot with leaves; 13 purple brinjal; 14 yellow corn cob; 15 long green chilli; 16 orange pumpkin.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No faces on objects, no shadows, no plates, no extra objects.
```

## 51. `objects/home_4x4.png`: familiar household things

*Attach: `style_key.png`.*

```
Picture sheet of 16 different single objects, theme: familiar household things.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
One object centred in each cell. The longest side of every object is 410 px, so all look equally large. Clear natural three-quarter view unless stated. Every object must have an outline that is easy to recognise at 130 px and clearly different from the other 15. Good contrast against a pale cream background.
Cells in order, left to right, top to bottom: 1 steel tumbler; 2 brass oil lamp with a small solid painted flame; 3 round clay water pot; 4 white tea cup on a saucer; 5 wooden spoon; 6 old brass key; 7 round wall clock without numbers; 8 open red umbrella; 9 pair of spectacles; 10 wooden comb; 11 woven cane basket; 12 hurricane lantern; 13 pair of leather sandals; 14 hand fan made of palm leaf; 15 folded striped towel; 16 sewing thread spool with needle.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No faces on objects, no shadows, no plates, no extra objects.
```

## 52. `objects/nature_4x4.png`: nature finds

*Attach: `style_key.png`.*

```
Picture sheet of 16 different single objects, theme: nature finds.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
One object centred in each cell. The longest side of every object is 410 px, so all look equally large. Clear natural three-quarter view unless stated. Every object must have an outline that is easy to recognise at 130 px and clearly different from the other 15. Good contrast against a pale cream background.
Cells in order, left to right, top to bottom: 1 pink lotus; 2 sunflower; 3 red rose; 4 red hibiscus; 5 heart-shaped peepal leaf; 6 brown mushroom with white spots; 7 acorn; 8 pine cone; 9 grey and white feather; 10 empty spiral snail shell; 11 bird nest with three eggs; 12 fan-shaped seashell; 13 small cactus in a clay pot; 14 white daisy; 15 twig with three red berries; 16 clover with four leaves.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No faces on objects, no shadows, no plates, no extra objects.
```

## 53. `objects/creatures_4x4.png`: small creatures

*Attach: `style_key.png`.*

```
Picture sheet of 16 different single objects, theme: small creatures.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
One object centred in each cell. The longest side of every object is 410 px, so all look equally large. Clear natural three-quarter view unless stated. Every object must have an outline that is easy to recognise at 130 px and clearly different from the other 15. Good contrast against a pale cream background.
Cells in order, left to right, top to bottom: 1 blue butterfly from above; 2 red ladybird from above; 3 honey bee from the side; 4 tortoise; 5 orange fish; 6 green parrot; 7 brown hen; 8 grey snail with a brown shell; 9 red crab; 10 orange starfish; 11 camel; 12 white cow with a bell; 13 black-and-white cat sitting; 14 brown dog sitting; 15 seahorse; 16 dragonfly from above.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No faces on objects, no shadows, no plates, no extra objects.
```

## 54. `objects/music_4x4.png`: music and play

*Attach: `style_key.png`.*

```
Picture sheet of 16 different single objects, theme: music and play.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
One object centred in each cell. The longest side of every object is 410 px, so all look equally large. Clear natural three-quarter view unless stated. Every object must have an outline that is easy to recognise at 130 px and clearly different from the other 15. Good contrast against a pale cream background.
Cells in order, left to right, top to bottom: 1 pair of tabla drums; 2 sitar; 3 bamboo flute; 4 brass hand bell; 5 harmonium; 6 trumpet; 7 tambourine; 8 xylophone with coloured bars; 9 wooden spinning top; 10 diamond-shaped paper kite with tail; 11 wooden rocking horse; 12 striped ball; 13 wooden toy train engine; 14 stack of three building blocks without letters; 15 teddy bear; 16 pair of maracas.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No faces on objects, no shadows, no plates, no extra objects.
```

## 55. `objects/travel_4x4.png`: travel and outdoors

*Attach: `style_key.png`.*

```
Picture sheet of 16 different single objects, theme: travel and outdoors.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
One object centred in each cell. The longest side of every object is 410 px, so all look equally large. Clear natural three-quarter view unless stated. Every object must have an outline that is easy to recognise at 130 px and clearly different from the other 15. Good contrast against a pale cream background.
Cells in order, left to right, top to bottom: 1 bicycle; 2 green and yellow three-wheeled auto rickshaw; 3 red bus; 4 steam engine; 5 sailing boat; 6 aeroplane; 7 hot-air balloon; 8 rocket; 9 blue scooter; 10 red tractor; 11 lighthouse; 12 brown suitcase; 13 compass without letters; 14 old camera; 15 globe on a stand; 16 orange tent.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No faces on objects, no shadows, no plates, no extra objects.
```

## 56. `objects/lookalike_a_4x4.png`: look-alikes for the hardest level

*Attach: `style_key.png`.*

```
Picture sheet of 16 objects for a careful-looking game: 4 rows, each row shows the SAME object four times with ONE clear difference.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
One object centred in each cell, longest side 410 px. Inside a row, size, angle, position, colours and light are identical in all four cells; only the named detail changes. The difference is easy to see at 160 px and does not depend on colour.
Row 1: butterfly from above. Cells 1 to 4: one round spot on each wing; two spots on each wing; one stripe on each wing; plain wings with a wavy edge.
Row 2: leaf. Cells 1 to 4: three lobes; five lobes; smooth oval; toothed oval.
Row 3: clay cup. Cells 1 to 4: round handle on the right; handle on the left; no handle; two handles.
Row 4: fish facing right. Cells 1 to 4: vertical stripes; horizontal stripes; round dots; plain.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No faces, no shadows, no extra objects.
```

## 57. `objects/lookalike_b_4x4.png`: look-alikes for the hardest level

*Attach: `style_key.png`.*

```
Picture sheet of 16 objects for a careful-looking game: 4 rows, each row shows the SAME object four times with ONE clear difference.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
One object centred in each cell, longest side 410 px. Inside a row, size, angle, position, colours and light are identical in all four cells; only the named detail changes. The difference is easy to see at 160 px and does not depend on colour.
Row 1: daisy from the front. Cells 1 to 4: five petals; eight petals; petals with pointed tips; petals with two layers.
Row 2: brass key. Cells 1 to 4: round head; heart head; square head; three-ring head.
Row 3: small house. Cells 1 to 4: one round window; one square window; two windows; no window and a larger door.
Row 4: diamond kite. Cells 1 to 4: cross pattern; single diagonal band; three dots; chequered halves.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No faces, no shadows, no extra objects.
```


---

# Part G. Ambient life and particles

## 58. `meadow/ambient_4x4.png`: meadow life, 4 animations

*Attach: `garden.png` and `butterflies.png` from `assets/images/butterfly_garden/`.*

```
2D sprite sheet with four short looping animations of nature details, one per row, 4 frames each.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The subject is centred in each cell, about 320 px long, the same size in all four frames of its row. Frame 4 flows into frame 1.
Row 1: a monarch-like orange butterfly, three-quarter view flying right. Frames: wings up; wings half down; wings fully down; wings half up.
Row 2: a honey bee, side view flying right. Frames: wings up; wings middle; wings down; wings middle.
Row 3: a ladybird walking right, side view. Frames: four walking steps, legs changing.
Row 4: a small white butterfly from above, flying up. Frames: wings open; three-quarter open; almost closed; three-quarter open.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure green #00FF00 colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no water, no shadow, no motion lines.
```

## 59. `melody/ambient_4x4.png`: stream life, 4 animations

*Attach: `garden.png` and `butterflies.png` from `assets/images/butterfly_garden/`.*

```
2D sprite sheet with four short looping animations of nature details, one per row, 4 frames each.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The subject is centred in each cell, about 320 px long, the same size in all four frames of its row. Frame 4 flows into frame 1.
Row 1: an orange and white koi from above, swimming right. Frames: body straight; curved left; straight; curved right.
Row 2: a blue dragonfly, three-quarter view flying right. Frames: wings up; middle; down; middle.
Row 3: a kingfisher, side view flying right. Frames: wings up; half down; down; half up.
Row 4: a small fallen yellow leaf floating, from above. Frames: four positions of one slow turn, 0, 30, 60 and 90 degrees.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no water, no shadow, no motion lines.
```

## 60. `focus/ambient_4x4.png`: forest life, 4 animations

*Attach: `garden.png` and `butterflies.png` from `assets/images/butterfly_garden/`.*

```
2D sprite sheet with four short looping animations of nature details, one per row, 4 frames each.
Canvas exactly 2048 x 2048. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 512 x 512, read left to right, top to bottom. No grid lines, frames or numbers. Nothing touches or crosses a cell edge; keep at least 24 px free on every side.
The subject is centred in each cell, about 320 px long, the same size in all four frames of its row. Frame 4 flows into frame 1.
Row 1: a small brown songbird, side view flying right. Frames: wings up; half down; down; half up.
Row 2: a cream moth from above, flying up. Frames: wings open; three-quarter open; almost closed; three-quarter open.
Row 3: a falling orange maple leaf. Frames: four positions of one slow tumble.
Row 4: a snail moving right, side view. Frames: four positions of one slow stretch and pull.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references.
Background: real transparency. If that is not possible, one perfectly flat pure blue #0000FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No ground, no water, no shadow, no motion lines.
```

## 61. `shared/particles_4x4.png`: particles for all effects

*Attach: `style_key.png`.*

```
Sheet of 16 small single game particles.
Canvas exactly 1024 x 1024. Strict grid of 4 columns by 4 rows, 16 cells, each exactly 256 x 256, one particle centred in each cell, longest side 180 px. No grid lines.
Cells in order: 1 golden five-point star with rounded tips; 2 small golden four-point sparkle; 3 pale blush petal; 4 white petal; 5 orange petal; 6 green leaf; 7 yellow leaf; 8 soft round water drop; 9 eighth note in deep blue; 10 two joined eighth notes in warm orange; 11 quarter note in teal; 12 treble clef in gold; 13 coral paper confetti strip; 14 sky-blue paper confetti curl; 15 small white feather; 16 small red heart with rounded shape.
Solid, opaque, crisp shapes with gentle painted shading.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, no glow, no trails, no circles behind the particles, no shadow.
```


---

# Part H. Screens and buttons

One calm set for all three games. The game writes all text itself.

## 62. `shared/ui_bar.png`: top bar

*Attach: `style_key.png`.*

```
2D game interface element: one long, slim score bar, exactly 1920 x 120, made of pale cream handmade paper with a thin warm wooden edge along the bottom and two tiny painted leaves at the far left and far right. The middle is completely plain.
Style: high-quality painted game interface, natural paper and wood, warm and calm, matching the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers or logo. No shadow outside the shape.
```

## 63. `shared/ui_panel.png`: result and menu panel

*Attach: `style_key.png`.*

```
2D game interface element: one large empty panel, exactly 1200 x 800: pale cream handmade paper inside a slim polished light-wood frame with rounded corners of 60 px radius; a small carved leaf in each corner inside the first 90 px. Edges between the corners are straight and even so the panel can be stretched. The inside is completely plain.
Style: high-quality painted game interface, natural paper and wood, warm and calm, matching the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers or logo. No shadow outside the shape.
```

## 64. `shared/ui_buttons.png`: three buttons

*Attach: `style_key.png`.*

```
2D game interface element: three empty rounded buttons stacked in one column, canvas exactly 640 x 640: each button exactly 600 x 170, centred at y = 110, 320 and 530. Top one leaf green, middle one warm amber, bottom one soft slate blue, dark enough for white text. Polished painted wood look, soft highlight at the top, no writing, centre plain.
Style: high-quality painted game interface, natural paper and wood, warm and calm, matching the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers or logo. No shadow outside the shape.
```

## 65. `shared/ui_card.png`: game card for the menu

*Attach: `style_key.png`.*

```
2D game interface element: one empty tall picture card, exactly 560 x 720: pale cream paper, slim light-wood frame with 48 px rounded corners, a plain empty picture window 480 x 420 in the upper part, plain paper below.
Style: high-quality painted game interface, natural paper and wood, warm and calm, matching the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers or logo. No shadow outside the shape.
```

## 66. `shared/ui_icons_4x4.png`: icons

*Attach: `style_key.png`.*

```
2D game interface element: a sheet of 16 simple icons. Canvas exactly 1024 x 1024, strict grid of 4 columns by 4 rows, each cell 256 x 256, one icon centred in each cell, 170 px, dark teal-brown painted shapes of even thickness, easy to read at 48 px. Cells in order: 1 house; 2 two pause bars; 3 play triangle; 4 circular restart arrow; 5 speaker with waves; 6 speaker with a line through it; 7 hourglass; 8 golden full star; 9 pale empty star; 10 light bulb; 11 ear; 12 eye; 13 open hand; 14 check mark; 15 arrow to the right; 16 small sprout for calm mode.
Style: high-quality painted game interface, natural paper and wood, warm and calm, matching the attached style key.
Background: real transparency. If that is not possible, one perfectly flat pure magenta #FF00FF colour, with no gradient, no checkerboard, no shadow and no colour spill on the subject. Crisp closed edge around every subject: no loose hairs, no glow, no haze, no see-through areas.
No text, letters, numbers or logo. No shadow outside the shape.
```

## 67. `meadow/layout_reference.png`: Memory Meadow layout

*Attach: `moti_reference.png` and `bg_meadow_1.png`.*

```
Full-screen 2D game mock-up, exactly 1920 x 1080, for a calm brain-training game on a large horizontal touch screen.
Top: a slim cream paper bar 120 px high with one round home button at the far left, a simple progress strip in the middle and one round pause button at the far right.
Background: sunny flower meadow. Lower left: Moti the baby elephant, 380 px tall, standing at x = 220. Play area from x = 440 to 1880: a 4 by 3 grid of twelve pink lotus flowers, each 270 px wide with at least 40 px between them; two flowers are fully open and each shows the same yellow mango in its centre, ten are closed buds. Two small butterflies at the edges.
Very large shapes, lots of empty space, clear contrast, easy to read for older people.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No coins, no timers, no small icons.
```

## 68. `melody/layout_reference.png`: Melody Steps layout

*Attach: `nila_reference.png` and `bg_stream_1.png`.*

```
Full-screen 2D game mock-up, exactly 1920 x 1080, for a calm brain-training game on a large horizontal touch screen.
Top: a slim cream paper bar 120 px high with one round home button at the far left, a simple progress strip in the middle and one round pause button at the far right.
Background: clear turquoise stream. Lower left on the bank: Nila the peacock, 380 px tall. Play area from x = 440 to 1880: six large stepping stones in two rows of three, each 400 px wide, with one animal on each: robin, frog, owlet, duckling, squirrel, rabbit with a bell. The owlet is hooting and its stone is brighter than the rest, with three music notes above it. Above the stones, a row of six small round progress dots.
Very large shapes, lots of empty space, clear contrast, easy to read for older people.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No coins, no timers, no small icons.
```

## 69. `focus/layout_reference.png`: Focus Finder layout

*Attach: `tashi_reference.png` and `bg_forest_1.png`.*

```
Full-screen 2D game mock-up, exactly 1920 x 1080, for a calm brain-training game on a large horizontal touch screen.
Top: a slim cream paper bar 120 px high with one round home button at the far left, a simple progress strip in the middle and one round pause button at the far right.
Background: bright forest clearing. Lower left: Tashi the red panda, 380 px tall, looking through the magnifying glass. Upper left above Tashi: a big brass magnifying glass 340 px wide with one red umbrella inside it. Play area from x = 440 to 1880: a 3 by 3 grid of nine pale birch-wood discs, each 250 px wide with 50 px between them, each with one different household object; one of them is the same red umbrella.
Very large shapes, lots of empty space, clear contrast, easy to read for older people.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character. No coins, no timers, no small icons.
```

## 70. `shared/layout_menu.png`: menu layout

*Attach: `style_key.png`.*

```
Full-screen 2D game menu mock-up, exactly 1920 x 1080, for a calm brain-training app. Soft meadow background, blurred and pale. Three large tall picture cards side by side, each 520 px wide, pale cream paper with a light-wood frame: the first shows Moti the baby elephant with a lotus, the second Nila the peacock conducting, the third Tashi the red panda with a magnifying glass. Below each card three empty round level buttons. One slim cream bar at the top with one round home button.
Style: high-end painterly 2D game illustration with a real, natural feel, like a page from a beautifully painted nature storybook. True-to-life proportions and materials, fine visible fur, feather, petal, wood or metal texture, soft warm light from the top left, gentle shading, rich but natural colours. Not a 3D render, not flat vector, not cartoon, not a photo. Match the attached style references. No text, letters, numbers, logo, watermark or signature. No resemblance to any existing film, cartoon or game character.
```
