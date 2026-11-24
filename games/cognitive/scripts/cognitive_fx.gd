extends Node2D
## Celebrations built from the solid pieces in shared/particles_4x4.png.
const Art = preload("res://games/cognitive/scripts/cognitive_art.gd")

const STARS := [0, 1, 0, 1]
const PETALS := [2, 3, 4, 5, 6]
const NOTES := [8, 9, 10, 11]
const LEAVES := [5, 6, 4]
const CONFETTI := [0, 1, 2, 4, 12, 13, 5, 6]

var reduced_motion := false
var _pieces: Array[Dictionary] = []
var _rings: Array[Dictionary] = []


func clear() -> void:
	_pieces.clear()
	_rings.clear()
	queue_redraw()


## Pieces fly out of one place and fall.
func burst(at: Vector2, kinds: Array, count := 12, speed := 420.0) -> void:
	if reduced_motion: return
	for i in count:
		var angle := TAU * i / count + randf_range(-0.2, 0.2)
		_add(kinds.pick_random(), at, Vector2.from_angle(angle) * speed * randf_range(0.6, 1.1), 480.0, randf_range(0.8, 1.2), randf_range(40, 64))


## One note floats up.
func note(at: Vector2, index: int) -> void:
	if reduced_motion: return
	_add(NOTES[index % 4], at, Vector2(randf_range(-40, 40), -150), -20.0, 1.2, 72.0)


func confetti() -> void:
	if reduced_motion: return
	for i in 70:
		_add(CONFETTI.pick_random(), Vector2(randf_range(0, 1920), randf_range(-700, -40)),
			Vector2(randf_range(-30, 30), randf_range(120, 200)), 40.0, randf_range(4.0, 6.0), randf_range(40, 68))


## Shows that a touch was felt.
func ring(at: Vector2) -> void:
	_rings.append({pos = at, age = 0.0})


func _add(kind: int, at: Vector2, velocity: Vector2, gravity: float, life: float, side: float) -> void:
	_pieces.append({kind = kind, pos = at, velocity = velocity, gravity = gravity, life = life, age = 0.0,
		side = side, angle = randf_range(-0.4, 0.4), spin = randf_range(-1.6, 1.6), phase = randf() * TAU})


func advance(delta: float) -> void:
	if _pieces.is_empty() and _rings.is_empty(): return
	for piece in _pieces:
		piece.age += delta
		piece.velocity.x *= pow(0.35, delta)
		piece.velocity.y += piece.gravity * delta
		piece.pos += piece.velocity * delta + Vector2(sin(piece.age * 3.0 + piece.phase) * 18.0 * delta, 0)
		piece.angle += piece.spin * delta
	for item in _rings: item.age += delta
	_pieces = _pieces.filter(func(piece): return piece.age < piece.life)
	_rings = _rings.filter(func(item): return item.age < 0.45)
	queue_redraw()


func _draw() -> void:
	for item in _rings:
		var t: float = item.age / 0.45
		draw_arc(item.pos, 24.0 + 60.0 * t, 0, TAU, 48, Color(1, 0.97, 0.8, 0.9 * (1.0 - t)), 6.0 * (1.0 - t) + 1.0, true)
	if _pieces.is_empty(): return
	var sheet := Art.texture("shared/particles_4x4")
	for piece in _pieces:
		var t: float = piece.age / piece.life
		var side: float = piece.side * minf(1.0, piece.age * 8.0)
		draw_set_transform(piece.pos, piece.angle)
		draw_texture_rect_region(sheet, Rect2(-Vector2.ONE * side * 0.5, Vector2.ONE * side),
			Art.cell(piece.kind, 256.0), Color(1, 1, 1, clampf((1.0 - t) * 3.0, 0.0, 1.0)))
	draw_set_transform(Vector2.ZERO)
