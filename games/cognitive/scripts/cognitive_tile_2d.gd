extends Node2D
## One thing the player can touch: a flower that hides an object, a musician on
## a stone, an object on a disc, or the magnifying glass that shows the target.
## Time only moves in advance_animation(), so pausing freezes everything.
const Art = preload("res://games/cognitive/scripts/cognitive_art.gd")

enum Kind {FLOWER, MUSICIAN, DISC, LENS}
const OPEN_TIME := 0.5
const CLOSE_TIME := 0.4
const PLAY_FRAMES := 8
const HALO := Color(1.0, 0.86, 0.35)

@export var kind := Kind.FLOWER
@export var side := 300.0
var level := 0
var disabled := false
var reduced_motion := false
var icon_id := -1
var shown := false       ## the object is (being) revealed
var open := 0.0          ## 0 closed, 1 fully open
var matched := false
var halo := 0.0
var _halo_target := 0.0
var _clock := 0.0
var _bounce := 1.0       ## 0 to 1 while a bounce plays
var _shake := 1.0
var _flip := 1.0
var _flip_delay := 0.0
var _appear := 1.0
var _play := 1.0         ## musician: 0 to 1 while the note plays
var _play_time := 0.6
var _happy := 0.0


func _ready() -> void:
	_clock = randf() * 5.0


func set_icon(value: int) -> void:
	icon_id = value
	queue_redraw()


## Grow in, a little later for each tile.
func appear(delay: float) -> void:
	_appear = 1.0 if reduced_motion else -delay / 0.45
	queue_redraw()


func reveal(show_icon: bool, animate := true) -> void:
	shown = show_icon
	if not animate or reduced_motion: open = 1.0 if show_icon else 0.0
	queue_redraw()


## A new object turns into view.
func flip_in(delay: float) -> void:
	if not reduced_motion:
		_flip = 0.0
		_flip_delay = delay
	queue_redraw()


func highlight(active: bool, duration := 0.6) -> void:
	_halo_target = 1.0 if active else 0.0
	if reduced_motion: halo = _halo_target
	if active: play_note(duration)
	queue_redraw()


## Musician plays once.
func play_note(duration := 0.6) -> void:
	_play = 0.0
	_play_time = duration
	bounce()


func be_happy(duration := 1.2) -> void:
	_happy = duration
	queue_redraw()


func bounce() -> void:
	if not reduced_motion: _bounce = 0.0
	queue_redraw()


func shake() -> void:
	if not reduced_motion: _shake = 0.0
	queue_redraw()


func mark_matched() -> void:
	matched = true
	_halo_target = 1.0
	if reduced_motion: halo = 1.0
	bounce()


func contains(point: Vector2) -> bool:
	var local := point - global_position
	if kind == Kind.MUSICIAN:
		return Rect2(-side * 0.46, -side * 0.62, side * 0.92, side).has_point(local)
	return Rect2(-Vector2.ONE * side * 0.5, Vector2.ONE * side).has_point(local)


func advance_animation(delta: float) -> void:
	_clock += delta
	open = move_toward(open, 1.0 if shown else 0.0, delta / (OPEN_TIME if shown else CLOSE_TIME))
	halo = move_toward(halo, _halo_target, delta * 5.0)
	_bounce = minf(1.0, _bounce + delta / 0.55)
	_shake = minf(1.0, _shake + delta / 0.5)
	_appear = minf(1.0, _appear + delta / 0.45)
	_play = minf(1.0, _play + delta / _play_time)
	_happy = maxf(0.0, _happy - delta)
	_flip_delay -= delta
	if _flip_delay <= 0.0: _flip = minf(1.0, _flip + delta / 0.32)
	queue_redraw()


func _draw() -> void:
	var grow := _back_out(clampf(_appear, 0.0, 1.0))
	if grow <= 0.0: return
	var squash := sin(_bounce * PI * 3.0) * (1.0 - _bounce) * 0.1
	var place := Vector2(sin(_shake * PI * 6.0) * (1.0 - _shake) * side * 0.05, 0)
	var scaling := Vector2(1.0 - squash, 1.0 + squash) * grow
	match kind:
		Kind.FLOWER: _draw_flower(place, scaling)
		Kind.MUSICIAN: _draw_musician(place, scaling)
		Kind.DISC: _draw_disc(place, scaling)
		Kind.LENS: _draw_lens(scaling)
	draw_set_transform(Vector2.ZERO)


func _draw_flower(place: Vector2, scaling: Vector2) -> void:
	_spot(Vector2(0, side * 0.4), Vector2(0.78, 0.2), Color(0.05, 0.1, 0.02, 0.28))
	if halo > 0.0: _spot(Vector2.ZERO, Vector2(1.12, 1.12), Color(HALO, halo * 0.75))
	# The closed bud leans slightly in the wind, around the leaves at its base.
	var lean := 0.0 if reduced_motion else sin(_clock * 1.3) * 0.022 * (1.0 - open)
	var base := Vector2(0, side * 0.42)
	draw_set_transform(place + base, lean, scaling)
	var frame := clampi(int(open * 15.99), 0, 15)
	draw_texture_rect_region(Art.texture("meadow/cover_%s_4x4" % Art.COVERS[level]),
		_rect(side, -base), Art.cell(frame))
	var show_up := clampf((open - 0.68) / 0.32, 0.0, 1.0)
	if show_up > 0.0:
		Art.draw_icon(self, icon_id, Vector2(0, side * 0.012) - base, side * 0.6 * _back_out(show_up))


func _draw_musician(place: Vector2, scaling: Vector2) -> void:
	_spot(Vector2(0, side * 0.1), Vector2(1.0, 0.78), Color(0.02, 0.12, 0.2, 0.3))
	var grow := minf(scaling.x, scaling.y)
	draw_set_transform(Vector2(0, side * 0.02), 0.0, Vector2.ONE * grow)
	var stone := Rect2((icon_id % 3) * 512.0, floorf(icon_id / 3.0) * 512.0, 512, 512)
	draw_texture_rect_region(Art.texture("melody/stones"), _rect(side), stone)
	draw_set_transform(Vector2.ZERO)
	if halo > 0.0: _spot(Vector2(0, -side * 0.18), Vector2(1.15, 1.05), Color(HALO, halo * 0.8))
	var hop := 0.0 if reduced_motion else sin(minf(_play, 1.0) * PI) * side * 0.06
	var breath := 0.0 if reduced_motion else sin(_clock * 2.0) * 0.012
	var animal := side * 0.86
	draw_texture_rect(Art.soft_spot(), Rect2(-side * 0.22, side * 0.0, side * 0.44, side * 0.1), false, Color(0, 0, 0, 0.3))
	draw_set_transform(place + Vector2(0, side * 0.06 - hop), 0.0, scaling * Vector2(1.0 - breath, 1.0 + breath))
	draw_texture_rect_region(Art.texture("melody/%s_4x4" % Art.MUSICIANS[icon_id]),
		Rect2(-animal * 0.5, -animal * 451.0 / 512.0, animal, animal), Art.cell(_musician_frame()))


func _musician_frame() -> int:
	if _play < 1.0: return 4 + clampi(int(_play * PLAY_FRAMES), 0, PLAY_FRAMES - 1)
	if _happy_frame() >= 0: return _happy_frame()
	# Frame 3 is the blink.
	return 2 if fmod(_clock, 4.2) < 0.14 and not reduced_motion else 0


func _happy_frame() -> int:
	if _happy <= 0.0 or _play < 1.0: return -1
	return 12 + int(_clock * 7.0) % 4


func _draw_disc(place: Vector2, scaling: Vector2) -> void:
	_spot(Vector2(0, side * 0.06), Vector2(1.06, 1.06), Color(0.08, 0.06, 0.02, 0.32))
	if halo > 0.0: _spot(Vector2.ZERO, Vector2(1.25, 1.25), Color(HALO, halo * 0.9))
	draw_set_transform(place, 0.0, scaling)
	draw_texture_rect(Art.texture("focus/" + Art.holder(level)), _rect(side), false)
	var turn := _ease_out(_flip)
	draw_set_transform(place, 0.0, scaling * Vector2(maxf(0.02, turn), 1.0))
	Art.draw_icon(self, icon_id, Vector2.ZERO, side * (0.78 if level == 0 else 0.76))


func _draw_lens(scaling: Vector2) -> void:
	# The art is mirrored so that the handle points down to Tashi.
	const CENTRE := Vector2(402.5, 388.0) / 1024.0
	var float_up := 0.0 if reduced_motion else sin(_clock * 1.4) * side * 0.008
	var radius := side * 0.285
	_spot(Vector2(0, side * 0.04), Vector2(0.78, 0.78), Color(0.08, 0.06, 0.02, 0.3))
	draw_set_transform(Vector2(0, float_up), 0.0, scaling)
	draw_circle(Vector2.ZERO, radius, Color(1.0, 0.985, 0.94, 0.95), true, -1.0, true)
	Art.draw_icon(self, icon_id, Vector2.ZERO, side * 0.54 * _back_out(_flip))
	draw_set_transform(Vector2(0, float_up), 0.0, scaling * Vector2(-1, 1))
	draw_texture_rect(Art.texture("focus/lens_frame"), Rect2(-CENTRE * side, Vector2.ONE * side), false)


func _spot(centre: Vector2, size: Vector2, tint: Color) -> void:
	draw_set_transform(Vector2.ZERO)
	draw_texture_rect(Art.soft_spot(), Rect2(centre - size * side * 0.5, size * side), false, tint)


func _rect(length: float, offset := Vector2.ZERO) -> Rect2:
	return Rect2(offset - Vector2.ONE * length * 0.5, Vector2.ONE * length)


func _ease_out(t: float) -> float:
	return 1.0 - pow(1.0 - t, 3.0)


func _back_out(t: float) -> float:
	if t <= 0.0: return 0.0
	var u := t - 1.0
	return 1.0 + 2.2 * u * u * u + 1.2 * u * u
