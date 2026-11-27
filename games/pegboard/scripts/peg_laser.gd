extends Control
## Laser Pop, level 1. A fixed laser crosses the screen; a board standing in the
## beam becomes a mirror, and turning its object swings the reflected beam.
## Hold the beam on a balloon to pop it.
##
## Control is relative: a new mirror points straight up, and only turning it
## moves the beam. The aim is remembered when the board is lifted, so a player
## with a small wrist range can turn, lift, turn back and turn again.

const Library = preload("res://games/pegboard/scripts/peg_library.gd")
const Tracker = preload("res://games/pegboard/scripts/peg_tracker.gd")
const Art = preload("res://games/pegboard/scripts/peg_art.gd")
const Sfx = preload("res://games/dosa/scripts/sfx.gd")

const GUN := Vector2(120, 495)
const TOP := 110.0
const CATCH := 110.0                 # how far off the beam a board still catches it
const BALLOON := 68.0
const DWELL := 0.5                   # beam must rest on a balloon this long
const TO_POP := 8
const AT_ONCE := 3
const START_AIM := -PI / 2.0
const SMOOTH := 11.0                 # higher follows faster, lower wobbles less
const BEAM := Color("ff2d55")
const COLORS := [Color("ff6b6b"), Color("ffd43b"), Color("4dabf7"), Color("69db7c"), Color("da77f2")]

var lib := Library.new()
var tracker: Node
var balloons: Array = []             # {"pos", "color", "heat", "phase"}
var popped := 0
var gain := 1                        # beam degrees per object degree
var mirror := ""                     # board that is catching the beam
var mirror_at := Vector2.ZERO
var aim := START_AIM
var elapsed := 0.0

var _target_aim := {}                # board -> wanted beam direction
var _last_angle := {}                # board -> last rotation read from its legs
var _path: Array[Vector2] = []
var _bits: Array = []                # {"pos", "vel", "life", "color"}
var _t := 0.0
var _again: Button


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	if DisplayServer.get_name() != "headless":
		get_window().mode = Window.MODE_FULLSCREEN
	tracker = Tracker.new()
	tracker.lib = lib
	add_child(tracker)
	tracker.lifted.connect(func(board): _last_angle.erase(board))
	_button("Home", Rect2(36, 24, 150, 64), func(): get_tree().change_scene_to_file("res://scenes/ui/launcher.tscn"))
	_button("Boards", Rect2(206, 24, 150, 64), func(): get_tree().change_scene_to_file("res://games/pegboard/scenes/peg_setup.tscn"))
	var turn: Button
	turn = _button("Turn power 1x", Rect2(1620, 24, 264, 64), func():
		gain = gain % 3 + 1
		turn.text = "Turn power %dx" % gain)
	_again = _button("Play again", Rect2(810, 640, 300, 84), start)
	start()


## Ignores a press while a board stands on the button, so lifting it does nothing.
func _button(label: String, r: Rect2, cb: Callable) -> Button:
	return Art.button(self, label, r, func():
		for board in tracker.present:
			if r.grow(tracker.px(48)).has_point(tracker.present[board].centre):
				return
		cb.call(), Color("5c7a99"))


func start() -> void:
	popped = 0
	elapsed = 0.0
	balloons.clear()
	_bits.clear()
	_again.visible = false
	_fill()


func _fill() -> void:
	while balloons.size() < mini(AT_ONCE, TO_POP - popped):
		var p := Vector2.ZERO
		for attempt in 200:
			p = Vector2(randf_range(420, 1800), randf_range(TOP + 100, Tracker.REST_TOP - 100))
			if _good_spot(p):
				break
		balloons.append({"pos": p, "color": COLORS[randi() % COLORS.size()], "heat": 0.0, "phase": randf() * TAU})


## Off the incoming beam, clear of other balloons and not under the mirror.
func _good_spot(p: Vector2) -> bool:
	if absf(p.y - GUN.y) < BALLOON + 40.0:
		return false
	if mirror != "" and p.distance_to(mirror_at) < 320.0:
		return false
	for b in balloons:
		if p.distance_to(b.pos) < BALLOON * 3.0:
			return false
	return true


func _process(delta: float) -> void:
	advance(delta)
	queue_redraw()


func advance(delta: float) -> void:
	_t += delta
	_read_boards()
	_find_mirror(delta)
	var hit := _trace()
	var done := popped >= TO_POP
	if not done:
		elapsed += delta
	for b in balloons:
		b.heat = move_toward(b.heat, 1.0 if is_same(b, hit) else 0.0, delta / DWELL)
	if not hit.is_empty() and hit.heat >= 1.0:
		_pop(hit)
	for bit in _bits:
		bit.vel.y += 700.0 * delta
		bit.pos += bit.vel * delta
		bit.life -= delta
	_bits = _bits.filter(func(bit): return bit.life > 0.0)


## Turns each standing board's rotation into a change of its aim.
func _read_boards() -> void:
	for board in tracker.present:
		var angle: float = tracker.present[board].angle
		if not _target_aim.has(board):
			_target_aim[board] = START_AIM
		if _last_angle.has(board):
			_target_aim[board] += wrapf(angle - float(_last_angle[board]), -PI, PI) * gain
		_last_angle[board] = angle


## The board nearest the gun that stands in the beam is the mirror.
func _find_mirror(delta: float) -> void:
	var found := ""
	var nearest := INF
	for board in tracker.present:
		var c: Vector2 = tracker.present[board].centre
		var reach := CATCH * (1.4 if board == mirror else 1.0)        # no flicker at the edge
		if c.x > GUN.x + 140.0 and absf(c.y - GUN.y) < reach and c.x < nearest:
			nearest = c.x
			found = board
	if found == "":
		mirror = ""
		return
	var at := Vector2(tracker.present[found].centre.x, GUN.y)
	var k := 1.0 - exp(-SMOOTH * delta)
	if found != mirror:
		mirror = found
		mirror_at = at
		aim = _target_aim[found]
		Sfx.play(get_tree(), "res://assets/audio/open_001.ogg")
	else:
		mirror_at = mirror_at.lerp(at, k)
		aim = lerp_angle(aim, _target_aim[found], k)


## Builds the beam path and returns the balloon it rests on ({} for none).
func _trace() -> Dictionary:
	var from := GUN + Vector2(60, 0)
	var dir := Vector2.RIGHT
	_path = [from]
	if mirror != "":
		from = mirror_at
		dir = Vector2.from_angle(aim)
		_path.append(from)
	# to the edge of the playing area, or the first balloon in the way
	var length := 3000.0
	if dir.x > 0.001:
		length = minf(length, (1920.0 - from.x) / dir.x)
	elif dir.x < -0.001:
		length = minf(length, -from.x / dir.x)
	if dir.y > 0.001:
		length = minf(length, (Tracker.REST_TOP - from.y) / dir.y)
	elif dir.y < -0.001:
		length = minf(length, (TOP - from.y) / dir.y)
	var hit := {}
	for b in balloons:
		var along: float = (b.pos - from).dot(dir)
		var off: float = absf((b.pos - from).cross(dir))
		if along > 0.0 and off < BALLOON:
			var front := along - sqrt(BALLOON * BALLOON - off * off)
			if front < length:
				length = front
				hit = b
	_path.append(from + dir * length)
	return hit


func _pop(b: Dictionary) -> void:
	for i in 28:
		_bits.append({"pos": b.pos, "vel": Vector2.from_angle(randf() * TAU) * randf_range(150, 620),
			"life": randf_range(0.5, 1.0), "color": b.color if i % 4 else Color.WHITE})
	balloons.erase(b)
	popped += 1
	Sfx.play(get_tree(), "res://assets/audio/confirmation_001.ogg")
	if popped >= TO_POP:
		_again.visible = true
	else:
		_fill()


func _draw() -> void:
	var vs := get_viewport_rect().size
	draw_polygon(PackedVector2Array([Vector2.ZERO, Vector2(vs.x, 0), vs, Vector2(0, vs.y)]),
		PackedColorArray([Color("141a3a"), Color("141a3a"), Color("32215c"), Color("32215c")]))
	for i in 70:                                                      # stars
		var p := Vector2(fposmod(i * 397.0, vs.x), fposmod(i * 211.0, vs.y))
		draw_circle(p, 2.0 + (i % 3), Color(1, 1, 1, 0.2 + 0.2 * sin(_t * 2.0 + i)))

	Art.rest_area(self)
	for b in balloons:
		_draw_balloon(b)
	_draw_beam()
	if mirror != "":
		_draw_mirror()
	_draw_gun()
	for bit in _bits:
		if bit.life > 0.1:
			Art.draw_star(self, bit.pos, 16.0 * bit.life, Color(bit.color, minf(1.0, bit.life * 2.0)), _t * 6.0)

	draw_rect(Rect2(0, 0, vs.x, TOP), Color(1, 1, 1, 0.92))
	Art.text(self, "Laser Pop", Vector2(660, 56), 42, Art.INK, 400)
	Art.text(self, "Popped %d / %d" % [popped, TO_POP], Vector2(1020, 56), 32, Art.INK, 320)
	_draw_readout()

	var message := "Put a board on the red beam."
	if mirror != "":
		message = "Turn the object to aim. Rest the beam on a balloon."
	if popped >= TO_POP:
		Art.panel(self, Rect2(610, 360, 700, 400), Color.WHITE, Art.GOLD, 36, 6)
		Art.text(self, "Well done!", Vector2(960, 450), 70, Art.INK)
		Art.text(self, "All %d balloons in %d seconds" % [TO_POP, roundi(elapsed)], Vector2(960, 545), 34, Art.INK)
	else:
		Art.panel(self, Rect2(460, Tracker.REST_TOP + 10, 1000, 54), Color(1, 1, 1, 0.92), Art.TEAL, 22, 3)
		Art.text(self, message, Vector2(960, Tracker.REST_TOP + 37), 28, Art.INK, 960)


## Live angle and signal, for tuning on the real screen.
func _draw_readout() -> void:
	var s := "no board"
	var color := Color("90a4ae")
	if mirror != "" and tracker.present.has(mirror):
		var fresh: bool = tracker._t - float(tracker.present[mirror].seen) < 0.15
		s = "%s: %d°  %s" % [mirror, roundi(fposmod(rad_to_deg(tracker.present[mirror].angle), 360.0)),
			"reading" if fresh else "holding"]
		color = Color("2e7d32") if fresh else Color("ef6c00")
	Art.text(self, s, Vector2(1390, 56), 30, color, 420)


func _draw_balloon(b: Dictionary) -> void:
	var c: Vector2 = b.pos + Vector2(0, sin(_t * 1.8 + b.phase) * 5.0)
	var heat: float = b.heat
	c.x += sin(_t * 60.0) * heat * 4.0                                # trembles when hit
	var r := BALLOON * (1.0 + heat * 0.18)
	var string := PackedVector2Array()
	for i in 12:
		string.append(c + Vector2(sin(i * 0.8 + _t * 3.0) * 6.0, r * 1.1 + i * 8.0))
	draw_polyline(string, Color(1, 1, 1, 0.6), 3.0, true)
	draw_set_transform(c, 0.0, Vector2(1.0, 1.13))
	draw_circle(Vector2.ZERO, r, b.color.lerp(Color.WHITE, heat * 0.4), true, -1.0, true)
	draw_circle(Vector2(-r * 0.32, -r * 0.36), r * 0.2, Color(1, 1, 1, 0.65), true, -1.0, true)
	draw_set_transform(Vector2.ZERO)
	draw_colored_polygon(PackedVector2Array([c + Vector2(0, r * 1.08), c + Vector2(-11, r * 1.28), c + Vector2(11, r * 1.28)]), b.color)
	if heat > 0.0:
		draw_arc(c, r * 1.3, -PI / 2.0, -PI / 2.0 + TAU * heat, 48, Color.WHITE, 8.0, true)


func _draw_beam() -> void:
	if _path.size() < 2:
		return
	var points := PackedVector2Array(_path)
	var flicker := 1.0 + sin(_t * 40.0) * 0.08
	for layer in [[34.0, 0.10], [18.0, 0.28], [9.0, 0.9]]:
		draw_polyline(points, Color(BEAM, layer[1]), layer[0] * flicker, true)
	draw_polyline(points, Color.WHITE, 3.0, true)
	draw_circle(_path[-1], 12.0 * flicker, Color(1, 0.85, 0.9))


func _draw_mirror() -> void:
	# the mirror's face lies across the bend, so the reflection looks right
	var normal := (Vector2.from_angle(aim) - Vector2.RIGHT)
	var face := normal.normalized().orthogonal() if normal.length() > 0.05 else Vector2.RIGHT
	var half := face * 165.0
	draw_line(mirror_at - half, mirror_at + half, Color(0.6, 0.9, 1.0, 0.35), 26.0, true)
	draw_line(mirror_at - half, mirror_at + half, Color("d8f3ff"), 9.0, true)
	draw_arc(mirror_at, tracker.px(52), 0, TAU, 64, Color(Art.TEAL, 0.9), 5.0, true)


func _draw_gun() -> void:
	Art.panel(self, Rect2(GUN.x - 100, GUN.y - 55, 120, 110), Color("8d99ae"), Color("dfe4ee"), 26, 5)
	Art.panel(self, Rect2(GUN.x + 10, GUN.y - 24, 50, 48), Color("5c677d"), Color("dfe4ee"), 10, 3)
	draw_circle(GUN + Vector2(-45, 0), 22.0 + sin(_t * 6.0) * 3.0, BEAM)
