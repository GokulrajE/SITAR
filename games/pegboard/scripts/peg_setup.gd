extends Control
## Caregiver screen: RECORD each board. Nothing is fixed in advance.
##   1. Stand a board (with its object screwed on) inside the circle.
##   2. Its three legs are captured; tap the object that is on it.
## The leg pattern is saved for that object. "Start fresh" forgets every
## recording, so the boards can be recorded again whenever they change.

const Library = preload("res://games/pegboard/scripts/peg_library.gd")
const Tracker = preload("res://games/pegboard/scripts/peg_tracker.gd")
const Art = preload("res://games/pegboard/scripts/peg_art.gd")
const Sfx = preload("res://games/dosa/scripts/sfx.gd")

const ICON := 150.0
const TOP := 110.0
const SIDE := 400.0                       # right-hand list of recorded boards
const PAD := Vector2(760, 560)
const PAD_R := 200.0
const RING_R := 320.0
const STEADY := 0.6                       # seconds three legs must stay still
const DONE_SCENE := "res://games/pegboard/scenes/peg_match.tscn"

## The game that opened set-up; "Done" goes back there.
static var back_to := ""

var lib := Library.new()
var tracker: Node
var captured: Array[Vector2] = []         # legs of the board standing in the circle
var _seen: Array[Vector2] = []
var _seen_since := 0.0
var _empty_since := 0.0
var _t := 0.0
var _note := ""
var _note_until := 0.0
var _note_color := Art.INK
var _saved_object := ""
var _saved_at := -10.0
var _done: Button


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	if DisplayServer.get_name() != "headless":
		get_window().mode = Window.MODE_FULLSCREEN
	tracker = Tracker.new()
	tracker.lib = lib
	tracker.area = Rect2(0, TOP, 1920.0 - SIDE, 1080.0 - TOP)
	add_child(tracker)
	tracker.tapped.connect(_on_tapped)
	Art.button(self, "Home", Rect2(36, 24, 150, 64), func(): get_tree().change_scene_to_file("res://scenes/ui/launcher.tscn"), Color("5c7a99"))
	Art.button(self, "Start fresh", Rect2(1290, 24, 240, 64), start_fresh, Color("ef6c00"))
	_done = Art.button(self, "Done", Rect2(1555, 24, 330, 64),
		func(): get_tree().change_scene_to_file(back_to if back_to != "" else DONE_SCENE))


func _process(delta: float) -> void:
	_t += delta
	_done.disabled = lib.objects().is_empty()
	watch(delta)
	queue_redraw()


func say(s: String, color := Art.INK, secs := 4.0) -> void:
	_note = s
	_note_color = color
	_note_until = _t + secs


func start_fresh() -> void:
	lib.clear()
	captured.clear()
	Sfx.play(get_tree(), "res://assets/audio/open_001.ogg")
	say("All recordings cleared. Record each board again.", Art.INK, 5.0)


# ---------------------------------------------------------- capturing ------

func _in_pad() -> Array[Vector2]:
	var out: Array[Vector2] = []
	for p in tracker.points():
		if p.distance_to(PAD) < PAD_R + 30.0:
			out.append(p)
	return out


## Captures the legs once exactly three contacts stand still in the circle;
## forgets them when the circle has been empty for a moment.
func watch(_delta: float) -> void:
	var pts := _in_pad()
	if pts.is_empty():
		if _t - _empty_since > 0.4:
			captured.clear()
		return
	_empty_since = _t
	if pts.size() != 3:
		_seen.clear()
		return
	var moved := _seen.size() != 3
	if not moved:
		for i in 3:
			if pts[i].distance_to(_seen[i]) > 4.0:
				moved = true
	if moved:
		_seen = pts
		_seen_since = _t
		return
	if _t - _seen_since >= STEADY and captured.is_empty():
		captured = pts.duplicate()
		Sfx.play(get_tree(), "res://assets/audio/open_001.ogg")


## The board in the circle, if it is already recorded.
func captured_slot() -> String:
	if captured.size() != 3:
		return ""
	var r: Array = lib.identify(captured, tracker.mm_per_px())
	return r[0] if not r.is_empty() else ""


func icon_pos(i: int) -> Vector2:
	return PAD + Vector2.from_angle(-PI / 2 + TAU * i / Library.OBJECTS.size()) * RING_R


func card_rect(i: int) -> Rect2:
	return Rect2(1920.0 - SIDE + 10, TOP + 30 + i * 305, SIDE - 45, 280)


func _on_tapped(p: Vector2) -> void:
	if captured.size() == 3:
		var ids := Library.OBJECTS.keys()
		for i in ids.size():
			if icon_pos(i).distance_to(p) < ICON * 0.6:
				choose(ids[i])
				return


## Saves the captured legs for this object.
func choose(object: String) -> void:
	var r: Dictionary = lib.record(object, captured, tracker.mm_per_px())
	match r.get("error", ""):
		"":
			_saved_object = object
			_saved_at = _t
			Sfx.play(get_tree(), "res://assets/audio/confirmation_001.ogg")
			say("Recorded: this board is the %s. Lift it off and record the next one." % Library.name_of(object).to_lower(), Color("2e7d32"), 6.0)
		"clash":
			Sfx.play(get_tree(), "res://assets/audio/error_001.ogg", -8.0)
			say("Too much like the %s's board. Use a board with a different leg pattern." % Library.name_of(r.object).to_lower(), Color("c62828"), 6.0)
		"full":
			Sfx.play(get_tree(), "res://assets/audio/error_001.ogg", -8.0)
			say("Three boards are recorded. Tap one on the right to remove it, or Start fresh.", Color("c62828"), 6.0)
		_:
			Sfx.play(get_tree(), "res://assets/audio/error_001.ogg", -8.0)
			say("Those three points are not one board. Lift it and stand it flat again.", Color("c62828"), 6.0)


# Removing a recording: tap its card on the right (mouse or finger; the cards
# are outside the tracker's area, so this listens to touches directly).
func _input(e: InputEvent) -> void:
	var at := Vector2(-1, -1)
	if e is InputEventScreenTouch and e.pressed:
		at = e.position
	elif e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		at = e.position
	if at.x < 1920.0 - SIDE:
		return
	for i in 3:
		var b: String = Library.SLOTS[i]
		if card_rect(i).has_point(at) and lib.object_of(b) != "":
			say("Removed the %s's board." % Library.name_of(lib.object_of(b)).to_lower(), Art.INK)
			lib.forget(b)
			get_viewport().set_input_as_handled()
			return


# ----------------------------------------------------------- drawing ------

func _draw() -> void:
	var vs := get_viewport_rect().size
	Art.background(self, vs, _t)
	draw_rect(Rect2(0, 0, vs.x, TOP), Color(1, 1, 1, 0.75))
	Art.text(self, "Record the boards", Vector2(740, 56), 40, Art.INK)

	# recorded boards
	for i in 3:
		var b: String = Library.SLOTS[i]
		var r := card_rect(i)
		var id: String = lib.object_of(b)
		var here := captured_slot() == b
		Art.panel(self, r, Color.WHITE, Art.TEAL if here else Color("d5dee6"), 28, 6 if here else 3)
		if id == "":
			Art.text(self, "empty", r.get_center(), 30, Color("b0bec5"), r.size.x)
			continue
		Art.draw_object(self, id, r.get_center() - Vector2(0, 24), 150)
		_draw_legs(lib.legs[b], r.get_center() + Vector2(115, -80), 0.55)
		Art.text(self, Library.name_of(id), r.position + Vector2(r.size.x / 2, 220), 28, Art.INK, r.size.x)
		Art.text(self, "tap to remove", r.position + Vector2(r.size.x / 2, 256), 20, Color("90a4ae"), r.size.x)

	# the recording circle
	var has_legs := captured.size() == 3
	var pulse := 1.0 + (0.0 if has_legs else sin(_t * 2.5) * 0.03)
	draw_circle(PAD, PAD_R * pulse, Color(1, 1, 1, 0.65))
	draw_arc(PAD, PAD_R * pulse, 0, TAU, 64, Color("2e7d32") if has_legs else Art.TEAL, 8, true)
	for p in _in_pad():
		draw_circle(p, 16, Color("ff7043"))
	if not has_legs:
		Art.text(self, "Stand a board here", PAD - Vector2(0, 14), 34, Art.INK)
		Art.text(self, "%d of 3 legs" % mini(_in_pad().size(), 3), PAD + Vector2(0, 34), 26, Color("607d8b"))
	else:
		for p in captured:
			draw_circle(p, 20, Color("2e7d32"))
		var known := captured_slot()
		var line := "Pick its object" if known == "" else "Recorded: %s" % Library.name_of(lib.object_of(known))
		Art.text(self, line, PAD + Vector2(0, 120), 24, Art.INK, 340)
		var ids := Library.OBJECTS.keys()
		for i in ids.size():
			var p := icon_pos(i)
			var mine: bool = known != "" and lib.object_of(known) == ids[i]
			var grow := 1.0 + (0.14 * maxf(0.0, 1.0 - (_t - _saved_at) * 2.0) if ids[i] == _saved_object else 0.0)
			draw_circle(p, ICON / 2 * grow, Color.WHITE)
			draw_arc(p, ICON / 2 * grow, 0, TAU, 48, Color("2e7d32") if mine else Color("cfd8dc"), 8 if mine else 3, true)
			Art.draw_object(self, ids[i], p - Vector2(0, 14), ICON * 0.56 * grow)
			Art.text(self, Library.name_of(ids[i]), p + Vector2(0, ICON * 0.31), 17, Art.INK, ICON)

	if _t < _note_until:
		var nr := Rect2(60, 1080 - 92, 1920 - SIDE - 120, 66)
		Art.panel(self, nr, Color(1, 1, 1, 0.94), _note_color, 22, 3)
		Art.text(self, _note, nr.get_center(), 26, _note_color, nr.size.x - 30)


## A small picture of a recorded leg pattern.
func _draw_legs(pts: Array, at: Vector2, k: float) -> void:
	var c: Vector2 = (pts[0] + pts[1] + pts[2]) / 3.0
	var q := PackedVector2Array()
	for p: Vector2 in pts:
		q.append(at + (p - c) * k)
	draw_colored_polygon(q, Color(Art.TEAL, 0.18))
	q.append(q[0])
	draw_polyline(q, Art.TEAL, 3, true)
	for i in 3:
		draw_circle(q[i], 7, Art.TEAL)
