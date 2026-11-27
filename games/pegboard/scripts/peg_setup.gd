extends Control
## Caregiver screen: RECORD each board. Nothing is fixed in advance.
##   1. Stand a board (with its object screwed on) ANYWHERE on the glass, so
##      nobody has to stretch to a fixed spot on the table.
##   2. Its three legs are captured; the object choices sweep out, tap one.
## The leg pattern is saved for that object. "Start fresh" forgets every
## recording, so the boards can be recorded again whenever they change.

const Library = preload("res://games/pegboard/scripts/peg_library.gd")
const Tracker = preload("res://games/pegboard/scripts/peg_tracker.gd")
const Art = preload("res://games/pegboard/scripts/peg_art.gd")
const Sfx = preload("res://games/dosa/scripts/sfx.gd")
const Menu = preload("res://games/pegboard/scripts/peg_radial_menu.gd")

const TOP := 110.0
const SIDE := 400.0                       # right-hand list of recorded boards
const MSG_H := 100.0                      # message strip kept free at the bottom
const RING_MM := 105.0
const OBJECT_MM := 46.0                   # room the standing board needs
const NIGHT := Color("0e1830")            # calm and dim: less glare on a flat TV
const DUSK := Color("21365a")
const SOFT := Color(1, 1, 1, 0.6)
const STEADY := 0.6                       # seconds three legs must stay still
const DONE_SCENE := "res://games/pegboard/scenes/peg_match.tscn"

## The game that opened set-up; "Done" goes back there.
static var back_to := ""

var lib := Library.new()
var tracker: Node
var captured: Array[Vector2] = []         # legs of the standing board
var spot := Vector2.ZERO                  # centre of the ring of choices
var _captured_at := 0.0
var _seen: Array[Vector2] = []
var _seen_since := 0.0
var _empty_since := 0.0
var _t := 0.0
var _note := ""
var _note_until := 0.0
var _note_color := Art.INK
var menu: Control
var _capture_no := 0                      # counts captures, so each reopens the menu
var _landed_at := {}                      # slot -> when its picture arrived
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
	menu = Menu.new()
	menu.setup(lib)
	add_child(menu)
	menu.chosen.connect(_on_chosen)
	menu.landed.connect(_on_landed)
	menu.cleared.connect(func(): remove(captured_slot()))


func _process(delta: float) -> void:
	_t += delta
	_done.disabled = lib.objects().is_empty()
	watch(delta)
	_sync_menu()
	menu.set_touches(tracker.points())
	queue_redraw()


func _sync_menu() -> void:
	if captured.size() == 3:
		menu.attach(captured_slot(), spot, ring_radius(), _capture_no)
	else:
		menu.detach()


func say(s: String, color := Art.INK, secs := 4.0) -> void:
	_note = s
	_note_color = color
	_note_until = _t + secs


## Forgets one recorded board.
func remove(slot: String) -> void:
	if lib.object_of(slot) == "":
		return
	say("Removed the %s's board." % Library.name_of(lib.object_of(slot)).to_lower(), Art.INK)
	menu.cancel_flight(slot)
	lib.forget(slot)


func start_fresh() -> void:
	for b in Library.SLOTS:
		menu.cancel_flight(b)
	lib.clear()
	captured.clear()
	Sfx.play(get_tree(), "res://assets/audio/open_001.ogg")
	say("All recordings cleared. Record each board again.", Art.INK, 5.0)


# ---------------------------------------------------------- capturing ------

## Contacts close enough together to be the legs of one board: the first group
## of exactly three, else the largest group. Stray touches elsewhere are ignored.
func _leg_group() -> Array[Vector2]:
	var rest: Array[Vector2] = tracker.points()
	var reach: float = tracker.px(Library.MAX_SIDE_MM)
	var best: Array[Vector2] = []
	while not rest.is_empty():
		var group: Array[Vector2] = [rest.pop_back()]
		var i := 0
		while i < group.size():
			for j in range(rest.size() - 1, -1, -1):
				if group[i].distance_to(rest[j]) < reach:
					group.append(rest[j])
					rest.remove_at(j)
			i += 1
		if group.size() == 3:
			return group
		if group.size() > best.size():
			best = group
	return best


func board_centre() -> Vector2:
	return (captured[0] + captured[1] + captured[2]) / 3.0


## Captures the legs once exactly three contacts stand still close together;
## forgets them when nothing has touched that place for a moment.
func watch(_delta: float) -> void:
	if captured.size() == 3:
		var c := board_centre()
		var near: float = tracker.px(Library.MAX_SIDE_MM * 0.75)
		if tracker.points().any(func(p): return p.distance_to(c) < near):
			_empty_since = _t
		elif _t - _empty_since > 0.4:
			captured.clear()
			_seen.clear()
		return
	var pts := _leg_group()
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
	if _t - _seen_since >= STEADY:
		captured = pts.duplicate()
		_empty_since = _t
		_captured_at = _t
		_capture_no += 1
		spot = _ring_spot(board_centre())
		Sfx.play(get_tree(), "res://assets/audio/open_001.ogg")


func ring_radius() -> float:
	return clampf(tracker.px(RING_MM), 235.0, 320.0)


## The ring is centred on the board when it fits there. Near an edge it moves to
## the closest place where every choice is on screen and none is under the board.
func _ring_spot(real: Vector2) -> Vector2:
	var rad := ring_radius()
	var r := rad + Menu.ITEM / 2.0 + 14.0
	var room := Rect2(r, TOP + r, 1920.0 - SIDE - 2.0 * r, 1080.0 - MSG_H - TOP - 2.0 * r)
	var best := real.clamp(room.position, room.end)
	var discs: Array = menu.footprint(rad)
	if _clear_of(best, real, discs):
		return best
	var least := INF
	for ix in int(room.size.x / 20.0) + 1:
		for iy in int(room.size.y / 20.0) + 1:
			var c := room.position + Vector2(ix, iy) * 20.0
			var d := c.distance_squared_to(real)
			if d < least and _clear_of(c, real, discs):
				least = d
				best = c
	return best


func _clear_of(c: Vector2, real: Vector2, discs: Array) -> bool:
	var object: float = tracker.px(OBJECT_MM)
	for disc in discs:
		if real.distance_to(c + disc[0]) < object + disc[1]:
			return false
	return true


## The standing board, if it is already recorded.
func captured_slot() -> String:
	if captured.size() != 3:
		return ""
	var r: Array = lib.identify(captured, tracker.mm_per_px())
	return r[0] if not r.is_empty() else ""


func icon_pos(i: int) -> Vector2:
	_sync_menu()
	return menu.item_pos(i)


func card_rect(i: int) -> Rect2:
	return Rect2(1920.0 - SIDE + 10, TOP + 30 + i * 305, SIDE - 45, 280)


func _on_tapped(p: Vector2) -> void:
	_sync_menu()
	menu.handle_tap(p)


func _on_chosen(i: int) -> void:
	var object: String = Library.OBJECTS.keys()[i]
	if choose(object):
		var slot: String = lib.board_of(object)
		menu.fly(i, slot, card_rect(Library.SLOTS.find(slot)).get_center() - Vector2(0, 24))
	else:
		menu.reject(i)


func _on_landed(slot: String) -> void:
	_landed_at[slot] = _t
	Sfx.play(get_tree(), "res://assets/audio/open_001.ogg")


## Saves the captured legs for this object. False when they were refused.
func choose(object: String) -> bool:
	var r: Dictionary = lib.record(object, captured, tracker.mm_per_px())
	match r.get("error", ""):
		"":
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
	return not r.has("error")


# Removing a recording: tap its card on the right (mouse or finger; the cards
# are outside the tracker's area, so this listens to touches directly).
func _input(e: InputEvent) -> void:
	var at := Vector2(-1, -1)
	if e is InputEventScreenTouch and e.pressed:
		at = e.position
	elif e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		at = e.position
	if at.x >= 0.0 and not tracker.area.has_point(at):
		menu.close()                       # a press outside the glass dismisses
	if at.x < 1920.0 - SIDE:
		return
	for i in 3:
		var b: String = Library.SLOTS[i]
		if card_rect(i).has_point(at) and lib.object_of(b) != "":
			remove(b)
			get_viewport().set_input_as_handled()
			return


# ----------------------------------------------------------- drawing ------

func _draw() -> void:
	var vs := get_viewport_rect().size
	draw_polygon(PackedVector2Array([Vector2.ZERO, Vector2(vs.x, 0), vs, Vector2(0, vs.y)]),
		PackedColorArray([NIGHT, NIGHT, DUSK, DUSK]))
	for i in 40:                                        # slow drifting motes
		var p := Vector2(fposmod(i * 397.0 + sin(_t * 0.2 + i) * 30.0, vs.x), fposmod(i * 211.0 - _t * (4.0 + i % 5), vs.y))
		draw_circle(p, 2.0 + i % 3, Color(0.7, 0.9, 1.0, 0.10 + 0.08 * sin(_t * 0.8 + i)))
	draw_rect(Rect2(0, 0, vs.x, TOP), Color(1, 1, 1, 0.07))
	Art.text(self, "Record the boards", Vector2(740, 56), 40, Color.WHITE)

	# recorded boards
	for i in 3:
		var b: String = Library.SLOTS[i]
		var r := card_rect(i)
		var id: String = "" if menu.flying_to(b) else lib.object_of(b)      # maybe still on its way
		var here := captured_slot() == b
		# a card that has just caught its picture bounces and flashes
		var age: float = _t - float(_landed_at.get(b, -10.0))
		var hit := exp(-age * 5.0) if age < 1.2 else 0.0
		var bounce := 1.0 + hit * sin(age * 22.0) * 0.08
		draw_set_transform(r.get_center() * (1.0 - bounce), 0.0, Vector2.ONE * bounce)
		if hit > 0.0 and id != "":
			Art.panel(self, r.grow(10.0 * hit), Color(Library.color_of(id), hit * 0.8), Color.TRANSPARENT, 36)
		Art.panel(self, r, Color(1, 1, 1, 0.08), Art.TEAL if here else Color(1, 1, 1, 0.2), 28, 6 if here else 2)
		if id == "":
			Art.text(self, "empty", r.get_center(), 30, Color(1, 1, 1, 0.35), r.size.x)
		else:
			Art.draw_object(self, id, r.get_center() - Vector2(0, 24), 150.0 * (1.0 + hit * 0.25))
			_draw_legs(lib.legs[b], r.get_center() + Vector2(115, -80), 0.55)
			Art.text(self, Library.name_of(id), r.position + Vector2(r.size.x / 2, 220), 28, Color.WHITE, r.size.x)
			Art.text(self, "tap to remove", r.position + Vector2(r.size.x / 2, 256), 20, SOFT, r.size.x)
		draw_set_transform(Vector2.ZERO)

	var message := ""
	if captured.size() == 3:
		_draw_aura()
		var known := captured_slot()
		if not menu.is_open:
			message = "Tap + to choose its object."
		elif known == "":
			message = "Tap the object that is on this board."
		else:
			message = "This board is the %s. Tap another object to change it." % Library.name_of(lib.object_of(known)).to_lower()
	else:
		for p in tracker.points():                      # a soft glow under each touch
			for k in 4:
				draw_circle(p, 18.0 + k * 11.0, Color(Art.TEAL, 0.12))
			draw_circle(p, 12, Color("7ff0e0"))
		var count := _leg_group().size()
		var middle := Vector2((vs.x - SIDE) / 2.0, vs.y / 2.0)
		if count == 0:
			var breathe := 0.75 + 0.2 * sin(_t * 2.0)
			Art.text(self, "Put a board anywhere", middle - Vector2(0, 24), 52, Color(1, 1, 1, breathe), 900)
			Art.text(self, "wherever it is comfortable to reach", middle + Vector2(0, 38), 28, SOFT, 900)
		else:
			message = "%d of 3 legs. Hold the board still and flat." % mini(count, 3)

	if _t < _note_until:
		_banner(_note, _note_color)
	elif message != "":
		_banner(message, Art.TEAL.darkened(0.35))


func _banner(s: String, color: Color) -> void:
	var r := Rect2(60, 1080 - 88, 1920 - SIDE - 120, 62)
	Art.panel(self, r, Color(1, 1, 1, 0.94), color, 22, 3)
	Art.text(self, s, r.get_center(), 26, color, r.size.x - 30)


## The light under the standing board: it takes the colour of its object.
func _draw_aura() -> void:
	var c := board_centre()
	var known := captured_slot()
	var color: Color = Art.TEAL.lightened(0.25) if known == "" else Library.color_of(lib.object_of(known))
	var age := _t - _captured_at
	var grow: float = Menu.glide(age / 0.7)
	if spot.distance_to(c) > 4.0:
		draw_line(c, spot, Color(color, 0.35 * grow), 4.0, true)
	for k in 12:                                        # glow
		draw_circle(c, (60.0 + k * 11.0) * grow * (1.0 + sin(_t * 2.0) * 0.03), Color(color, 0.032))
	for k in 3:                                         # turning arcs
		var a := _t * 0.9 + k * TAU / 3.0
		draw_arc(c, 138.0 * grow, a, a + 1.25, 32, Color(color, 0.95), 7.0, true)
	for k in 36:                                        # counter-turning ticks
		var d := Vector2.from_angle(-_t * 0.35 + k * TAU / 36.0)
		draw_line(c + d * 154.0 * grow, c + d * 164.0 * grow, Color(color, 0.5 * grow), 3.0, true)
	if age < 0.9:                                       # shock wave
		var w: float = Menu.glide(age / 0.9)
		draw_arc(c, 60.0 + w * 260.0, 0, TAU, 96, Color(color, 1.0 - w), 2.0 + (1.0 - w) * 12.0, true)
	for i in 3:                                         # the legs join up one by one
		var k := clampf(age / 0.18 - i, 0.0, 1.0)
		if k > 0.0:
			draw_line(captured[i], captured[i].lerp(captured[(i + 1) % 3], k), Color(1, 1, 1, 0.85), 4.0, true)
	for p in captured:
		draw_circle(p, 24, Color(color, 0.35))
		draw_circle(p, 12, Color.WHITE)


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
