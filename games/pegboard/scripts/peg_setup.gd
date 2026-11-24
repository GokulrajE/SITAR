extends Control
## Caregiver screen: tell the games which object is screwed onto which board.
## Stand a board on the glass, then tap the object that is mounted on it.

const Library = preload("res://games/pegboard/scripts/peg_library.gd")
const Tracker = preload("res://games/pegboard/scripts/peg_tracker.gd")
const Art = preload("res://games/pegboard/scripts/peg_art.gd")
const Sfx = preload("res://games/dosa/scripts/sfx.gd")

const ICON := 156.0
const RING_MM := 105.0
const TOP := 110.0
const SIDE := 400.0                       # right-hand list of boards

var lib := Library.new()
var tracker: Node
var _board := ""                          # board the ring belongs to
var _t := 0.0
var _note := ""
var _note_until := 0.0
var _note_color := Art.INK
var _saved_at := -10.0
var _calibrating := false
var _play: Button


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	if DisplayServer.get_name() != "headless":
		get_window().mode = Window.MODE_FULLSCREEN
	tracker = Tracker.new()
	tracker.lib = lib
	tracker.area = Rect2(0, TOP, 1920.0 - SIDE, 1080.0 - TOP)
	add_child(tracker)
	tracker.placed.connect(_on_placed)
	tracker.lifted.connect(_on_lifted)
	tracker.tapped.connect(_on_tapped)
	tracker.unsure.connect(func(_c):
		if not _calibrating:
			say("Board not recognised. Press it flat, or use \"Check screen size\".", Color("c62828"), 6.0))
	Art.button(self, "Home", Rect2(36, 24, 150, 64), func(): get_tree().change_scene_to_file("res://scenes/ui/launcher.tscn"), Color("5c7a99"))
	Art.button(self, "Check screen size", Rect2(1230, 24, 290, 64), _start_calibration, Color("7e57c2"))
	_play = Art.button(self, "Play Shape Match", Rect2(1545, 24, 340, 64),
		func(): get_tree().change_scene_to_file("res://games/pegboard/scenes/peg_match.tscn"))


func _process(delta: float) -> void:
	_t += delta
	_play.disabled = lib.objects().size() < 2
	if _calibrating:
		_try_calibrate()
	queue_redraw()


func say(s: String, color := Art.INK, secs := 4.0) -> void:
	_note = s
	_note_color = color
	_note_until = _t + secs


# ------------------------------------------------------------ boards ------

func _on_placed(board: String, _centre: Vector2) -> void:
	_board = board
	Sfx.play(get_tree(), "res://assets/audio/open_001.ogg")

func _on_lifted(board: String) -> void:
	if _board == board:
		_board = "" if tracker.present.is_empty() else tracker.present.keys()[0]

## Ring centre follows the board but stays far enough inside to show every choice.
func ring_centre() -> Vector2:
	var r := ring_radius() + ICON / 2.0 + 14.0
	var c: Vector2 = tracker.present[_board].centre
	return Vector2(clampf(c.x, r, 1920.0 - SIDE - r), clampf(c.y, TOP + r, 1080.0 - r - 10.0))

func ring_radius() -> float:
	return clampf(tracker.px(RING_MM), 235.0, 320.0)

func icon_pos(i: int) -> Vector2:
	return ring_centre() + Vector2.from_angle(-PI / 2 + TAU * i / Library.OBJECTS.size()) * ring_radius()

func _on_tapped(p: Vector2) -> void:
	if _calibrating or _board == "" or not tracker.present.has(_board):
		return
	var ids := Library.OBJECTS.keys()
	for i in ids.size():
		if icon_pos(i).distance_to(p) < ICON * 0.6:
			var from := lib.assign(_board, ids[i])
			_saved_at = _t
			Sfx.play(get_tree(), "res://assets/audio/confirmation_001.ogg")
			var s := "Saved: board %s is the %s." % [_board, Library.name_of(ids[i])]
			if from != "":
				s += "  Board %s is now empty." % from
			say(s, Color("2e7d32"))
			return


# ------------------------------------------------------- calibration ------

func _start_calibration() -> void:
	_calibrating = not _calibrating
	if _calibrating:
		say("Stand boards A, B and C on the screen together, apart from each other, and take your hands away.", Art.INK, 60.0)
	else:
		_note_until = 0.0

func _try_calibrate() -> void:
	var r: Dictionary = lib.measure_screen(tracker.points(), get_viewport_rect().size.x)
	if r.is_empty():
		return
	lib.width_mm = r.width
	lib.save()
	_calibrating = false
	Sfx.play(get_tree(), "res://assets/audio/confirmation_001.ogg")
	say("Screen width measured: %d mm (fit error %.1f mm). Saved." % [roundi(r.width), r.error], Color("2e7d32"), 7.0)


# ----------------------------------------------------------- drawing ------

func _draw() -> void:
	var vs := get_viewport_rect().size
	Art.background(self, vs, _t)
	draw_rect(Rect2(0, 0, vs.x, TOP), Color(1, 1, 1, 0.75))
	Art.text(self, "Set up the boards", Vector2(700, 56), 40, Art.INK)

	# list of boards
	for i in 3:
		var b: String = ["A", "B", "C"][i]
		var r := Rect2(1920.0 - SIDE + 10, TOP + 30 + i * 305, SIDE - 45, 280)
		var on: bool = tracker.present.has(b)
		Art.panel(self, r, Color.WHITE, Art.TEAL if on else Color("d5dee6"), 28, 6 if on else 3)
		Art.text(self, "Board " + b, r.position + Vector2(r.size.x / 2, 34), 28, Art.INK, r.size.x)
		var id: String = lib.object_of(b)
		if id == "":
			Art.text(self, "?", r.get_center(), 90, Color("b0bec5"), r.size.x)
			Art.text(self, "not set", r.position + Vector2(r.size.x / 2, 246), 24, Color("90a4ae"), r.size.x)
		else:
			Art.draw_object(self, id, r.get_center() - Vector2(0, 4), 160)
			Art.text(self, Library.name_of(id), r.position + Vector2(r.size.x / 2, 246), 26, Art.INK, r.size.x)

	if _t < _note_until:
		var nr := Rect2(60, 1080 - 92, 1920 - SIDE - 120, 66)
		Art.panel(self, nr, Color(1, 1, 1, 0.94), _note_color, 22, 3)
		Art.text(self, _note, nr.get_center(), 26, _note_color, nr.size.x - 30)

	if _calibrating:
		for p in tracker.points():
			draw_arc(p, 22, 0, TAU, 32, Color("7e57c2"), 5, true)
		Art.text(self, "%d of 9 legs seen" % tracker.points().size(), Vector2((vs.x - SIDE) / 2, 180), 40, Color("7e57c2"))
		return

	if _board == "" or not tracker.present.has(_board):
		var c := Vector2((vs.x - SIDE) / 2, TOP + (vs.y - TOP) / 2)
		var pulse := 1.0 + sin(_t * 2.5) * 0.04
		draw_circle(c, 190 * pulse, Color(1, 1, 1, 0.6))
		draw_arc(c, 190 * pulse, 0, TAU, 64, Art.TEAL, 7, true)
		Art.text(self, "Put a board here", c - Vector2(0, 14), 34, Art.INK)
		Art.text(self, "any direction is fine", c + Vector2(0, 32), 24, Color("607d8b"))
		for p in tracker.points():
			draw_arc(p, 18, 0, TAU, 32, Color("ff7043"), 4, true)
		return

	# the ring of objects
	var rc := ring_centre()
	var real: Vector2 = tracker.present[_board].centre
	var rad := ring_radius()
	draw_circle(rc, rad + ICON / 2 + 8, Color(1, 1, 1, 0.55))
	if rc.distance_to(real) > 4:
		draw_line(rc, real, Color(Art.TEAL, 0.6), 4)
	draw_circle(real, tracker.px(42), Color(Art.TEAL, 0.25))
	draw_arc(real, tracker.px(42), 0, TAU, 64, Art.TEAL, 6, true)
	var ids := Library.OBJECTS.keys()
	for i in ids.size():
		var p := icon_pos(i)
		var mine: bool = lib.object_of(_board) == ids[i]
		var used: String = lib.board_of(ids[i])
		var grow := 1.0 + (0.14 * maxf(0.0, 1.0 - (_t - _saved_at) * 2.0) if mine else 0.0)
		draw_circle(p, ICON / 2 * grow, Color.WHITE)
		draw_arc(p, ICON / 2 * grow, 0, TAU, 48, Color("2e7d32") if mine else Color("cfd8dc"), 8 if mine else 3, true)
		Art.draw_object(self, ids[i], p - Vector2(0, 14), ICON * 0.56 * grow)
		Art.text(self, Library.name_of(ids[i]), p + Vector2(0, ICON * 0.31), 17, Art.INK, ICON)
		if used != "" and not mine:
			draw_circle(p + Vector2(56, -56), 20, Color("90a4ae"))
			Art.text(self, used, p + Vector2(56, -56), 20, Color.WHITE, 36)
	if _t >= _note_until:
		var nr2 := Rect2(60, 1080 - 92, 1920 - SIDE - 120, 66)
		Art.panel(self, nr2, Color(1, 1, 1, 0.94), Art.TEAL, 22, 3)
		Art.text(self, "Board %s found. Tap the object that is on it." % _board, nr2.get_center(), 26, Art.INK, nr2.size.x)
