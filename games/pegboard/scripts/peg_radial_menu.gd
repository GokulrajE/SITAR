extends Control
## Radial "pick a shape" menu for the board set-up screen.
##   * it opens by itself when a board's legs are captured; the frosted-glass choices sweep out along the
##     ring from the + button, one after another, on a spring
##   * tapping a choice pops it, closes the menu and throws its picture to the card
##   * a refused choice shakes red and the menu stays open
##   * tapping the button, or anywhere else, closes it; the button reopens it
##   * a red button empties the board when it already has a shape
## Taps come from the caller (handle_tap), because the touch tracker decides what
## is a finger and what is a board leg.

signal chosen(index: int)
signal landed(board: String)
signal cleared

const Library = preload("res://games/pegboard/scripts/peg_library.gd")
const Art = preload("res://games/pegboard/scripts/peg_art.gd")
const Sfx = preload("res://games/dosa/scripts/sfx.gd")

const ITEM := 156.0
const FAB := 84.0
const TRIGGER_ANGLE := PI / 3.0       # the gap between two choices, lower right
const CLEAR_ANGLE := PI * 2.0 / 3.0   # the matching gap, lower left
const RED := Color("e5534b")
const PAD := 34.0                     # room around a glass disc for its shadow
const OPEN_TIME := 0.85
const CLOSE_TIME := 0.34
const STAGGER := 0.055
const FLY_DELAY := 0.12
const FLY_TIME := 0.75
const PICK_TIME := 0.5                # the chosen disc swells and fades
const SHAKE_TIME := 0.55

const GLASS := """
shader_type canvas_item;
uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float box = 224.0;
uniform float radius = 78.0;
uniform vec4 tint : source_color = vec4(1.0, 1.0, 1.0, 0.8);
uniform vec4 accent : source_color = vec4(0.15, 0.65, 0.6, 1.0);
uniform float glow = 0.0;
uniform float fade = 1.0;

void fragment() {
	vec2 p = (UV - 0.5) * box;
	float d = length(p) - radius;
	float inside = 1.0 - smoothstep(-1.0, 1.0, d);

	// backdrop blur: two rings of samples on a soft mip level
	vec3 back = textureLod(screen_tex, SCREEN_UV, 2.5).rgb;
	for (int i = 0; i < 8; i++) {
		float a = float(i) * 0.785398;
		vec2 o = vec2(cos(a), sin(a)) * SCREEN_PIXEL_SIZE;
		back += textureLod(screen_tex, SCREEN_UV + o * 7.0, 2.0).rgb;
		back += textureLod(screen_tex, SCREEN_UV + o * 15.0, 2.5).rgb;
	}
	back /= 17.0;

	vec3 glass = mix(back, tint.rgb, tint.a);
	glass = mix(glass, accent.rgb, glow * 0.16);
	glass += 0.10 * smoothstep(radius, -radius, p.y + p.x * 0.35);           // sheen
	float rim = smoothstep(-3.5, -1.5, d) * inside;
	vec3 rim_col = mix(vec3(1.0), vec3(0.72, 0.8, 0.88), smoothstep(-radius, radius, p.y));
	glass = mix(glass, mix(rim_col, accent.rgb, glow), rim * mix(0.9, 1.0, glow));

	float drop = (1.0 - smoothstep(-14.0, 24.0, length(p - vec2(0.0, 11.0)) - radius)) * 0.24;
	float halo = exp(-max(d, 0.0) / 11.0) * glow * 0.75;
	float out_a = max(drop, halo);
	vec3 out_col = mix(vec3(0.08, 0.17, 0.28), accent.rgb, clamp(halo / max(out_a, 0.001), 0.0, 1.0));
	COLOR = vec4(mix(out_col, glass, inside), mix(out_a, 1.0, inside) * fade);
}
"""

var is_open := false
var centre := Vector2.ZERO
var radius := 260.0

var _ids: Array = []
var _lib
var _board := ""                       # slot of the standing board, "" = not recorded
var _key := -1                         # which standing the menu belongs to
var _shown := false                    # a board is standing, the button is wanted
var _picked := {}                      # {"i", "at"}
var _refused := {}                     # {"i", "at"}
var _t := 0.0
var _items: Array = []                 # {"node", "mat", "v", "from", "to", "at", "time", "hover"}
var _fab: Dictionary
var _clear: Dictionary
var _under: Control                    # track and ripples, behind the glass
var _over: Control                     # sparks and the flying picture, in front
var _mouse := Vector2(-1e6, -1e6)
var _touches: Array[Vector2] = []
var _ripples: Array = []               # {"pos", "at", "color"}
var _sparks: Array = []                # {"pos", "vel", "at", "life", "color", "size"}
var _flight: Dictionary = {}


func setup(lib) -> void:
	_lib = lib
	_ids = Library.OBJECTS.keys()


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_under = _layer(_draw_under)
	var shader := Shader.new()
	shader.code = GLASS
	for i in _ids.size():
		_items.append(_chip(shader, ITEM, Library.color_of(_ids[i]).darkened(0.12), _draw_item.bind(i)))
	_fab = _chip(shader, FAB, Art.TEAL, _draw_fab)
	_clear = _chip(shader, FAB, RED, _draw_clear)
	_over = _layer(_draw_over)


func _layer(painter: Callable) -> Control:
	var c := Control.new()
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.draw.connect(painter.bind(c))
	add_child(c)
	return c


func _chip(shader: Shader, diameter: float, accent: Color, painter: Callable) -> Dictionary:
	var node := Control.new()
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.visible = false
	add_child(node)
	var side := diameter + PAD * 2.0
	var mat := ShaderMaterial.new()
	mat.shader = shader
	mat.set_shader_parameter("box", side)
	mat.set_shader_parameter("radius", diameter / 2.0)
	mat.set_shader_parameter("accent", accent)
	var glass := ColorRect.new()
	glass.mouse_filter = Control.MOUSE_FILTER_IGNORE
	glass.material = mat
	glass.position = -Vector2.ONE * side / 2.0
	glass.size = Vector2.ONE * side
	node.add_child(glass)
	var face := Control.new()
	face.mouse_filter = Control.MOUSE_FILTER_IGNORE
	face.draw.connect(painter.bind(face))
	node.add_child(face)
	return {"node": node, "face": face, "mat": mat, "accent": accent,
		"v": 0.0, "from": 0.0, "to": 0.0, "at": 0.0, "time": CLOSE_TIME, "hover": 0.0}


# ------------------------------------------------------------ control -----

## Shows the menu for a standing board. Call every frame while it stands; a new
## key means it was put down again, and the choices sweep out afresh.
func attach(board: String, at: Vector2, ring: float, key: int) -> void:
	centre = at
	radius = ring
	_board = board
	if _shown and key == _key:
		return
	if is_open:
		close()
	_key = key
	_shown = true
	_tween(_fab, 1.0, 0.0, 0.7)
	open()


## The board is gone: fold everything away.
func detach() -> void:
	if not _shown:
		return
	close()
	_shown = false
	_tween(_fab, 0.0, 0.0, CLOSE_TIME)


func open() -> void:
	if is_open or not _shown:
		return
	is_open = true
	_picked = {}
	for i in _items.size():
		_tween(_items[i], 1.0, _order(i) * STAGGER, OPEN_TIME)
	_ripples.append({"pos": trigger_pos(), "at": _t, "color": Art.TEAL})


func close() -> void:
	if not is_open:
		return
	is_open = false
	for i in _items.size():
		_tween(_items[i], 0.0, (_items.size() - 1 - _order(i)) * STAGGER * 0.45, CLOSE_TIME)


## Every disc of the open menu as [offset from the centre, radius], so the caller
## can keep them on screen and clear of the standing board.
func footprint(ring: float) -> Array:
	var out := []
	for i in _ids.size():
		out.append([Vector2.from_angle(_slot_angle(i)) * ring, ITEM / 2.0])
	for a in [TRIGGER_ANGLE, CLEAR_ANGLE]:
		out.append([Vector2.from_angle(a) * ring, FAB / 2.0])
	return out


## Where choice i rests when the menu is open.
func item_pos(i: int) -> Vector2:
	return centre + Vector2.from_angle(_slot_angle(i)) * radius


func trigger_pos() -> Vector2:
	return centre + Vector2.from_angle(TRIGGER_ANGLE) * radius


func clear_pos() -> Vector2:
	return centre + Vector2.from_angle(CLEAR_ANGLE) * radius


func can_clear() -> bool:
	return is_open and _lib.object_of(_board) != ""


## Drops a picture still on its way to a board that has just been emptied.
func cancel_flight(board: String) -> void:
	if flying_to(board):
		_flight = {}


func handle_tap(p: Vector2) -> void:
	if not _shown:
		return
	if p.distance_to(trigger_pos()) < FAB * 0.65:
		Sfx.play(get_tree(), "res://assets/audio/open_001.ogg")
		if is_open:
			close()
		else:
			open()
		return
	if not is_open:
		return
	if can_clear() and p.distance_to(clear_pos()) < FAB * 0.65:
		_ripples.append({"pos": clear_pos(), "at": _t, "color": RED})
		_burst(clear_pos(), RED, 18, 420.0)
		cleared.emit()                                    # stays open: pick again
		return
	for i in _ids.size():
		if item_pos(i).distance_to(p) < ITEM * 0.55:
			close()
			chosen.emit(i)
			return
	close()


## Throws the picture of an object from its choice to the card of a board.
func fly(index: int, board: String, to: Vector2) -> void:
	_finish_flight()
	var from := item_pos(index)
	_picked = {"i": index, "at": _t}
	_ripples.append({"pos": from, "at": _t, "color": _items[index].accent})
	_burst(from, _items[index].accent, 30, 620.0)
	var mid := (from + to) / 2.0 + Vector2(0, -maxf(180.0, from.distance_to(to) * 0.3))
	mid.y = maxf(mid.y, 70.0)
	_flight = {"id": _ids[index], "board": board, "from": from, "mid": mid, "to": to,
		"at": _t + FLY_DELAY, "color": _items[index].accent}


## The choice could not be saved: bring the menu back and shake that disc.
func reject(index: int) -> void:
	open()
	_refused = {"i": index, "at": _t}
	_ripples.append({"pos": item_pos(index), "at": _t, "color": RED})


func flying_to(board: String) -> bool:
	return not _flight.is_empty() and _flight.board == board


# ------------------------------------------------------------ motion ------

func _tween(c: Dictionary, to: float, delay: float, time: float) -> void:
	c.from = c.v
	c.to = to
	c.at = _t + delay
	c.time = time


## Choices nearest the button leave first, alternating sides.
func _order(i: int) -> int:
	var d := _sweep(i)
	return clampi(int(round((absf(d) - PI / 6.0) / (PI / 3.0))) * 2 + (1 if d > 0.0 else 0), 0, _ids.size() - 1)


func _slot_angle(i: int) -> float:
	return -PI / 2.0 + TAU * i / _ids.size()


## Signed angle from the button to choice i.
func _sweep(i: int) -> float:
	return wrapf(_slot_angle(i) - TRIGGER_ANGLE, -PI, PI)


## Under-damped spring from 0 to 1: a small, soft overshoot.
static func spring(s: float) -> float:
	if s >= 1.0:
		return 1.0
	if s <= 0.0:
		return 0.0
	var t := s * OPEN_TIME
	var z := 0.66
	var w := 14.0
	var wd := w * sqrt(1.0 - z * z)
	return 1.0 - exp(-z * w * t) * (cos(wd * t) + z * w / wd * sin(wd * t))


## CSS cubic-bezier(0.16, 1, 0.3, 1).
static func glide(x: float) -> float:
	x = clampf(x, 0.0, 1.0)
	var lo := 0.0
	var hi := 1.0
	for i in 20:
		var u := (lo + hi) / 2.0
		if 3.0 * u * (1.0 - u) * (1.0 - u) * 0.16 + 3.0 * u * u * (1.0 - u) * 0.3 + u * u * u < x:
			lo = u
		else:
			hi = u
	var u := (lo + hi) / 2.0
	return 3.0 * u * (1.0 - u) * (1.0 - u) + 3.0 * u * u * (1.0 - u) + u * u * u


func _step(c: Dictionary) -> void:
	var s := clampf((_t - float(c.at)) / float(c.time), 0.0, 1.0)
	var e := spring(s) if c.to > 0.5 else glide(s)
	c.v = lerpf(c.from, c.to, e)


func _input(e: InputEvent) -> void:
	if e is InputEventMouseMotion:
		_mouse = e.position


## Contacts on the glass right now, so a resting finger highlights like a hover.
func set_touches(points: Array[Vector2]) -> void:
	_touches = points


func _hovered(at: Vector2, reach: float) -> bool:
	if _mouse.distance_to(at) < reach:
		return true
	for p in _touches:
		if p.distance_to(at) < reach:
			return true
	return false


func _process(delta: float) -> void:
	_t += delta
	for i in _items.size():
		var c: Dictionary = _items[i]
		_step(c)
		var v: float = c.v
		var hot := is_open and v > 0.8 and _hovered(item_pos(i), ITEM * 0.5)
		c.hover = move_toward(c.hover, 1.0 if hot else 0.0, delta * 7.0)
		var node: Control = c.node
		node.visible = v > 0.01
		# slide along the ring from the button, bulging outwards on the way
		var a := TRIGGER_ANGLE + _sweep(i) * v
		var r := radius + sin(clampf(v, 0.0, 1.0) * PI) * 34.0
		var lift: float = glide(c.hover)
		node.position = centre + Vector2.from_angle(a) * (r + lift * 10.0)
		node.scale = Vector2.ONE * (lerpf(0.3, 1.0, v) + lift * 0.09)
		node.rotation = (1.0 - clampf(v, 0.0, 1.0)) * -signf(_sweep(i)) * 0.9
		node.modulate.a = clampf(v * 2.6, 0.0, 1.0)
		c.mat.set_shader_parameter("fade", node.modulate.a)
		var mine: bool = _lib.object_of(_board) == _ids[i]
		c.mat.set_shader_parameter("glow", maxf(lift, 0.7 if mine else 0.0))
		c.mat.set_shader_parameter("accent", c.accent)
		if _picked.get("i", -1) == i and _t - float(_picked.at) < PICK_TIME:
			var k := (_t - float(_picked.at)) / PICK_TIME
			node.visible = true
			node.position = item_pos(i)
			node.scale = Vector2.ONE * (1.0 + glide(k) * 0.45)
			node.rotation = 0.0
			node.modulate.a = 1.0 - k * k * k
			c.mat.set_shader_parameter("fade", node.modulate.a)
			c.mat.set_shader_parameter("glow", 1.0)
		if _refused.get("i", -1) == i and _t - float(_refused.at) < SHAKE_TIME:
			var left := 1.0 - (_t - float(_refused.at)) / SHAKE_TIME
			node.position.x += sin(left * 34.0) * 18.0 * left
			c.mat.set_shader_parameter("accent", RED)
			c.mat.set_shader_parameter("glow", left)
		c.face.queue_redraw()

	_step(_fab)
	var b: Control = _fab.node
	var fv: float = _fab.v
	_fab.hover = move_toward(_fab.hover, 1.0 if _shown and _hovered(trigger_pos(), FAB * 0.55) else 0.0, delta * 7.0)
	b.visible = fv > 0.01
	b.position = trigger_pos()
	b.scale = Vector2.ONE * maxf(0.0, fv) * (1.0 + glide(_fab.hover) * 0.12)
	_fab.mat.set_shader_parameter("tint", Color(Art.TEAL.lightened(0.45) if is_open else Art.TEAL, 0.5 if is_open else 0.88))
	_fab.mat.set_shader_parameter("glow", maxf(_fab.hover, 0.5 + 0.5 * sin(_t * 4.0) if _waiting() else 0.0))
	_fab.face.queue_redraw()

	# the clear button rides out with the choices
	var out := 0.0
	for it in _items:
		out = maxf(out, clampf(it.v, 0.0, 1.0))
	var wanted: float = out if _shown and _lib.object_of(_board) != "" else 0.0
	_clear.v = move_toward(_clear.v, wanted, delta * 5.0)
	_clear.hover = move_toward(_clear.hover, 1.0 if can_clear() and _hovered(clear_pos(), FAB * 0.55) else 0.0, delta * 7.0)
	var x: Control = _clear.node
	x.visible = _clear.v > 0.01
	x.position = clear_pos()
	x.scale = Vector2.ONE * (lerpf(0.3, 1.0, _clear.v) + glide(_clear.hover) * 0.12)
	x.modulate.a = _clear.v
	_clear.mat.set_shader_parameter("fade", _clear.v)
	_clear.mat.set_shader_parameter("glow", glide(_clear.hover))
	_clear.face.queue_redraw()

	_ripples = _ripples.filter(func(r): return _t - float(r.at) < 0.7)
	for s in _sparks:
		s.vel *= exp(-3.6 * delta)
		s.vel.y += 420.0 * delta
		s.pos += s.vel * delta
	_sparks = _sparks.filter(func(s): return _t - float(s.at) < float(s.life))
	_move_flight()
	_under.queue_redraw()
	_over.queue_redraw()


## Board standing, nothing chosen yet: the button asks to be pressed.
func _waiting() -> bool:
	return _shown and not is_open and _lib.object_of(_board) == ""


func _burst(at: Vector2, color: Color, n: int, speed: float) -> void:
	for i in n:
		_sparks.append({"pos": at, "vel": Vector2.from_angle(TAU * i / n + randf() * 0.4) * speed * randf_range(0.45, 1.0),
			"at": _t, "life": randf_range(0.45, 0.85), "color": [color, Art.GOLD, Color.WHITE][i % 3],
			"size": randf_range(6.0, 14.0)})


func _flight_pos(k: float) -> Vector2:
	var a: Vector2 = _flight.from.lerp(_flight.mid, k)
	var b: Vector2 = _flight.mid.lerp(_flight.to, k)
	return a.lerp(b, k)


## 0..1 along the path: gathers itself, then rushes into the card.
func _flight_k() -> float:
	var s := clampf((_t - float(_flight.at)) / FLY_TIME, 0.0, 1.0)
	return s * s * (3.0 - 2.0 * s)


func _move_flight() -> void:
	if _flight.is_empty() or _t < float(_flight.at):
		return
	var k := _flight_k()
	if k >= 1.0:
		_finish_flight()
		return
	_sparks.append({"pos": _flight_pos(k) + Vector2(randf_range(-30, 30), randf_range(-30, 30)),
		"vel": Vector2(randf_range(-60, 60), randf_range(-90, 20)), "at": _t, "life": 0.5,
		"color": _flight.color if randf() < 0.6 else Art.GOLD, "size": randf_range(5.0, 11.0)})


func _finish_flight() -> void:
	if _flight.is_empty():
		return
	var board: String = _flight.board
	_burst(_flight.to, _flight.color, 30, 640.0)
	_ripples.append({"pos": _flight.to, "at": _t, "color": _flight.color})
	_flight = {}
	landed.emit(board)


# ------------------------------------------------------------ drawing -----

func _draw_under(c: Control) -> void:
	# a soft glass track that unrolls both ways from the button
	var reach := 0.0
	for it in _items:
		reach = maxf(reach, clampf(it.v, 0.0, 1.0))
	if reach > 0.01:
		var span := PI * reach
		c.draw_arc(centre, radius, TRIGGER_ANGLE - span, TRIGGER_ANGLE + span, 96, Color(1, 1, 1, 0.34 * reach), 46.0, true)
		c.draw_arc(centre, radius, TRIGGER_ANGLE - span, TRIGGER_ANGLE + span, 96, Color(1, 1, 1, 0.75 * reach), 2.5, true)
	for r in _ripples:
		var s := glide((_t - float(r.at)) / 0.7)
		c.draw_arc(r.pos, 50.0 + s * 130.0, 0, TAU, 64, Color(r.color, 1.0 - s), 2.0 + (1.0 - s) * 10.0, true)
	if _waiting():
		for i in 2:
			var s := fmod(_t * 0.7 + i * 0.5, 1.0)
			c.draw_arc(trigger_pos(), FAB / 2.0 + s * 46.0, 0, TAU, 48, Color(Art.TEAL, (1.0 - s) * 0.7), 4.0, true)


func _draw_item(c: Control, i: int) -> void:
	var it: Dictionary = _items[i]
	var id: String = _ids[i]
	var lift: float = glide(it.hover)
	Art.draw_object(c, id, Vector2(0, -14.0 - lift * 4.0), ITEM * (0.56 + lift * 0.05))
	Art.text(c, Library.name_of(id), Vector2(0, ITEM * 0.31), 17, Art.INK, ITEM)
	var used: String = _lib.board_of(id)
	if used == _board and used != "":
		c.draw_circle(Vector2(54, -54), 21, Color("2e7d32"))
		c.draw_polyline(PackedVector2Array([Vector2(44, -54), Vector2(51, -47), Vector2(65, -62)]), Color.WHITE, 5.0, true)
	elif used != "":                                  # already on another board
		c.draw_circle(Vector2(54, -54), 17, Color("90a4ae"))
		c.draw_polyline(PackedVector2Array([Vector2(46, -54), Vector2(52, -48), Vector2(63, -60)]), Color.WHITE, 4.0, true)


## A plus that turns into a cross while the menu is open.
func _draw_fab(c: Control) -> void:
	var turn := 0.0
	for it in _items:
		turn = maxf(turn, clampf(it.v, 0.0, 1.0))
	var color := Art.INK if is_open else Color.WHITE
	for i in 2:
		var d := Vector2.from_angle(turn * PI * 0.75 + i * PI / 2.0) * 23.0
		c.draw_line(-d, d, color, 8.0, true)
		c.draw_circle(-d, 4.0, color)
		c.draw_circle(d, 4.0, color)


## A little bin.
func _draw_clear(c: Control) -> void:
	c.draw_line(Vector2(-17, -22), Vector2(17, -22), RED, 5.0, true)
	c.draw_line(Vector2(-6, -28), Vector2(6, -28), RED, 5.0, true)
	c.draw_polyline(PackedVector2Array([Vector2(-13, -17), Vector2(-10, 6), Vector2(10, 6), Vector2(13, -17)]), RED, 5.0, true)
	Art.text(c, "Clear", Vector2(0, 22), 17, RED, FAB)


func _draw_over(c: Control) -> void:
	for s in _sparks:
		var left := 1.0 - (_t - float(s.at)) / float(s.life)
		if s.size * left > 1.5:                               # smaller cannot be triangulated
			Art.draw_star(c, s.pos, s.size * left, Color(s.color, minf(1.0, left * 2.0)), _t * 5.0 + s.size)
	if _flight.is_empty():
		return
	var k := _flight_k()
	for n in range(5, 0, -1):                                   # trailing copies
		var back := maxf(0.0, k - n * 0.035)
		Art.draw_object(c, _flight.id, _flight_pos(back), _flight_size(back) * (1.0 - n * 0.08), Color(1, 1, 1, 0.28 - n * 0.045))
	var p := _flight_pos(k)
	var size := _flight_size(k)
	for i in 4:
		c.draw_circle(p, size * (0.38 + i * 0.09), Color(_flight.color, 0.12))
	Art.draw_object(c, _flight.id, p, size)


func _flight_size(k: float) -> float:
	return lerpf(ITEM * 0.56, 130.0, k) + sin(k * PI) * 70.0
