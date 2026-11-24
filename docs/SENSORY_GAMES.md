# Connect the picture and Listen & discover

The library has two independent entries: **Connect the picture** and **Listen & discover**. Each opens its own scene; there is no game-switching tab inside either game. Both work offline. F11 toggles fullscreen. Map the USB frame to the TV display in the operating system.

## Pattern drawing

28 distinct layouts include illustrated bird/tree/wave/car/guitar/train patterns and geometric pictures such as a house, sailboat, butterfly, umbrella, staircase, crown and octagon. New geometric references are vector drawings, so they stay crisp on large TVs. Each session has eight rounds; layouts contain 3–8 targets, within the frame's 10-contact limit. Closed shapes connect their final edge automatically.

A shuffled bag persists in `user://sensory_progress.cfg`: every layout is presented before the bag refills. The refill avoids the immediately previous pattern, and the current session does not repeat a layout across a refill. Clear/retry and input-mode changes keep the current pattern.

One-dot mode accepts mouse or sequential taps in numbered order. Hold-all mode requires one separate finger contact on every target for 0.65 seconds, with no extra board contacts. Matching uses a 48-pixel tolerance in the 1920×1080 design coordinate system. All target centers are more than 96 pixels apart. Duplicate contacts cannot satisfy other targets. Each completed round awards 100 points once; Next advances explicitly.

## Sound identification levels

| Difficulty | Choices | Rounds | Clip length | Content |
| --- | --- | --- | --- | --- |
| Easy | 2 | 4 | Up to 7 seconds | Bird, guitar, telephone, car |
| Medium | 3 | 6 | Up to 7 seconds | Six unique rounds drawn from all nine recordings |
| Hard | 4 | 9 | Up to 3 seconds | All nine recordings; choices prioritize similar sources from the same category |

The full collection is bird, rain, waves, guitar, piano, telephone, bell, car and train. Guitar's original clip is shorter than the maximum. Each session shuffles sounds without repeats. Hard includes comparisons such as guitar/piano, car/train and rain/waves. A Next level button appears after completing Easy or Medium; all levels are also available directly in the difficulty menu. Changing difficulty starts a fresh session and resets current points. Best scores are saved independently for each difficulty; the old unlevelled sound score is retained but not compared with new scores.

The player must play the recording before answering. Wrong answers have no penalty. Replay is unlimited at every level. Clips stop on pause, navigation or correct answers. There is no microphone capture or speech recognition.

There is no countdown, failure state, or flashing animation. Large targets, text cues, visible numbers, optional gentle motion, volume control, pause/resume, finish and replay are included. Color is never the only cue. Escape or application focus loss pauses. Scores persist separately for each game in `user://sensory_progress.cfg`; these are game scores, not clinical assessments.

These activities offer cognitive practice and engagement; this implementation has not been clinically validated. Suitability depends on the individual, including vision, hearing and motor ability. For therapeutic use, have the patient's clinician or therapist choose the activity and difficulty. NIA discusses the limited evidence for commercial brain-training applications: https://www.nia.nih.gov/health/alzheimers-and-dementia/preventing-alzheimers-disease-what-do-we-know

## Art

`assets/images/sensory/atlas.png` is an original image generated with the built-in image-generation tool. Runtime AtlasTextures select its nine equal cells; no remote asset dependency. The nine illustrations are bird, rainy tree, wave, guitar, piano, bell, telephone, car and train. All nine illustrations are now used in sound rounds.

Final generation prompt:

> Use case: illustration-story. Asset type: high quality 2D game sprite atlas for calm adult cognitive practice. Create one square transparent sprite sheet divided into a precise 3 by 3 equal grid, nine separate isolated illustrations centered in their cells with wide transparent gutters, no text, no grid lines. Row 1: songbird perched on small twig; leafy tree with raindrops; ocean wave. Row 2: acoustic guitar; small piano; ringing brass handbell. Row 3: classic telephone; red passenger car; blue locomotive. Beautiful polished hand painted 2D illustration, clear recognizable silhouettes, rich cheerful natural colors, soft shading, dignified accessible style suitable for adults, no faces on objects, no busy background, no shadows crossing cell boundaries. Each object fits entirely in its cell.

## Audio provenance

Downloaded 2026-11-12. The original four recordings are CC0 / public domain. Added recordings use the individual licenses below; attribution is retained. Clips have been trimmed to a maximum of seven seconds, loudness-normalized (target −23 LUFS, true-peak limit −3 dB), and faded at the beginning/end using FFmpeg. The guitar recording is naturally shorter. Default in-game playback volume is 40%; actual loudness depends on TV settings.

| Local file | Recording / creator | Source and license evidence |
| --- | --- | --- |
| `assets/audio/sensory/bird.ogg` | Birds — kvgarlic; edited by Porrumentzio | https://github.com/rafaelmardojai/blanket/blob/master/SOUNDS_LICENSING.md (CC0); media: https://raw.githubusercontent.com/rafaelmardojai/blanket/master/data/resources/sounds/birds.ogg |
| `assets/audio/sensory/guitar.ogg` | Guitar — AntumDeluge | https://opengameart.org/content/guitar-0 (CC0); media: https://opengameart.org/sites/default/files/guitar-1_0.ogg |
| `assets/audio/sensory/phone.ogg` | Dial Phone #1 — Joseph SARDIN | https://bigsoundbank.com/dial-phone-s0001.html (CC0); media: https://bigsoundbank.com/UPLOAD/ogg/0001.ogg |
| `assets/audio/sensory/car.ogg` | Car, Starting and Departure — Joseph SARDIN | https://bigsoundbank.com/car-starting-and-departure-s0189.html (CC0); media: https://bigsoundbank.com/UPLOAD/ogg/0189.ogg |

CC0 legal terms: https://creativecommons.org/publicdomain/zero/1.0/

## Verification

`Godot --headless --path D:/sitar --script tests/test_sensory.gd` verifies ordered matching, simultaneous matching, duplicate contacts, pause clearing, answer gating, wrong answers, duplicate score prevention, round completion and audio availability. Without `--headless`, it also writes dot/sound screenshots to `.test-data` for visual inspection. Point matching is tested in software; the actual 43-inch USB frame still needs multi-contact calibration and a hands-on usability test. Preview screenshots are at the configured 1280×720 window size. No patient outcomes have been tested.

## Additional audio sources for difficulty levels

Downloaded 2026-11-12. All added clips are trimmed to seven seconds, normalized to target −23 LUFS / −3 dB true peak, faded, and encoded as Ogg Vorbis. Hard plays only the first three seconds. Rain, waves and train are downloaded from the Blanket project's edited copies; original authors and licenses are retained.

| File | Recording / attribution | Original source | License |
| --- | --- | --- | --- |
| `rain.ogg` | rain ambience — alex36917; Blanket edit by Porrumentzio | https://freesound.org/people/alex36917/sounds/524605/ | CC BY 4.0 |
| `waves.ogg` | oceanwavescrushing.wav — Luftrum; Blanket edit by Porrumentzio | https://freesound.org/people/Luftrum/sounds/48412/ | CC BY 4.0 |
| `train.ogg` | Trains of the Yamanote Line — SDLx | https://freesound.org/people/SDLx/sounds/259988/ | CC BY 3.0 |
| `piano.ogg` | Pianosoft8 — Tozan | https://opengameart.org/content/pianosoft8 | CC0 |
| `bell.ogg` | Bell #1 — Joseph SARDIN | https://bigsoundbank.com/bell-1-s2113.html | CC0 |

License terms: https://creativecommons.org/licenses/by/4.0/ and https://creativecommons.org/licenses/by/3.0/ . CC0 terms are linked above. Blanket source and edit credits: https://github.com/rafaelmardojai/blanket/blob/master/SOUNDS_LICENSING.md . Downloaded files: `https://raw.githubusercontent.com/rafaelmardojai/blanket/master/data/resources/sounds/{rain,waves,train}.ogg`, `https://opengameart.org/sites/default/files/softpiano8.ogg`, `https://bigsoundbank.com/UPLOAD/ogg/2113.ogg`.

Updated tests cover 28 unique geometries and touch-target spacing, saved bag state, all difficulty levels and round counts, same-category Hard distractors, separate scene routes, answer gating, duplicate score prevention, and nine valid audio resources. Rendered screenshots cover the library, expanded patterns, and all three sound levels. Physical touchscreen and perceived audio quality still require device testing.

## Copy on blank canvas

In Connect the picture, choose **Copy on blank canvas** in the mode menu. The left reference is a numbered path; the right canvas has no target dots or guide lines. Tap to add vertices in reference order (mouse also works). Dots remain after release. Holding and dragging a touch moves its vertex; Undo removes the last vertex and Clear restarts the same pattern. Closed paths close automatically when the required number of dots is placed. Press Check pattern explicitly to submit.

Matching requires the same vertex count and compares the centered, uniformly scaled paths. Translation and uniform size changes are allowed; the orientation and proportions must match. Reverse traversal and a different starting vertex on closed shapes are accepted. A normalized RMS error of at most 0.18 and worst vertex error of 0.30 tolerate modest placement differences. Collapsed/tiny drawings and duplicate vertices are rejected. This is geometric matching, not a clinical assessment. Incorrect attempts show a gentle retry cue without losing points. Correct attempts award 100 points only once. Mode switching is disabled after success until the next round.

Tests include blank-canvas rendering, matching translated/scaled/reversed shapes, rejecting distorted/incomplete drawings, duplicate and outside taps, touch dragging and release retention, undo, pause, retry and one-time scoring. Screenshots: `.test-data/blank_pattern_start.png` and `.test-data/blank_pattern_correct.png`.

## Live finger / piece mode

Pattern drawing now opens in Live finger / piece mode. Five rounds show a triangle, square, rectangle, diamond and trapezoid. Hold three or four fingers in the blank right panel. Only current contacts are used: release removes a point and dragging moves it. The outline is formed from the convex hull, independent of touch IDs and arrival order. Automatic checking requires the exact contact count, all contacts inside the drawing area, and a matching shape for 0.65 seconds. Position and uniform size may vary; orientation and proportions must match. Incorrect arrangements give a gentle adjustment message without losing points. Success remains visible until Next. Changing input mode starts a new session. Mouse clicks do not simulate persistent contacts in this mode; use Copy on blank canvas for mouse practice.

The new tests/test_live_contacts.gd covers five shapes, reordered events, partial release, extra contacts, pause clearing, hold timing, wrong shapes and one-time scoring. Actual IR hardware and printed pieces remain unverified.
