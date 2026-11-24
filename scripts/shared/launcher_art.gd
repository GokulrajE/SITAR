extends Control
## Small moving decorations of the launcher, one kind per node.

@export_enum("life", "logo", "gear", "curtain") var kind := "life"
var _clock := 0.0
var _petals: Array[Dictionary] = []
var cover := 0.0          ## curtain: 0 open, 1 closed
var centre := Vector2.ZERO


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	if kind == "life":
		for i in 14: _petals.append(_new_petal(randf_range(0, 1080)))


func _process(delta: float) -> void:
	_clock += delta
	for petal in _petals:
		petal.pos += Vector2(petal.drift + sin(_clock * 0.8 + petal.phase) * 22.0, petal.fall) * delta
		petal.angle += petal.spin * delta
		if petal.pos.y > 1130: petal.merge(_new_petal(-40), true)
	if kind != "gear": queue_redraw()


func _new_petal(y: float) -> Dictionary:
	return {pos = Vector2(randf_range(-60, 1960), y), drift = randf_range(6, 22), fall = randf_range(22, 46), angle = randf() * TAU,
		spin = randf_range(-0.7, 0.7), phase = randf() * TAU, cell = [2, 3, 2, 5][randi() % 4], side = randf_range(34, 58)}


func _draw() -> void:
	match kind:
		"life": _draw_life()
		"logo": _draw_logo()
		"gear": _draw_gear()
		"curtain": if cover > 0.005: _draw_curtain()


func _draw_curtain() -> void:
	var points := PackedVector2Array()
	for i in 180: points.append(centre + Vector2.from_angle(i * TAU / 180.0) * cover * 2300.0)
	draw_colored_polygon(points, Color("fff6e0"))


func _draw_life() -> void:
	var sheet: Texture2D = preload("res://assets/images/cognitive/shared/particles_4x4.png")
	for petal in _petals:
		draw_set_transform(petal.pos, petal.angle)
		var side: float = petal.side
		draw_texture_rect_region(sheet, Rect2(-side * 0.5, -side * 0.5, side, side),
			Rect2((petal.cell % 4) * 256, floorf(petal.cell / 4.0) * 256, 256, 256), Color(1, 1, 1, 0.8))
	draw_set_transform(Vector2.ZERO)


## Three touch points in an uneven triangle, like the legs of a pegboard.
func _draw_logo() -> void:
	var middle := size * 0.5
	var points := [Vector2(-20, -17), Vector2(24, -8), Vector2(-4, 22)]
	var colors := [Color("f2a541"), Color("e5674f"), Color("1f8a8a")]
	for i in 3:
		var t := fmod(_clock * 0.5 + i / 3.0, 1.0)
		draw_arc(middle + points[i], 11.0 + 20.0 * t, 0, TAU, 32, Color(colors[i], 0.75 * (1.0 - t)), 3.0, true)
		draw_circle(middle + points[i], 11.0, colors[i], true, -1.0, true)


func _draw_gear() -> void:
	var middle := size * 0.5
	var ink := Color("174a45")
	for i in 8:
		draw_set_transform(middle, i * TAU / 8.0)
		draw_rect(Rect2(-6, -26, 12, 14), ink)
	draw_set_transform(Vector2.ZERO)
	draw_arc(middle, 14.5, 0, TAU, 40, ink, 11.0, true)
