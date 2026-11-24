# Shape Match: art prompts

Each prompt is complete: copy the whole block into the image generator.
Save the result under the exact file name in `assets/images/peg_match/`, then
open the project in Godot once so it imports. The game uses a picture as soon as
it exists; until then it draws its own placeholder.

## Order and rules

1. Make **Pip's reference** (prompt 1) first. Attach that picture to prompts 2–6.
   Attach it to the others too if the generator accepts style references.
2. Every animation sheet is **2048 × 2048, 4 columns × 4 rows, 16 frames**, read
   left to right, top to bottom. Each cell is exactly 512 × 512.
3. Backgrounds must be transparent. If the generator cannot do that, replace
   "transparent background" with "plain flat #FF00FF magenta background, no
   shadow on the background" and the colour can be removed afterwards.
4. Check each sheet before using it: 16 cells, the same size of character in
   every cell, feet on the same line, nothing crossing a cell border. Ask the
   generator to redo the sheet if it fails, as a bad grid makes the character jump.
5. Keep text out of all pictures. The game writes the text itself.

| File | Size | Speed in game | Where it appears |
|---|---|---|---|
| `pip_idle_4x4.png` | 2048² | 10 fps, loops | waiting, menu |
| `pip_think_4x4.png` | 2048² | 10 fps, loops | shape-only, clues, memory, hints |
| `pip_happy_4x4.png` | 2048² | 10 fps, loops | correct board |
| `pip_oops_4x4.png` | 2048² | 10 fps, loops | wrong board |
| `pip_cheer_4x4.png` | 2048² | 10 fps, loops | level finished |
| `vfx_correct_burst_4x4.png` | 2048² | 16 fps, once (1.0 s) | around the correct board |
| `vfx_try_again_4x4.png` | 2048² | 12 fps, once (1.3 s) | around the wrong board |
| `vfx_level_complete_4x4.png` | 2048² | 12 fps, once (1.3 s) | behind the result stars |
| `bg_meadow.png` | 1920 × 1080 | still | whole screen |
| `target_card.png` | 1024 × 1024 | still | frame around the object to find |
| `placement_pad.png` | 1024 × 1024 | still | "Place it here" |
| `speech_bubble.png` | 1024 × 500 | still | Pip's words |

---

## 1. Pip reference (not used by the game directly)

```
Character reference sheet of an original mascot called Pip for a calm cognitive-training game for adults and children. Pip is a small round blue bear-like creature: ball-shaped body in soft sky blue (#5C9DED), slightly darker blue arms, feet and round ears (#3F7FD0), pink inner ears (#FFC1CF), a large pale-blue oval tummy (#E3F0FF), big friendly dark-navy eyes with one white highlight, soft pink cheeks, small smile, no nose, no clothes, no accessories. Short stubby arms with mitten hands, two small round feet. Head and body are one round shape.
Show four full-body views in one row on the same ground line: front, three-quarter left, side, back. Same proportions in every view.
Style: polished 2D game art, smooth soft shading, clean dark-navy outline of even thickness, gentle top-left light, warm and calm, not babyish. Plain white background. No text, no logo, no watermark, no resemblance to any existing cartoon or game character.
Canvas 2048 x 1024.
```

## 2. `pip_idle_4x4.png`: calm waiting

```
Use the attached Pip reference exactly: same colours, proportions, outline and shading.
2D sprite sheet for a looping IDLE animation. Canvas exactly 2048 x 2048, transparent background, strict grid of 4 columns by 4 rows, 16 frames, each cell exactly 512 x 512. No grid lines, no borders, no text.
Pip faces the viewer, full body, centred in every cell, body about 400 px tall, feet resting on the same horizontal line 60 px above the bottom of each cell, at least 40 px empty space on every side. Camera and size never change.
Motion, frame by frame: 1-4 slowly breathe in, body stretches up 2 percent, arms relaxed at the sides; 5-8 slowly breathe out, back to the start; 9 eyes half closed; 10 eyes closed; 11 eyes half closed; 12 eyes open; 13-14 head tilts very slightly right with a small smile; 15-16 return to the pose of frame 1. Frame 16 must flow smoothly into frame 1.
Expression: calm, patient, friendly. Polished 2D game art, smooth soft shading, even dark-navy outline, top-left light. No ground shadow, no props, no background.
```

## 3. `pip_think_4x4.png`: thinking with the player

```
Use the attached Pip reference exactly: same colours, proportions, outline and shading.
2D sprite sheet for a looping THINKING animation. Canvas exactly 2048 x 2048, transparent background, strict grid of 4 columns by 4 rows, 16 frames, each cell exactly 512 x 512. No grid lines, no borders, no text, no question marks.
Pip full body, centred in every cell, body about 400 px tall, feet on the same horizontal line 60 px above the bottom of each cell, at least 40 px empty space on every side. Camera and size never change.
Motion: 1-3 the right hand rises to touch the cheek; 4-7 eyes look up to the right, head tilts 8 degrees right; 8-9 eyes move to the centre; 10-13 eyes look up to the left, head tilts 8 degrees left, hand stays on the cheek; 14-15 eyes return to the centre and head straightens; 16 hand lowers into the pose of frame 1. Smooth loop.
Expression: curious and interested, small closed mouth, never confused or sad. Polished 2D game art, smooth soft shading, even dark-navy outline, top-left light. No ground shadow, no props, no background.
```

## 4. `pip_happy_4x4.png`: celebration for a correct answer

```
Use the attached Pip reference exactly: same colours, proportions, outline and shading.
2D sprite sheet for a looping HAPPY CELEBRATION animation. Canvas exactly 2048 x 2048, transparent background, strict grid of 4 columns by 4 rows, 16 frames, each cell exactly 512 x 512. No grid lines, no borders, no text.
Pip full body facing the viewer, centred horizontally in every cell, body about 360 px tall, standing ground line 50 px above the bottom of each cell, at least 30 px empty space on every side even at the top of the jump. Camera and size never change.
Motion: 1-2 crouch down, arms back, squashed 8 percent; 3-5 jump up with both arms raised; 6-7 highest point, feet 70 px above the ground line, eyes closed in happy upward curves, wide open smile; 8-9 fall; 10 land with a soft squash; 11-13 clap hands twice in front of the tummy; 14-15 sway once to the left and right; 16 return to the pose of frame 1. Smooth loop.
Expression: delighted and proud of the player. Polished 2D game art, smooth soft shading, even dark-navy outline, top-left light. No stars, no confetti, no ground shadow, no props, no background.
```

## 5. `pip_oops_4x4.png`: kind encouragement after a wrong answer

```
Use the attached Pip reference exactly: same colours, proportions, outline and shading.
2D sprite sheet for a looping GENTLE ENCOURAGEMENT animation. Canvas exactly 2048 x 2048, transparent background, strict grid of 4 columns by 4 rows, 16 frames, each cell exactly 512 x 512. No grid lines, no borders, no text.
Pip full body, centred in every cell, body about 400 px tall, feet on the same horizontal line 60 px above the bottom of each cell, at least 40 px empty space on every side. Camera and size never change.
Motion: 1-3 eyebrows lift in the middle, head tilts 6 degrees left, small surprised mouth; 4-7 a slow soft shake of the head, left then right; 8-10 a warm smile returns; 11-14 the right hand makes a small open-palm gesture towards the viewer's right, inviting another try, with one gentle nod; 15-16 return to the pose of frame 1. Smooth loop.
Expression: kind, supportive, "nearly, try again". Never angry, crying, disappointed or ashamed. Inner ends of the eyebrows point UP. Polished 2D game art, smooth soft shading, even dark-navy outline, top-left light. No red crosses, no ground shadow, no props, no background.
```

## 6. `pip_cheer_4x4.png`: level finished

```
Use the attached Pip reference exactly: same colours, proportions, outline and shading.
2D sprite sheet for a looping BIG CHEER animation. Canvas exactly 2048 x 2048, transparent background, strict grid of 4 columns by 4 rows, 16 frames, each cell exactly 512 x 512. No grid lines, no borders, no text.
Pip full body, centred horizontally in every cell, body about 340 px tall, ground line 50 px above the bottom of each cell, at least 30 px empty space on every side. Camera and size never change. In every frame Pip holds one plain golden star (#FFB300, no face, no writing) the size of its head.
Motion: 1-3 lift the star from the tummy to above the head; 4-7 small hop with the star held high, eyes closed in happy curves, wide smile; 8-11 turn the body 15 degrees left then 15 degrees right, swinging the star; 12-13 second small hop; 14-16 lower the star back to the tummy, ending in the pose of frame 1. Smooth loop.
Expression: proud, joyful, warm. Polished 2D game art, smooth soft shading, even dark-navy outline, top-left light. No confetti, no ground shadow, no background.
```

## 7. `vfx_correct_burst_4x4.png`: celebration around the board

```
2D game visual-effect sprite sheet: a joyful CORRECT-ANSWER BURST seen from directly above. Canvas exactly 2048 x 2048, transparent background, strict grid of 4 columns by 4 rows, 16 frames, each cell exactly 512 x 512. No grid lines, no borders, no text.
The effect is perfectly centred in every cell and stays inside a 480 px circle. IMPORTANT: the middle of every cell, a circle 190 px wide, stays completely empty and transparent, because a real object stands there.
Motion: 1-2 a thin bright golden ring appears around the empty centre; 3-6 the ring expands while twelve rounded stars in gold, coral, sky blue, leaf green and soft purple shoot outward with short light trails; 7-10 the stars spread and spin, small confetti pieces and dots appear, the ring fades; 11-14 stars and confetti shrink and drift outward; 15 only a few tiny sparkles; 16 completely empty.
Style: polished 2D game effect, clean rounded shapes, soft glow, bright on a light background. No white flash, no flicker, no smoke, no character.
```

## 8. `vfx_try_again_4x4.png`: soft ring for a wrong board

```
2D game visual-effect sprite sheet: a calm TRY-AGAIN RIPPLE seen from directly above. Canvas exactly 2048 x 2048, transparent background, strict grid of 4 columns by 4 rows, 16 frames, each cell exactly 512 x 512. No grid lines, no borders, no text.
Perfectly centred in every cell, inside a 440 px circle. IMPORTANT: the middle of every cell, a circle 210 px wide, stays completely empty and transparent.
Motion: 1-5 a soft amber ring (#FFB74D) appears around the empty centre and grows gently; 6-10 a second thinner ring follows it and both wobble slightly like water; 11-14 the rings widen and become transparent; 15 almost invisible; 16 completely empty.
Style: polished 2D game effect, soft edges, warm and gentle. No red, no cross, no warning sign, no explosion, no flicker.
```

## 9. `vfx_level_complete_4x4.png`: behind the result stars

```
2D game visual-effect sprite sheet: a LEVEL-COMPLETE CONFETTI FOUNTAIN seen from the front. Canvas exactly 2048 x 2048, transparent background, strict grid of 4 columns by 4 rows, 16 frames, each cell exactly 512 x 512. No grid lines, no borders, no text.
Centred in every cell with 16 px empty space on every side.
Motion: 1-3 a soft golden light opens in the middle with twelve wide gentle rays; 4-8 paper confetti and rounded stars in gold, coral, sky blue, leaf green and soft purple fly outward and up from the centre; 9-13 the confetti slows, turns and begins to fall while the rays fade; 14-15 a few last pieces near the bottom; 16 completely empty.
Style: polished 2D game effect, clean rounded shapes, soft glow. No white flash, no flicker, no character.
```

## 10. `bg_meadow.png`: game background

```
Wide 2D game background, exactly 1920 x 1080: a calm morning meadow for a cognitive-training game. Pale blue sky (#BFE6F5) fading to very light mint at the horizon, two or three soft white clouds, low rounded green hills (#C5E8B7 and #A5D796) in the bottom quarter only, a few tiny flowers and one small round tree at the far left and far right edges.
The centre and the right half must be plain, light and low contrast, because a card and a real object are shown there. Nothing detailed between 10 and 75 percent of the height. Leave a plain grassy spot at the lower left, where a character will stand.
Style: polished 2D game art, smooth soft shapes, gentle light from the top left. No characters, no animals, no objects, no text, no frame, no buttons.
```

## 11. `target_card.png`: frame around the object to find

```
2D game UI element, exactly 1024 x 1024, transparent background: one large empty square picture card, centred, filling 960 x 960, corner radius about 110 px. Cream inside (#FFFAF0), completely plain and flat. A soft rounded border about 26 px wide in pale blue-grey with a thin lighter inner line, and a very soft shadow below.
Style: polished 2D game UI, matches a calm blue and mint game. No text, no icon, no pattern, no picture inside, no stars, no ribbon.
```

## 12. `placement_pad.png`: where the board is placed

```
2D game UI element, exactly 1024 x 1024, transparent background, seen from directly above: one round placement pad, perfectly circular and centred, 960 px wide. Very light mint-white inside, almost plain. A clear teal ring (#26A69A) about 34 px wide on the outside, a thin lighter ring inside it, and four small rounded teal arrow marks at the top, right, bottom and left pointing to the centre. The middle circle, 560 px wide, must be completely plain.
Style: polished 2D game UI, soft and clean. No text, no hand, no object, no shadow outside the ring.
```

## 13. `speech_bubble.png`: Pip's words

```
2D game UI element, exactly 1024 x 500, transparent background: one empty white speech bubble with large rounded corners and a thin pale blue-grey outline. The bubble body fills the width and the top 410 px. A short rounded tail at the bottom, about 45 percent from the left, points straight down to the bottom edge. Flat white inside, very soft shadow.
Style: polished 2D game UI. No text, no dots, no icon.
```

## 14. Full layout picture (a reference for you and designers, not loaded by the game)

```
Full-screen 2D game layout mock-up, 16:9, 1920 x 1080, for a calm cognitive-training game on a large horizontal touch screen. Use the attached Pip reference for the character.
Top: a translucent white bar 110 px high with one rounded blue-grey button at the far left, one at the far right, and six small progress dots in the centre, the first two replaced by golden stars.
Left third: Pip stands on the grass at the lower left, about 420 px tall, with an empty white speech bubble above its head.
Centre: one large cream rounded square card, 600 x 600, showing a single simple orange open cup (a plain open cylinder, no handle).
Right third: one large round mint placement pad with a teal ring, 460 px wide, empty.
Background: calm pale-blue sky, soft clouds, low green hills at the bottom.
Very large shapes, lots of empty space, at most three things to look at, high readability for older adults. Polished 2D game art, smooth soft shading, gentle top-left light. No text, no coins, no timers, no small icons, no watermark.
```

---

## The six objects

`objects/cup.png`, `cone.png`, `cylinder.png`, `square.png`, `ball_holder.png`
and `bottle_holder.png` were rendered from `pegboard/SITAR_TOOL.step`, so they
already match the printed parts. Only their colours are a guess: if your prints
have other colours, change `OBJECTS` in `games/pegboard/scripts/peg_library.gd`
and have the pictures rendered again, so the colour is never a wrong clue.

To restyle one, attach its PNG and use:

```
Repaint the attached object as a polished 2D game item. Keep exactly the same shape, proportions, viewing angle, opening and colour. Smooth soft shading, even dark-navy outline, top-left light. Centred, about 470 px tall, transparent background, exactly 512 x 512. No text, no shadow, no extra parts, no handle, no face.
```
