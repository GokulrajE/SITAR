extends Control
## Two pegboard games that use the whole screen. There is no rest area: a board
## can be put down anywhere. Once it stands still it is "resting": it is never
## counted as a wrong answer, new spots appear away from it, and bubbles that
## do not match it bounce off it.
##   game 0  Shape Spots:  a spot shows an object; stand that board on it.
##   game 1  Hand & Shape: bubbles drift by; tap hand bubbles with a finger,
##                         catch object bubbles with that board.

const Library = preload("res://games/pegboard/scripts/peg_library.gd")
const Tracker = preload("res://games/pegboard/scripts/peg_tracker.gd")
const Art = preload("res://games/pegboard/scripts/peg_art.gd")
const Sfx = preload("res://games/dosa/scripts/sfx.gd")
const Shell = preload("res://scripts/shared/game_shell.gd")
const ICONS := preload("res://assets/images/cognitive/shared/ui_icons_4x4.png")
const CHIME := "res://assets/images/dosa_early_late_vfx_and_sounds/sounds/03_perfect_pick_chime.wav"
const SAVE := "user://peg_targets_progress.cfg"

const HAND := "hand"
const R := 118.0                                    # target radius (a board plate is ~85 px)
## Centres stay here: below the status pill, clear of the screen edges.
const BOUNDS := Rect2(150, 240, 1620, 700)
const SPOT_AREA := BOUNDS
const REST_AFTER := 1.5                             # seconds still before a board is resting
const HINT_AFTER := 10.0
## Shape Spots: spots per session, spots at once, seconds before a spot moves on (0 = waits).
const SPOTS := [{"total": 8, "at_once": 1, "life": 0.0}, {"total": 10, "at_once": 2, "life": 0.0},
	{"total": 10, "at_once": 1, "life": 8.0}]
## Hand & Shape: targets per session, on screen at once, drift speed, seconds on screen.
const BUBBLES := [{"total": 12, "at_once": 2, "speed": 38.0, "life": 14.0}, {"total": 14, "at_once": 3, "speed": 58.0, "life": 11.0},
	{"total": 16, "at_once": 4, "speed": 80.0, "life": 8.0}]

@export_range(0, 1) var game := 0

var lib := Library.new()
var tracker: Node
var shell: Control
var level := 0
var playing := false
var paused := false
var targets: Array = []          # {pos, vel, kind, born, life, caught_at, gone, shake}
var spawned := 0
var caught := 0
var missed := 0
var errors := 0
var _t := 0.0
var _spawn_in := 0.0
var _wrong: Dictionary = {}      # board -> target it was wrongly placed on
var _still: Dictionary = {}      # board -> {"pos", "since"}: where and since when it stands still
var _last_pos := Vector2(-999, -999)
var _last_kind := ""
var _sparks: Array = []
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_rng.randomize()
	tracker = Tracker.new()
	tracker.lib = lib
	tracker.area = Rect2(0, 110, 1920, 970)
	add_child(tracker)
	tracker.tapped.connect(_on_tapped)
	tracker.unsure.connect(_on_unsure)
	shell = Shell.new()
	if game == 0:
		shell.title = "Shape Spots"
		shell.levels = ["One spot", "Two spots", "Quick spots"]
		shell.notes = ["One at a time, no clock", "Two at once, any order", "A spot moves on after 8 s"]
		shell.accent = Art.TEAL
	else:
		shell.title = "Hand & Shape"
		shell.levels = ["Gentle", "Busier", "Quick"]
		shell.notes = ["Two bubbles, slow", "Three bubbles", "Four bubbles, faster"]
		shell.accent = Color("2b7bb9")
	shell.dim = 0.3
	shell.extra = "Record boards"
	add_child(shell)
	shell.start_pressed.connect(start)
	shell.pause_changed.connect(func(value: bool): paused = value)
	shell.stop_pressed.connect(func(): playing = false; targets.clear())
	shell.extra_pressed.connect(_open_setup)


func settings() -> Dictionary:
	return SPOTS[level] if game == 0 else BUBBLES[level]


func start(chosen: int) -> void:
	level = chosen
	var need := 2 if game == 0 else 1
	if lib.objects().size() < need:
		shell.show_start()
		shell.toast("First record %s" % ("two boards" if need == 2 else "a board"), false)
		return
	targets.clear()
	_sparks.clear()
	_wrong.clear()
	spawned = 0
	caught = 0
	missed = 0
	errors = 0
	_spawn_in = 0.4
	_last_kind = ""
	playing = true
	paused = false
	_update_status()


# ------------------------------------------------------------------ play ---

func _process(delta: float) -> void:
	_t += delta
	if playing and not paused:
		step(delta)
	for s in _sparks:
		s.age += delta
		s.p += s.v * delta
		s.v.y += 300.0 * delta
	_sparks = _sparks.filter(func(s): return s.age < 0.9)
	queue_redraw()


func step(delta: float) -> void:
	var cfg := settings()
	for t in live():
		t.shake = maxf(0.0, t.shake - delta)
		if game == 1:
			_drift(t, delta)
		if cfg.life > 0.0 and _t - t.born > cfg.life:
			t.gone = _t
			missed += 1
	targets = targets.filter(func(t): return t.gone < 0.0 or _t - t.gone < 0.6)
	_check_boards()
	if game == 0:
		# Spots come as a whole wave (one, or a pair) once the last wave is done.
		if spawned < cfg.total and live().is_empty():
			_spawn_in -= delta
			if _spawn_in <= 0.0:
				for i in mini(cfg.at_once, cfg.total - spawned):
					_spawn()
				_spawn_in = 0.8
	elif spawned < cfg.total and live().size() < cfg.at_once:
		_spawn_in -= delta
		if _spawn_in <= 0.0:
			_spawn()
			_spawn_in = 1.4 - level * 0.3
	_update_status()
	if spawned >= cfg.total and live().is_empty() and targets.is_empty():
		_finish()


func live() -> Array:
	return targets.filter(func(t): return t.gone < 0.0)


func _spawn() -> void:
	var kinds := lib.objects()
	var kind := ""
	if game == 1 and (kinds.is_empty() or _rng.randf() < 0.5):
		kind = HAND
	else:
		var used := live().map(func(t): return t.kind)
		var fresh := kinds.filter(func(k): return k != _last_kind and k not in used)
		if fresh.is_empty():
			fresh = kinds.filter(func(k): return k not in used)
		if fresh.is_empty():
			fresh = kinds
		kind = fresh[_rng.randi() % fresh.size()]
	_last_kind = kind
	var pos := _free_spot()
	var vel := Vector2.from_angle(_rng.randf() * TAU) * float(settings().get("speed", 0.0))
	var life: float = settings().life
	targets.append({"pos": pos, "vel": vel, "kind": kind, "born": _t, "life": life, "caught_at": -1.0, "gone": -1.0, "shake": 0.0})
	_last_pos = pos
	spawned += 1


## A place away from other targets, standing boards and the last spot.
func _free_spot() -> Vector2:
	var area := SPOT_AREA if game == 0 else BOUNDS
	var best := area.get_center()
	var best_room := -1.0
	for i in 40:
		var p := Vector2(_rng.randf_range(area.position.x, area.end.x), _rng.randf_range(area.position.y, area.end.y))
		var room := p.distance_to(_last_pos) * 0.5
		for t in live():
			room = minf(room, p.distance_to(t.pos) - R * 2.4)
		for b in tracker.present:
			room = minf(room, p.distance_to(tracker.present[b].centre) - R * 2.0)
		if room > 260.0:
			return p
		if room > best_room:
			best_room = room
			best = p
	return best


func _drift(t: Dictionary, delta: float) -> void:
	if t.caught_at >= 0.0:
		return
	t.pos += t.vel * delta
	if t.pos.x < BOUNDS.position.x or t.pos.x > BOUNDS.end.x:
		t.vel.x = -t.vel.x
	if t.pos.y < BOUNDS.position.y or t.pos.y > BOUNDS.end.y:
		t.vel.y = -t.vel.y
	t.pos = t.pos.clamp(BOUNDS.position, BOUNDS.end)
	t.pos.y += sin(_t * 1.7 + t.born) * 8.0 * delta      # a gentle bob
	# Bounce off resting boards that cannot catch this bubble.
	for b in tracker.present:
		if lib.object_of(b) == t.kind or not resting(b):
			continue
		var away: Vector2 = t.pos - tracker.present[b].centre
		if away.length() < R + 70.0 and t.vel.dot(away) < 0.0:
			t.vel = t.vel.bounce(away.normalized())


## True when the board has stood still long enough to be put down, not played.
func resting(b: String) -> bool:
	return _still.has(b) and _t - float(_still[b].since) >= REST_AFTER


func _track_still() -> void:
	for b in _still.keys():
		if not tracker.present.has(b):
			_still.erase(b)
	for b in tracker.present:
		var at: Vector2 = tracker.present[b].centre
		if not _still.has(b) or at.distance_to(_still[b].pos) > 25.0:
			_still[b] = {"pos": at, "since": _t}


## Boards standing on targets. Checked every frame, so a board can also be
## slid onto a spot, or wait for a bubble to drift under it. A resting board
## is never a wrong answer.
func _check_boards() -> void:
	_track_still()
	for b in tracker.present:
		var at: Vector2 = tracker.present[b].centre
		var object: String = lib.object_of(b)
		var on: Dictionary = {}
		for t in live():
			if t.caught_at < 0.0 and t.pos.distance_to(at) < R:
				on = t
				break
		if on.is_empty():
			_wrong.erase(b)
			continue
		if on.kind == object:
			_catch(on)
			_wrong.erase(b)
		elif not resting(b) and not is_same(_wrong.get(b), on):
			_wrong[b] = on
			errors += 1
			on.shake = 0.5
			Sfx.play(get_tree(), "res://assets/audio/error_001.ogg", -8.0)
			if on.kind == HAND:
				shell.toast("Tap this one with your hand", false)
			elif object == "":
				shell.toast("Board %s has no object yet" % b, false)
			else:
				shell.toast("That is the %s" % Library.name_of(object).to_lower(), false)


func _on_tapped(p: Vector2) -> void:
	if not playing or paused:
		return
	for t in live():
		if t.caught_at < 0.0 and t.pos.distance_to(p) < R * 1.15:
			if t.kind == HAND:
				_catch(t)
			elif game == 1:
				t.shake = 0.4
				shell.toast("Use the %s for this one" % Library.name_of(t.kind).to_lower(), false)
			return


func _on_unsure(_centre: Vector2) -> void:
	if playing and not paused:
		shell.toast("Press the board down flat", false)


func _catch(t: Dictionary) -> void:
	t.caught_at = _t
	t.gone = _t
	caught += 1
	Sfx.play(get_tree(), CHIME if game == 0 or t.kind != HAND else "res://assets/audio/select_001.ogg")
	for i in 22:
		_sparks.append({"p": t.pos, "v": Vector2.from_angle(_rng.randf() * TAU) * _rng.randf_range(160, 420) + Vector2(0, -120),
			"age": 0.0, "c": [Art.GOLD, Art.TEAL, Color("ff8a65"), Color.WHITE][i % 4]})
	if game == 0 and caught % 3 == 0:
		shell.toast(["Well done!", "Great!", "Wonderful!"][int(caught / 3.0) % 3])


func _update_status() -> void:
	if not playing:
		return
	var total: int = settings().total
	var word := "Spots" if game == 0 else "Caught"
	shell.set_status("%s %d of %d" % [word, caught + missed if game == 0 else caught, total])


func stars() -> int:
	if game == 0:
		var slips := errors + missed * 2
		return 3 if slips <= 1 else (2 if slips <= 4 else 1)
	var share := float(caught) / float(settings().total)
	return 3 if share >= 0.85 else (2 if share >= 0.6 else 1)


func _finish() -> void:
	playing = false
	var got := stars()
	var key := "%d_%d" % [game, level]
	var config := ConfigFile.new()
	var best := 0
	if Library.persist:
		config.load(SAVE)
		best = maxi(int(config.get_value("best", key, 0)), caught)
		config.set_value("best", key, best)
		config.save(SAVE)
	var total: int = settings().total
	var line := "%d of %d" % [caught, total]
	line += ("  •  %d wrong board%s" % [errors, "" if errors == 1 else "s"]) if errors > 0 else "  •  no wrong boards"
	if best > 0:
		line += "  •  best %d" % best
	shell.finish(got, "Level %d complete!" % (level + 1), line)


## A spot that has waited a long time shows its object's name as a hint.
func hinted(t: Dictionary) -> bool:
	return game == 0 and t.gone < 0.0 and t.life <= 0.0 and _t - t.born > HINT_AFTER


# --------------------------------------------------------------- drawing ---

func _draw() -> void:
	if game == 0:
		Art.background(self, size, _t)
	else:
		_draw_pond()
	for t in targets:
		_draw_target(t)
	for b in tracker.present:                        # standing boards
		var p: Vector2 = tracker.present[b].centre
		draw_arc(p, 92.0, 0, TAU, 64, Color(Library.color_of(lib.object_of(b)), 0.9), 8, true)
	for s in _sparks:
		Art.draw_star(self, s.p, 14.0, Color(s.c, 1.0 - s.age / 0.9), s.age * 6.0)


func _draw_pond() -> void:
	draw_polygon(PackedVector2Array([Vector2.ZERO, Vector2(size.x, 0), size, Vector2(0, size.y)]),
		PackedColorArray([Color("8fd3f4"), Color("8fd3f4"), Color("1f6f9a"), Color("1f6f9a")]))
	for i in 5:                                       # soft light rays
		var x := 200.0 + i * 380.0 + sin(_t * 0.3 + i) * 40.0
		draw_colored_polygon(PackedVector2Array([Vector2(x, 0), Vector2(x + 120, 0), Vector2(x - 60, size.y), Vector2(x - 220, size.y)]),
			Color(1, 1, 1, 0.06))
	for i in 18:                                      # tiny rising bubbles
		var y := fposmod(size.y - (_t * (24.0 + i * 3.0) + i * 140.0), size.y + 60.0) - 30.0
		var x := fmod(i * 233.0 + 70.0, size.x) + sin(_t + i) * 12.0
		draw_arc(Vector2(x, y), 5.0 + i % 4 * 3.0, 0, TAU, 16, Color(1, 1, 1, 0.35), 2, true)
	for i in 7:                                       # sea grass at the bottom
		var x := 60.0 + i * 300.0
		var sway := sin(_t * 0.9 + i) * 26.0
		draw_polyline(PackedVector2Array([Vector2(x, size.y), Vector2(x + sway * 0.5, size.y - 90), Vector2(x + sway, size.y - 180)]),
			Color("2e8b57"), 14, true)


func _draw_target(t: Dictionary) -> void:
	var p: Vector2 = t.pos + Vector2(sin(t.shake * 40.0) * 14.0 * t.shake * 2.0, 0)
	var fade := 1.0
	if t.gone >= 0.0:
		var k: float = (_t - t.gone) / 0.6
		fade = 1.0 - k
		if t.caught_at >= 0.0:
			for i in 2:
				draw_arc(p, R * (1.0 + k * (0.8 + i * 0.5)), 0, TAU, 64, Color(Art.GOLD, fade), 10, true)
	elif t.life > 0.0:
		fade = clampf((t.born + t.life - _t) / 2.0, 0.25, 1.0)
	var pop := clampf((_t - t.born) * 4.0, 0.0, 1.0)
	var r := R * (0.6 + 0.4 * pop)
	var hand: bool = t.kind == HAND
	var col: Color = Color("ffe082") if hand else Library.color_of(t.kind)
	if game == 0:
		draw_circle(p, r, Color(1, 1, 1, 0.92 * fade))
		var spin := _t * 0.6
		for d in 16:
			var a := spin + d * TAU / 16.0
			draw_arc(p, r, a, a + TAU / 32.0, 6, Color(Art.TEAL, fade), 9, true)
		Art.draw_object(self, t.kind, p, r * 1.45, Color(1, 1, 1, fade))
		if hinted(t):
			var k := 0.5 + 0.5 * sin(_t * 4.0)
			draw_arc(p, r + 14 + 6 * k, 0, TAU, 64, Color(Art.GOLD, 0.8), 8, true)
			Art.panel(self, Rect2(p + Vector2(-130, r + 14), Vector2(260, 56)), Color.WHITE, Art.GOLD, 20, 3)
			Art.text(self, Library.name_of(t.kind), p + Vector2(0, r + 42), 30, Art.INK, 250)
		if t.life > 0.0 and t.gone < 0.0:
			var left: float = clampf(1.0 - (_t - t.born) / t.life, 0.0, 1.0)
			draw_arc(p, r + 16, -PI / 2, -PI / 2 + TAU * left, 48, Color(Art.GOLD, fade), 8, true)
	else:
		draw_circle(p, r, Color(col, 0.28 * fade))
		draw_arc(p, r, 0, TAU, 64, Color(1, 1, 1, 0.85 * fade), 6, true)
		draw_arc(p, r * 0.78, -2.4, -1.6, 12, Color(1, 1, 1, 0.6 * fade), 8, true)   # shine
		if hand:
			var side := r * 1.2
			draw_texture_rect_region(ICONS, Rect2(p - Vector2.ONE * side / 2, Vector2.ONE * side), Rect2(0, 768, 256, 256), Color(1, 1, 1, fade))
		else:
			Art.draw_object(self, t.kind, p, r * 1.4, Color(1, 1, 1, fade))


func _open_setup() -> void:
	preload("res://games/pegboard/scripts/peg_setup.gd").back_to = scene_file_path
	get_tree().change_scene_to_file("res://games/pegboard/scenes/peg_setup.tscn")
