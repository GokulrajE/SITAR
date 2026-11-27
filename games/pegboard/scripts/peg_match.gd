extends Control
## Shape Match: an object appears, the player places the board carrying it.
##
##   1 Match      picture + name
##   2 Shape only picture without colour or name
##   3 Clues      a sentence describes the object
##   4 Remember   the picture hides before the player may answer
##   5 Sequence   two, later three objects in order
##
## Nothing is timed out and nothing is lost: a wrong board gets a gentle
## explanation, and a hint appears after 2 errors or 10 quiet seconds.

const Library = preload("res://games/pegboard/scripts/peg_library.gd")
const Tracker = preload("res://games/pegboard/scripts/peg_tracker.gd")
const Art = preload("res://games/pegboard/scripts/peg_art.gd")
const Sfx = preload("res://games/dosa/scripts/sfx.gd")
const Shell = preload("res://scripts/shared/game_shell.gd")

const LEVELS := ["Match", "Shape only", "Clues", "Remember", "Sequence"]
const ROUNDS := 6
const SHOW_SECS := 3.0
const SEQUENCE_SECS := 1.6
const BLANK_SECS := 2.0
const HINT_AFTER := 10.0
const HINT_ERRORS := 2
const WRONG_SECS := 2.6
const CELEBRATE_SECS := 2.4
const GOOD := ["Well done!", "Great!", "That's right!", "Wonderful!", "You found it!"]
const CHIME := "res://assets/images/dosa_early_late_vfx_and_sounds/sounds/03_perfect_pick_chime.wav"

## Left to right: the shape to find, the detection pad, then Pip.
const CARD := Rect2(110, 220, 600, 600)
const PAD := Vector2(1040, 540)
const PAD_R := 230.0
const PIP := Vector2(1640, 720)

var lib := Library.new()
var tracker: Node

## menu, clear (boards must be lifted), show, blank, wait, celebrate, wrong, done, paused
var state := "menu"
var level := 0
var round_no := 0
var target: Array[String] = []
var step := 0
var results: Array = []
var hint := false

var _t := 0.0
var _state_at := 0.0
var _clear_next := ""                      # state to enter once the glass is empty
var _wait_at := 0.0
var _waited := 0.0                         # answer time so far in this round
var _errors := 0
var _hints := 0
var _paused_from := ""
var _bag: Array[String] = []
var _mood := "idle"
var _say := ""
var _wrong_object := ""
var _burst_at := Vector2.ZERO
var _confetti: Array = []
var shell: Control
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_rng.randomize()
	tracker = Tracker.new()
	tracker.lib = lib
	# Only the pad reads boards; boards put down anywhere else do not count.
	tracker.area = Rect2(PAD - Vector2.ONE * (PAD_R + 30), Vector2.ONE * (PAD_R + 30) * 2)
	add_child(tracker)
	tracker.placed.connect(_on_placed)
	tracker.lifted.connect(_on_lifted)
	tracker.unsure.connect(_on_unsure)
	shell = Shell.new()
	shell.title = "Shape Match"
	shell.levels = LEVELS
	shell.notes = ["Same object", "Colour hidden", "Read a clue", "Remember it", "In order"]
	shell.accent = Art.TEAL
	shell.extra = "Record boards"
	shell.dim = 0.3
	add_child(shell)
	shell.start_pressed.connect(func(chosen: int):
		level = chosen
		start_game())
	shell.pause_changed.connect(func(_paused: bool): _toggle_pause())
	shell.stop_pressed.connect(_show_menu)
	shell.extra_pressed.connect(_open_setup)
	_show_menu()


func _process(delta: float) -> void:
	if state != "paused":
		_t += delta
		_advance()
		_move_confetti(delta)
	queue_redraw()


# -------------------------------------------------------------- menus -----

func _show_menu() -> void:
	_confetti.clear()
	_go("menu")
	_talk("", "idle")


func _toggle_pause() -> void:
	if state == "paused":
		state = _paused_from
	elif state not in ["menu", "done"]:
		_paused_from = state
		state = "paused"


# -------------------------------------------------------------- rounds ----

func start_game() -> void:
	if lib.objects().size() < 2:
		shell.show_start()
		shell.toast("First record at least two boards", false)
		return
	round_no = 0
	results.clear()
	_bag.clear()
	_confetti.clear()
	_next_round()


func _next_round() -> void:
	round_no += 1
	if round_no > ROUNDS:
		_finish()
		return
	var count := 1
	if level == 4:
		count = 2 if round_no <= 3 or lib.objects().size() < 3 else 3
	var picked: Array[String] = []
	while picked.size() < count:
		picked.append(_draw_from_bag(picked))
	target = picked
	step = 0
	hint = false
	_errors = 0
	_hints = 0
	_waited = 0.0
	_clear_then("show")


## Every object comes up equally often, never twice in a row.
func _draw_from_bag(taken: Array[String]) -> String:
	var last := ""
	if taken.is_empty() and not results.is_empty():
		last = results.back().target.back()
	var ok := func(o: String) -> bool: return o != last and not taken.has(o)
	var fresh: Array = _bag.filter(ok)
	if fresh.is_empty():
		_bag.append_array(lib.objects())
		fresh = _bag.filter(ok)
	var o: String = fresh[_rng.randi() % fresh.size()]
	_bag.erase(o)
	return o


func _go(s: String) -> void:
	state = s
	_state_at = _t

func _in_state() -> float:
	return _t - _state_at

func _talk(s: String, mood := "") -> void:
	_say = s
	if mood != "":
		_mood = mood


func _clear_then(next: String) -> void:
	_clear_next = next
	_go("clear")
	if not tracker.present.is_empty():
		_talk("Take the board off the circle.", "idle")


func _advance() -> void:
	match state:
		"clear":
			if tracker.present.is_empty():
				if _clear_next == "show":
					_begin_show()
				else:
					_begin_wait()
		"show":
			if level == 3 and _in_state() >= SHOW_SECS:
				_talk("Keep it in mind...", "think")
				_go("blank")
			elif level == 4 and _in_state() >= SEQUENCE_SECS * target.size():
				_clear_then("wait")
		"blank":
			if _in_state() >= BLANK_SECS:
				_clear_then("wait")
		"wait":
			if not hint and _t - _wait_at > HINT_AFTER:
				_give_hint()
		"wrong":
			if _in_state() > WRONG_SECS:
				_resume_wait()
		"celebrate":
			if _in_state() > CELEBRATE_SECS:
				_next_round()


func _begin_show() -> void:
	match level:
		3: _talk("Look and remember.", "idle")
		4: _talk("Watch the order.", "idle")
		_:
			_begin_wait()
			return
	_go("show")


func _begin_wait() -> void:
	_go("wait")
	_wait_at = _t
	match level:
		0: _talk("Find the %s." % Library.name_of(target[0]).to_lower(), "idle")
		1: _talk("Which object has this shape?", "think")
		2: _talk("Which object is it?", "think")
		3: _talk("Now place it.", "idle")
		4: _talk("Place number %d." % (step + 1), "idle")


func _resume_wait() -> void:
	_wrong_object = ""
	_begin_wait()
	if _errors >= HINT_ERRORS and not hint:
		_give_hint()


func _give_hint() -> void:
	hint = true
	_hints += 1
	_talk("Here is some help. Place this one." if level != 0 else "Take your time. Look at the picture.", "think")


func expected() -> String:
	return target[step] if step < target.size() else ""


# -------------------------------------------------------------- boards ----

func _on_placed(board: String, centre: Vector2) -> void:
	var object: String = lib.object_of(board)
	if state == "blank" or state == "show":
		_talk("Not yet. Take it off and wait for me.", "think")
		return
	if state != "wait":
		return
	_waited += _t - _wait_at
	_wait_at = _t
	if object == "":
		_talk("Board %s has no object yet." % board, "think")
		return
	_burst_at = centre
	if object != expected():
		_errors += 1
		_wrong_object = object
		Sfx.play(get_tree(), "res://assets/audio/error_001.ogg", -8.0)
		_talk("That is the %s. Try another one." % Library.name_of(object).to_lower(), "oops")
		_go("wrong")
		return
	step += 1
	if step < target.size():
		Sfx.play(get_tree(), "res://assets/audio/select_001.ogg")
		_sparkle(centre, 26)
		hint = false
		_begin_wait()
		return
	results.append({"target": target.duplicate(), "errors": _errors, "hints": _hints, "seconds": snappedf(_waited, 0.1)})
	Sfx.play(get_tree(), CHIME)
	_talk(GOOD[_rng.randi() % GOOD.size()], "happy")
	_sparkle(centre, 60)
	_go("celebrate")


func _on_lifted(_board: String) -> void:
	if state == "wrong" and _in_state() > 1.2:
		_resume_wait()


func _on_unsure(_centre: Vector2) -> void:
	if state == "wait":
		_talk("Press the board down flat.", "think")


func first_try() -> int:
	return results.filter(func(r): return r.errors == 0 and r.hints == 0).size()

func stars() -> int:
	return 3 if first_try() >= ROUNDS - 1 else (2 if first_try() >= 3 else 1)

func average_seconds() -> float:
	var total := 0.0
	for r in results:
		total += float(r.seconds)
	return total / maxf(1.0, results.size())


func _finish() -> void:
	var errs := 0
	for r in results:
		errs += int(r.errors)
	Library.log_session({"date": Time.get_datetime_string_from_system(), "level": LEVELS[level],
		"first_try": first_try(), "rounds": ROUNDS, "errors": errs,
		"avg_seconds": snappedf(average_seconds(), 0.1), "details": results})
	Sfx.play(get_tree(), CHIME)
	_talk("You finished! Thank you for playing.", "cheer")
	for i in 3:
		_sparkle(Vector2(700 + i * 400, 420), 40)
	_go("done")
	shell.finish(stars(), "Level finished", "Right first time %d of %d  •  %.1f s each" % [first_try(), ROUNDS, average_seconds()])


# ------------------------------------------------------------ confetti ----

func _sparkle(at: Vector2, n: int) -> void:
	var cols := [Color("ffca28"), Color("ff8a65"), Color("4fc3f7"), Color("81c784"), Color("ba68c8")]
	for i in n:
		_confetti.append({"p": at, "v": Vector2.from_angle(_rng.randf() * TAU) * _rng.randf_range(140, 620) - Vector2(0, 220),
			"life": _rng.randf_range(1.0, 1.9), "age": 0.0, "r": _rng.randf_range(9, 20), "spin": _rng.randf_range(-4, 4),
			"c": cols[i % cols.size()]})

func _move_confetti(delta: float) -> void:
	for c in _confetti:
		c.age += delta
		c.v.y += 620.0 * delta
		c.v *= 1.0 - 0.9 * delta
		c.p += c.v * delta
	_confetti = _confetti.filter(func(c): return c.age < c.life)


# ------------------------------------------------------------- drawing ----

func _draw() -> void:
	var vs := get_viewport_rect().size
	Art.background(self, vs, _t)
	if state not in ["menu", "done"]:
		shell.set_status("%s   •   %d of %d" % [LEVELS[level], mini(results.size() + 1, ROUNDS), ROUNDS])

	Art.draw_pip(self, _mood, PIP, 420, _t)
	if _say != "":
		_bubble(Rect2(1420, 250, 450, 170), _say)

	match state:
		"menu", "done": pass
		_:
			var s: String = _paused_from if state == "paused" else state
			_draw_card(s)
			_draw_pad(s)

	for c in _confetti:
		Art.draw_star(self, c.p, c.r, Color(c.c, clampf((c.life - c.age) * 2.0, 0, 1)), c.spin * c.age)


func _wrapped(s: String, centre: Vector2, width: float, size: int) -> void:
	var h := Art.FONT.get_multiline_string_size(s, HORIZONTAL_ALIGNMENT_CENTER, width, size).y
	draw_multiline_string(Art.FONT, Vector2(centre.x - width / 2, centre.y - h / 2 + Art.FONT.get_ascent(size)), s,
		HORIZONTAL_ALIGNMENT_CENTER, width, size, -1, Art.INK)


func _bubble(r: Rect2, s: String) -> void:
	var b := Art.tex("speech_bubble.png")
	if b:
		draw_texture_rect(b, r.grow_individual(10, 10, 10, 50), false)
	else:
		Art.panel(self, r, Color.WHITE, Color("d5dee6"), 34, 3)
		draw_colored_polygon(PackedVector2Array([Vector2(r.position.x + 190, r.end.y - 4), Vector2(r.position.x + 250, r.end.y - 4),
			Vector2(r.position.x + 215, r.end.y + 40)]), Color.WHITE)
	_wrapped(s, r.get_center(), r.size.x - 40, 32)


func _draw_card(s: String) -> void:
	var r := CARD
	if s == "wrong":
		r.position.x += sin(_in_state() * 26.0) * 16.0 * maxf(0.0, 1.0 - _in_state() * 1.6)
	var frame := Art.tex("target_card.png")
	if frame:
		draw_texture_rect(frame, r.grow(30), false)
	else:
		var border := Color("d5dee6")
		if s == "celebrate":
			border = Color("66bb6a")
		elif s == "wrong":
			border = Color("ffb74d")
		Art.panel(self, r, Art.CREAM, border, 48, 10)
	var c := r.get_center()
	if s == "clear" and _clear_next == "show":
		for i in 3:
			draw_circle(c + Vector2((i - 1) * 60, sin(_t * 4.0 + i) * 10), 16, Color("b0bec5"))
		return
	if level == 4:
		_draw_sequence(s, c)
		return
	var id := target[0]
	if level == 0 or s in ["celebrate", "show"] or hint:
		var pop := 1.0 + (0.16 * sin(minf(_in_state() * 5.0, PI)) if s == "celebrate" else 0.0)
		Art.draw_object(self, id, c - Vector2(0, 45), 390 * pop)
		Art.text(self, Library.name_of(id), c + Vector2(0, 205), 46, Art.INK, r.size.x)
		if s == "celebrate":
			_tick(c + Vector2(215, -215))
		elif s == "show":
			var left := clampf(1.0 - _in_state() / SHOW_SECS, 0, 1)
			draw_rect(Rect2(c.x - 200, r.end.y - 48, 400 * left, 14), Art.TEAL)
	elif level == 1:
		Art.draw_grey_object(self, id, c, 430)
	elif level == 2:
		_wrapped(Library.OBJECTS[id].clue, c, r.size.x - 100, 52)
	else:
		Art.text(self, "?", c, 260, Color("90a4ae"), 500)


func _draw_sequence(s: String, c: Vector2) -> void:
	var n := target.size()
	var gap := 182.0 if n == 3 else 260.0
	var size := 165.0 if n == 3 else 220.0
	for i in n:
		var p := c + Vector2((i - (n - 1) / 2.0) * gap, 0)
		var showing := s == "celebrate" or i < step or (hint and i == step)
		if s == "show":
			showing = int(_in_state() / SEQUENCE_SECS) == i
		var edge := Color("d5dee6")
		if i < step:
			edge = Color("66bb6a")
		elif (s == "show" and showing) or (s != "show" and i == step):
			edge = Art.TEAL
		Art.panel(self, Rect2(p - Vector2(size, size) / 2, Vector2(size, size)), Color.WHITE, edge, 24, 6)
		if showing:
			Art.draw_object(self, target[i], p, size * 0.8)
		else:
			Art.text(self, str(i + 1), p, 80, Color("b0bec5"), size)
		if i < step:
			_tick(p + Vector2(size, -size) * 0.42, 0.6)


func _tick(p: Vector2, k := 1.0) -> void:
	draw_circle(p, 48 * k, Color("43a047"))
	draw_polyline(PackedVector2Array([p + Vector2(-20, 2) * k, p + Vector2(-5, 18) * k, p + Vector2(22, -16) * k]), Color.WHITE, 11 * k, true)


func _draw_pad(s: String) -> void:
	var open := s == "wait"
	var pad := Art.tex("placement_pad.png")
	var pulse := 1.0 + (sin(_t * 2.6) * 0.03 if open else 0.0)
	if pad:
		var d := Vector2.ONE * PAD_R * 2.2 * pulse
		draw_texture_rect(pad, Rect2(PAD - d / 2, d), false, Color.WHITE if open else Color(1, 1, 1, 0.5))
	else:
		draw_circle(PAD, PAD_R * pulse, Color(1, 1, 1, 0.75 if open else 0.35))
		draw_arc(PAD, PAD_R * pulse, 0, TAU, 96, Art.TEAL if open else Color("b0bec5"), 10, true)
	if open and tracker.present.is_empty():
		Art.text(self, "Place it here", PAD, 40, Art.INK, 400)
	elif s == "clear" and not tracker.present.is_empty():
		Art.text(self, "Take it off", PAD + Vector2(0, PAD_R + 46), 40, Color("ef6c00"), 500)
	elif s in ["blank", "show"]:
		Art.text(self, "Wait", PAD, 40, Color("90a4ae"), 400)

	# light up the boards standing on the glass
	for b in tracker.present:
		var p: Vector2 = tracker.present[b].centre
		var id: String = lib.object_of(b)
		var rad: float = tracker.px(44.0)
		var col: Color = Library.color_of(id)
		if s == "celebrate" and id == target.back():
			var f := int(_in_state() * 16.0)
			if f < 16:
				Art.draw_sheet(self, "vfx_correct_burst_4x4.png", f, p, rad * 5.0)
			for i in 3:
				var k := fposmod(_in_state() * 0.9 + i / 3.0, 1.0)
				draw_arc(p, rad * (1.0 + k * 1.6), 0, TAU, 64, Color(col, 1.0 - k), 10, true)
			for i in 8:
				Art.draw_star(self, p + Vector2.from_angle(_t * 1.4 + i * TAU / 8) * rad * 1.45, 20, Art.GOLD, _t)
		elif s == "wrong" and id == _wrong_object:
			var f2 := int(_in_state() * 12.0)
			if f2 < 16:
				Art.draw_sheet(self, "vfx_try_again_4x4.png", f2, p, rad * 4.0)
			draw_arc(p, rad + 12, 0, TAU, 64, Color("ffb74d"), 10, true)
		draw_arc(p, rad, 0, TAU, 64, Color(col, 0.9), 8, true)
		if id != "":
			Art.text(self, Library.name_of(id), p + Vector2(0, rad + 34), 28, Art.INK, 400)


func _open_setup() -> void:
	preload("res://games/pegboard/scripts/peg_setup.gd").back_to = scene_file_path
	get_tree().change_scene_to_file("res://games/pegboard/scenes/peg_setup.tscn")
