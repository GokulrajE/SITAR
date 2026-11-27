extends SceneTree
## Pegboard set-up and Shape Match, driven by simulated IR-frame contacts.
## Never touches the real settings (Library.persist = false).
## Optional: pass a folder after "--" to save screenshots there.
const Library = preload("res://games/pegboard/scripts/peg_library.gd")
const Art = preload("res://games/pegboard/scripts/peg_art.gd")
## Canvas pixels read off the real touch frame (boards A, B and C of 70 mm).
const REAL := {
	"A": [Vector2(526, 284), Vector2(448, 297), Vector2(465, 359)],
	"B": [Vector2(981, 302), Vector2(1098, 296), Vector2(1058, 376)],
	"C": [Vector2(1046, 754), Vector2(985, 855), Vector2(983, 765)],
}
## Example boards for the simulation only (the real games record them).
const BOARDS := {
	"A": [Vector2(-18.5, -19.5), Vector2(-2.5, 22.5), Vector2(15.0, -2.5)],
	"B": [Vector2(22.5, 20.0), Vector2(-30.0, -3.0), Vector2(16.5, -22.5)],
	"C": [Vector2(4.0, -30.0), Vector2(-14.5, 10.0), Vector2(13.5, 25.5)],
}
var ids := 100
var down: Dictionary = {}
var shots := ""
var failed := false

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, what: String) -> void:
	if not ok:
		failed = true
		printerr("FAIL: ", what)

func legs(board: String, centre: Vector2, deg: float, noise := 0.0) -> Array:
	var out := []
	var k := 1920.0 / Library.DEFAULT_WIDTH_MM
	for p: Vector2 in BOARDS[board]:
		out.append(centre + (Vector2(p.x, -p.y) * k).rotated(deg_to_rad(deg)) + Vector2(randf_range(-noise, noise), randf_range(-noise, noise)) * k)
	return out

func put(s, board: String, centre: Vector2, deg := 0.0, noise := 0.0) -> void:
	down[board] = []
	for p in legs(board, centre, deg, noise):
		ids += 1
		s.tracker._down(ids, p)
		down[board].append(ids)

func lift(s, board: String) -> void:
	for i in down[board]:
		s.tracker._up(i)
	down.erase(board)

func run_for(s, secs: float) -> void:
	var t := 0.0
	while t < secs:
		s.tracker.update(0.05)
		if s.has_method("_advance") and s.state != "paused":
			s._t += 0.05
			s._advance()
		t += 0.05

func shot(s, file: String) -> void:
	if shots == "" or DisplayServer.get_name() == "headless":
		return
	for i in 4:
		s.queue_redraw()
		await process_frame
	await RenderingServer.frame_post_draw
	get_root().get_texture().get_image().save_png(shots + "/" + file + ".png")

func open(path: String):
	change_scene_to_file(path)
	for i in 3:
		await process_frame
	return current_scene

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		shots = args[0]
	Library.persist = false
	seed(7)
	test_recognition()
	await test_setup()
	await test_game()
	if failed:
		quit(1)
		return
	print("PASS: recorded recognition, recording rules, recording set-up, all five levels, flicker, early/wrong/resting boards, hints, results")
	quit()

## Records example board legs for objects, in slot order A, B, C, as set-up would.
func record_boards(lib, objects: Array) -> void:
	lib.clear()
	for i in objects.size():
		var pts: Array[Vector2] = []
		pts.assign(legs(["A", "B", "C"][i], Vector2(900, 500), 0.0))
		var r: Dictionary = lib.record(objects[i], pts, Library.DEFAULT_WIDTH_MM / 1920.0)
		check(r.get("slot", "") == ["A", "B", "C"][i], "recorded %s: %s" % [objects[i], r])

func test_recognition() -> void:
	var lib := Library.new()
	var k := Library.DEFAULT_WIDTH_MM / 1920.0
	check(lib.objects().is_empty(), "nothing is known before recording")
	var nothing: Array[Vector2] = []
	nothing.assign(REAL["A"])
	check(lib.identify(nothing, k).is_empty(), "no fixed board patterns")
	record_boards(lib, ["cup", "cone", "square"])
	for b in REAL:
		var p: Array[Vector2] = []
		p.assign(REAL[b])
		var r: Array = lib.identify(p, k)
		print("real board ", b, " -> ", r)
		check(r.size() == 3 and r[0] == b, "real contacts of board " + b)
		var mirror: Array[Vector2] = []
		for q in p:
			mirror.append(Vector2(-q.x, q.y))
		check(lib.identify(mirror, k).is_empty(), "mirrored board is rejected")
	var wrong := 0
	var missed := 0
	for n in 3000:
		var b: String = ["A", "B", "C"][n % 3]
		var p: Array[Vector2] = []
		p.assign(legs(b, Vector2(900, 500), randf() * 360.0, 1.5))
		var r: Array = lib.identify(p, k)
		if r.is_empty():
			missed += 1
		elif r[0] != b:
			wrong += 1
	print("3000 random placements, +-1.5 mm noise per leg: wrong ", wrong, ", unread ", missed)
	check(wrong == 0 and missed < 30, "noise robustness")
	# Recording rules.
	var again: Array[Vector2] = []
	again.assign(legs("B", Vector2(300, 300), 70.0))
	check(lib.record("cylinder", again, k).get("slot") == "B" and lib.object_of("B") == "cylinder" and lib.board_of("cone") == "",
		"the same board recorded with another object replaces it")
	var close: Array[Vector2] = []
	close.assign(legs("A", Vector2(300, 300), 0.0))
	close[0] += Vector2(14, 0)                       # about 7 mm off board A: too similar
	check(lib.record("cone", close, k).get("error") == "clash", "a too-similar board is refused")
	var tiny: Array[Vector2] = [Vector2(0, 0), Vector2(10, 0), Vector2(0, 10)]
	check(lib.record("cone", tiny, k).get("error") == "size", "three fingers close together are not a board")
	var fourth: Array[Vector2] = [Vector2(500, 500), Vector2(540, 500), Vector2(500, 620)]
	var full: Dictionary = lib.record("cone", fourth, k)
	check(full.get("error") == "full", "at most three boards: %s" % full)
	lib.forget("C")
	check(lib.record("cone", fourth, k).get("slot") == "C" and lib.objects().size() == 3, "a freed slot is reused")
	lib.clear()
	check(lib.objects().is_empty(), "start fresh forgets everything")

func setup_step(s, secs: float) -> void:
	var t := 0.0
	while t < secs:
		s.tracker.update(0.05)
		s._t += 0.05
		s.watch(0.05)
		t += 0.05

func test_setup() -> void:
	var s = await open("res://games/pegboard/scenes/peg_setup.tscn")
	s.set_process(false)
	s.tracker.set_process(false)
	s.lib.clear()
	await shot(s, "setup_empty")
	for pair in [["A", "cup"], ["B", "cone"], ["C", "square"], ["C", "cylinder"]]:
		put(s, pair[0], s.PAD + Vector2(20, -10), randf() * 360.0, 0.5)
		setup_step(s, 0.3)
		check(s.captured.is_empty(), "legs are captured only once they stand still")
		setup_step(s, 0.6)
		check(s.captured.size() == 3, "set-up captures the board's three legs")
		var at: Vector2 = s.icon_pos(Library.OBJECTS.keys().find(pair[1]))
		s.tracker._down(7, at)
		s.tracker.update(0.05)
		s.tracker._up(7)
		check(s.lib.object_of(pair[0]) == pair[1], "recorded %s as slot %s: %s" % [pair[1], pair[0], s.lib.assigned])
		if pair[1] == "square":
			await shot(s, "setup_ring")
		lift(s, pair[0])
		setup_step(s, 0.6)
		check(s.captured.is_empty(), "lifting clears the capture")
	check(Array(s.lib.objects()) == ["cup", "cone", "cylinder"], "re-recording replaces: %s" % [s.lib.objects()])
	# A recorded board is recognised again anywhere and in any direction.
	put(s, "B", Vector2(400, 400), 123.0)
	setup_step(s, 0.6)
	check(s.tracker.present.has("B"), "recorded board is recognised")
	lift(s, "B")
	# Tapping a card removes that recording; Start fresh removes all.
	var touch := InputEventScreenTouch.new()
	touch.pressed = true
	touch.position = s.card_rect(0).get_center()
	s._input(touch)
	check(s.lib.object_of("A") == "", "card tap removes a recording")
	s.start_fresh()
	check(s.lib.objects().is_empty(), "start fresh")

func test_game() -> void:
	var g = await open("res://games/pegboard/scenes/peg_match.tscn")
	g.lib.clear()
	g.start_game()
	check(g.state == "menu" and g.shell.state == "start", "cannot start without objects")
	record_boards(g.lib, ["cup", "cone", "square"])
	g._show_menu()
	g.start_game()
	check(g.state != "menu", "can start with objects")
	g._show_menu()
	g.set_process(false)
	g.tracker.set_process(false)
	await shot(g, "menu")
	var seen := {}
	for lv in 5:
		g.level = lv
		g.start_game()
		for rnd in g.ROUNDS:
			run_for(g, 0.1)
			if lv == 3:
				check(g.state == "show", "memory picture is shown")
				if rnd == 0:
					await shot(g, "l4_show")
				put(g, "A", g.PAD)          # too early: must not count
				run_for(g, 0.5)
				check(g.state == "show" and g._errors == 0, "early answer is ignored")
				lift(g, "A")
			if lv == 4:
				check(g.target.size() == (2 if rnd < 3 else 3), "sequence length")
			run_for(g, 5.6 if lv >= 3 else 0.2)
			check(g.state == "wait", "waiting for the player, is " + g.state)
			if rnd == 0:
				await shot(g, "l%d_wait" % (lv + 1))
			if rnd == 1:
				var bad: String = g.lib.objects().filter(func(o): return o != g.expected())[0]
				put(g, g.lib.board_of(bad), g.PAD, 50.0)
				run_for(g, 0.5)
				check(g.state == "wrong" and g._errors == 1, "wrong board is noticed")
				if lv == 0:
					await shot(g, "wrong")
				run_for(g, 6.0)                          # left standing: no second error
				check(g._errors == 1, "a resting wrong board counts once")
				lift(g, g.lib.board_of(bad))
				run_for(g, 0.7)
			if rnd == 2 and lv != 4:
				run_for(g, 10.5)
				check(g.hint, "hint after 10 quiet seconds")
			var steps: int = g.target.size()
			for n in steps:
				var b: String = g.lib.board_of(g.expected())
				seen[g.expected()] = true
				put(g, b, g.PAD, randf() * 360.0, 0.8)
				run_for(g, 0.5)
				var last: bool = n == steps - 1
				check(g.state == ("celebrate" if last else "wait"), "right board, round %d level %d, is %s" % [rnd, lv + 1, g.state])
				if last and rnd == 0 and lv in [0, 4]:
					g._move_confetti(0.3)
					await shot(g, "celebrate_l%d" % (lv + 1))
				# one leg drops out for half a second: still the same placement
				var id: int = down[b][0]
				var at: Vector2 = g.tracker._contacts[id].pos
				g.tracker._up(id)
				run_for(g, 0.5)
				check(g.tracker.present.has(b), "a flickering leg does not lift the board")
				g.tracker._down(id, at)
				if rnd == 0 and last:
					run_for(g, 3.0)                      # board left on the glass
					check(g.state == "clear", "next round waits until the board is lifted")
				lift(g, b)
				run_for(g, 0.7)
			if g.state == "celebrate":
				while g.state == "celebrate":
					run_for(g, 0.05)
		check(g.state == "done" and g.results.size() == 6, "level %d finishes, is %s" % [lv + 1, g.state])
		check(g.first_try() == (5 if lv == 4 else 4), "first-try count, level %d = %d" % [lv + 1, g.first_try()])
		for r in g.results:
			check(r.seconds < 30.0 and r.seconds >= 0.0, "plausible answer time")
	run_for(g, 2.0)
	await shot(g, "done")
	check(seen.size() == 3, "all objects are used")
	g.start_game()
	g._toggle_pause()
	check(g.state == "paused", "pause")
	g._toggle_pause()
	check(g.state != "paused", "continue")
	# every optional picture can be replaced by artwork
	var pic := ImageTexture.create_from_image(Image.create(64, 64, false, Image.FORMAT_RGBA8))
	var files := ["bg_meadow.png", "target_card.png", "placement_pad.png", "speech_bubble.png",
		"vfx_correct_burst_4x4.png", "vfx_try_again_4x4.png", "vfx_level_complete_4x4.png"]
	for mood in ["idle", "think", "happy", "oops", "cheer"]:
		files.append("pip_%s_4x4.png" % mood)
	for f in files:
		Art._cache[f] = pic
	put(g, "A", g.PAD)
	run_for(g, 0.5)
	for st in ["menu", "wait", "wrong", "celebrate", "done"]:
		g.state = st
		g._wrong_object = "cup"
		g.target = ["cup"] as Array[String]
		g.level = 0
		g._state_at = g._t
		g.queue_redraw()
		await process_frame
		await process_frame
	Art._cache.clear()
