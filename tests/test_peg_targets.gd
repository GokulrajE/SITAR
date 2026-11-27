extends SceneTree
## Shape Spots and Hand & Shape, driven by simulated IR-frame contacts.
## Also checks that Shape Match reads boards only on its pad.
const Library = preload("res://games/pegboard/scripts/peg_library.gd")
const Art = preload("res://games/pegboard/scripts/peg_art.gd")
## Example boards for the simulation only (the real games record them).
const BOARDS := {
	"A": [Vector2(-18.5, -19.5), Vector2(-2.5, 22.5), Vector2(15.0, -2.5)],
	"B": [Vector2(22.5, 20.0), Vector2(-30.0, -3.0), Vector2(16.5, -22.5)],
	"C": [Vector2(4.0, -30.0), Vector2(-14.5, 10.0), Vector2(13.5, 25.5)],
}
var ids := 500
var down: Dictionary = {}


func _initialize() -> void:
	call_deferred("run")


func put(g, board: String, centre: Vector2, deg := 0.0) -> void:
	var k := 1920.0 / Library.DEFAULT_WIDTH_MM
	down[board] = []
	for p: Vector2 in BOARDS[board]:
		ids += 1
		g.tracker._down(ids, centre + (Vector2(p.x, -p.y) * k).rotated(deg_to_rad(deg)))
		down[board].append(ids)


func lift(g, board: String) -> void:
	for i in down.get(board, []):
		g.tracker._up(i)
	down.erase(board)


func tap(g, at: Vector2) -> void:
	ids += 1
	g.tracker._down(ids, at)
	g.tracker.update(0.05)
	g.tracker._up(ids)


func run_for(g, secs: float) -> void:
	var t := 0.0
	while t < secs:
		g.tracker.update(0.05)
		g._t += 0.05
		if "playing" in g and g.playing and not g.paused:
			g.step(0.05)
		t += 0.05


func open(path: String):
	change_scene_to_file(path)
	for i in 3:
		await process_frame
	var g = current_scene
	g.set_process(false)
	g.tracker.set_process(false)
	return g


func setup_boards(g) -> void:
	record_boards(g.lib, ["cup", "cone", "cylinder"])

## Records example board legs for objects, in slot order A, B, C, as set-up would.
func record_boards(lib, objects: Array) -> void:
	lib.clear()
	var k := 1920.0 / Library.DEFAULT_WIDTH_MM
	for i in objects.size():
		var pts: Array[Vector2] = []
		for p: Vector2 in BOARDS[["A", "B", "C"][i]]:
			pts.append(Vector2(900, 500) + Vector2(p.x, -p.y) * k)
		var r: Dictionary = lib.record(objects[i], pts, 1.0 / k)
		assert(r.get("slot", "") == ["A", "B", "C"][i], str(r))


func run() -> void:
	Library.persist = false
	root.size = Vector2i(1920, 1080)

	# ---- Shape Match: only the pad reads boards; boards put down elsewhere are ignored.
	var m = await open("res://games/pegboard/scenes/peg_match.tscn")
	setup_boards(m)
	put(m, "A", Vector2(300, 950))
	put(m, "B", Vector2(400, 500))
	run_for(m, 1.0)
	assert(m.tracker.present.is_empty(), "Boards off the pad are not read")
	put(m, "C", m.PAD)
	run_for(m, 1.0)
	assert(m.tracker.present.has("C"), "The pad reads boards")
	lift(m, "A"); lift(m, "B"); lift(m, "C")

	# ---- Shape Spots
	var g = await open("res://games/pegboard/scenes/shape_spots.tscn")
	setup_boards(g)
	g.shell.choose_level(0)
	g.shell.begin()
	assert(g.playing)
	run_for(g, 1.0)
	assert(g.live().size() == 1, "One spot at a time")
	var spot: Dictionary = g.live()[0]
	# No rest area: boards put down away from the spot rest there and never count.
	var corners := [Vector2(90, 1000), Vector2(1830, 1000), Vector2(90, 200)]
	for i in 3:
		if spot.pos.distance_to(corners[i]) < 300.0: corners[i] = Vector2(960, 1000)
		put(g, ["A", "B", "C"][i], corners[i])
	run_for(g, 2.0)
	assert(g.tracker.present.size() == 3 and g.caught == 0 and g.errors == 0)
	for b in ["A", "B", "C"]: assert(g.resting(b), "standing still means resting")
	for b in ["A", "B", "C"]: lift(g, b)
	# A wrong board on the spot counts once; the right one catches it.
	var right: String = g.lib.board_of(spot.kind)
	var wrong: String = "A" if right != "A" else "B"
	put(g, wrong, spot.pos, 40.0)
	run_for(g, 1.0)
	assert(g.errors == 1 and g.caught == 0, "Wrong board is one error")
	run_for(g, 1.0)
	assert(g.errors == 1, "A standing wrong board is not counted again")
	lift(g, wrong)
	run_for(g, 1.0)
	put(g, right, spot.pos + Vector2(30, -20), 120.0)
	run_for(g, 0.6)
	assert(g.caught == 1, "Right board catches the spot")
	# Play the rest; every spot is new and the session ends with results.
	var guard := 0
	while g.playing and guard < 40:
		guard += 1
		run_for(g, 1.2)
		lift(g, right)
		run_for(g, 1.0)
		if g.live().is_empty(): continue
		var s: Dictionary = g.live()[0]
		assert(s.pos.distance_to(spot.pos) > 1.0)
		spot = s
		right = g.lib.board_of(s.kind)
		put(g, right, s.pos)
	run_for(g, 1.0)
	assert(not g.playing and g.caught == 8 and g.shell.state == "results", "Session of 8 spots")
	assert(g.stars() == 3)
	lift(g, right)

	# Level 2: two spots at once, in any order.
	g.shell.choose_level(1)
	g.shell.begin()
	run_for(g, 1.0)
	var pair: Array = g.live()
	assert(pair.size() == 2 and pair[0].kind != pair[1].kind, "Two different spots")
	put(g, g.lib.board_of(pair[1].kind), pair[1].pos)
	run_for(g, 1.0)
	assert(g.caught == 1 and g.live().size() == 1, "The pair waits until both are done")
	# Level 3: a spot moves on by itself and counts as missed.
	g.shell._show("start")
	g.shell.choose_level(2)
	g.shell.begin()
	for b in down.keys(): lift(g, b)
	run_for(g, 9.5)
	assert(g.missed == 1 and g.spawned >= 2, "Quick spots move on")
	# Pause freezes the clock.
	g.shell.pause()
	var was: int = g.missed
	run_for(g, 20.0)
	assert(g.missed == was)
	g.shell.resume()

	# ---- Hand & Shape
	var h = await open("res://games/pegboard/scenes/hand_and_shape.tscn")
	setup_boards(h)
	h._rng.seed = 3
	h.shell.choose_level(0)
	h.shell.begin()
	run_for(h, 3.0)
	assert(h.live().size() == 2, "Two bubbles at a time on Gentle")
	for b in h.live():
		assert(h.BOUNDS.grow(1).has_point(b.pos))
	var start_pos: Vector2 = h.live()[0].pos
	run_for(h, 1.0)
	assert(h.live()[0].pos.distance_to(start_pos) > 10.0, "Bubbles drift")
	# A resting board that does not match makes a bubble bounce, with no error.
	var bub: Dictionary = h.live()[0]
	var other: String = "A" if h.lib.object_of("A") != bub.kind else "B"
	put(h, other, Vector2(960, 600))
	for i in 8: h.tracker.update(0.05)          # confirm the board without moving bubbles
	h._still[other] = {"pos": h.tracker.present[other].centre, "since": h._t - 5.0}
	bub.pos = Vector2(960 - h.R - 60, 600)
	bub.vel = Vector2(40, 0)
	h._drift(bub, 0.05)
	assert(bub.vel.x < 0.0 and h.errors == 0, "bubble bounces off a resting board")
	lift(h, other)
	run_for(h, 0.6)
	# Taps catch hand bubbles; a tap on an object bubble does not.
	var guard2 := 0
	while h.playing and guard2 < 200:
		guard2 += 1
		for b in h.live():
			if b.kind == h.HAND:
				tap(h, b.pos)
			else:
				var before: int = h.caught
				tap(h, b.pos)
				assert(h.caught == before, "Object bubbles need the board")
				var board: String = h.lib.board_of(b.kind)
				put(h, board, b.pos)
				run_for(h, 0.5)
				lift(h, board)
		run_for(h, 0.6)
	assert(not h.playing and h.caught == 12 and h.stars() == 3, "All 12 caught")
	# Unpicked bubbles float away and count as missed.
	h.shell.choose_level(2)
	h.shell.begin()
	run_for(h, 60.0)
	assert(not h.playing and h.caught == 0 and h.missed == 16 and h.stars() == 1)
	print("PASS: Shape Match pad-only, no rest area, resting boards ignored, bubbles bounce off resting boards, Shape Spots (one, pair, quick, errors, pause), Hand & Shape (drift, hand taps, board catches, misses)")
	quit()
