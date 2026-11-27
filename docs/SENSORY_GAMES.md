# Connect & Draw and Listen & Discover

Two separate games under Perception in the library, each with its own scene and the shared game shell (level cards, Start, Pause, results). Both work offline. F11 toggles fullscreen. Map the USB frame to the TV display in the operating system.

## Connect & Draw

Lines and dots only; no pictures. 28 patterns from `pattern_catalog.gd` with 3–8 points, smaller ones first. Six patterns per session.

- **Connect:** numbered dots on a large sheet; tap them in order. The next dot glows. A wrong dot shakes and names the number to find.
- **Copy:** the pattern sits on a small guide card; tap dots on a blank grid in the same order. The copy is checked by itself when enough dots are placed. Position and size may differ; shape and order may not (`pattern_matcher.gd`). A wrong copy turns red and clears itself.
- **From memory:** like Copy, but the guide shows for 4 seconds, then hides.

Two touches within 0.25 s count as one. Best scores per level are in `user://sensory_progress.cfg`. Holding several fingers at once was removed: it is hard for many patients and depends on multi-touch from the IR frame.

## Sound identification levels

| Difficulty | Choices | Rounds | Clip length | Content |
| --- | --- | --- | --- | --- |
| Easy | 2 | 4 | Up to 7 seconds | Bird, guitar, telephone, car |
| Medium | 3 | 6 | Up to 7 seconds | Six unique rounds drawn from all nine recordings |
| Hard | 4 | 9 | Up to 3 seconds | All nine recordings; choices prioritize similar sources from the same category |

The full collection is bird, rain, waves, guitar, piano, telephone, bell, car and train. Guitar's original clip is shorter than the maximum. Each session shuffles sounds without repeats. Hard includes comparisons such as guitar/piano, car/train and rain/waves. After a completed level the results offer Next level; every level can also be chosen on the start screen. Best scores are saved independently for each difficulty; the old unlevelled sound score is retained but not compared with new scores.

Each sound plays by itself when the round starts and again after a wrong answer; the big speaker replays it at any time. Wrong answers fade that picture. Clips stop on pause, navigation or correct answers. The next round follows by itself. There is no microphone capture or speech recognition.

There is no countdown, failure state, or flashing animation. Large targets, visible numbers, pause, end game and replay are included. Color is never the only cue. Escape or application focus loss pauses. Scores persist separately for each game in `user://sensory_progress.cfg`; these are game scores, not clinical assessments.

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
