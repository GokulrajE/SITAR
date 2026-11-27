extends Control
## Small moving decorations of the launcher, one kind per node.

@export_enum("space", "bar", "logo", "gear", "curtain") var kind := "space"
var _clock := 0.0
var _petals: Array[Dictionary] = []
var cover := 0.0          ## curtain: 0 open, 1 closed
var centre := Vector2.ZERO


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	if kind == "space":
		for i in 40: _petals.append(_new_spark(randf_range(0, 1080)))


func _process(delta: float) -> void:
	_clock += delta
	for spark in _petals:
		spark.pos += Vector2(sin(_clock * 0.5 + spark.phase) * 8.0, -spark.rise) * delta
		if spark.pos.y < -20: spark.merge(_new_spark(1100), true)
	if kind != "gear": queue_redraw()


func _new_spark(y: float) -> Dictionary:
	return {pos = Vector2(randf_range(0, 1920), y), rise = randf_range(10, 34), phase = randf() * TAU, side = randf_range(1.5, 4.0)}


func _draw() -> void:
	match kind:
		"space": _draw_space()
		"bar": _draw_bar()
		"logo": _draw_logo()
		"gear": _draw_gear()
		"curtain": if cover > 0.005: _draw_curtain()


func _draw_curtain() -> void:
	var points := PackedVector2Array()
	for i in 180: points.append(centre + Vector2.from_angle(i * TAU / 180.0) * cover * 2300.0)
	draw_colored_polygon(points, Color("12061f"))


## Deep purple night with a glowing horizon, a perspective grid and rising sparks.
func _draw_space() -> void:
	var w := size.x
	var h := size.y
	draw_polygon(PackedVector2Array([Vector2.ZERO, Vector2(w, 0), Vector2(w, h * 0.6), Vector2(0, h * 0.6)]),
		PackedColorArray([Color("12061f"), Color("12061f"), Color("3a0f55"), Color("3a0f55")]))
	draw_polygon(PackedVector2Array([Vector2(0, h * 0.6), Vector2(w, h * 0.6), Vector2(w, h), Vector2(0, h)]),
		PackedColorArray([Color("3a0f55"), Color("3a0f55"), Color("0d0418"), Color("0d0418")]))
	for i in 6:
		draw_circle(Vector2(w * 0.5, h * 0.6), 900.0 - i * 140.0, Color(0.8, 0.2, 1.0, 0.025))
	var line := Color(0.85, 0.3, 1.0, 0.13)
	var horizon := h * 0.6
	for i in 25:
		var x := (i - 12) * 160.0
		draw_line(Vector2(w * 0.5 + x * 0.15, horizon), Vector2(w * 0.5 + x * 1.6, h), line, 1.5, true)
	var scroll := fmod(_clock * 0.12, 1.0)
	for i in 9:
		var t := pow((i + scroll) / 9.0, 2.0)
		draw_line(Vector2(0, horizon + t * (h - horizon)), Vector2(w, horizon + t * (h - horizon)), Color(line, line.a * (0.3 + t)), 1.5, true)
	for i in 13:
		draw_line(Vector2(0, i * 46.0), Vector2(w, i * 46.0), Color(0.85, 0.3, 1.0, 0.035), 1.0)
	for spark in _petals:
		var glow := 0.5 + 0.5 * sin(_clock * 2.0 + spark.phase)
		draw_circle(spark.pos, spark.side * 3.0, Color(0.9, 0.4, 1.0, 0.08 * glow))
		draw_circle(spark.pos, spark.side, Color(1, 0.8, 1, 0.35 + 0.4 * glow))


## Dark header strip with a glowing magenta underline.
func _draw_bar() -> void:
	draw_polygon(PackedVector2Array([Vector2.ZERO, Vector2(size.x, 0), size, Vector2(0, size.y)]),
		PackedColorArray([Color(0.05, 0.02, 0.09, 0.92), Color(0.05, 0.02, 0.09, 0.92), Color(0.12, 0.04, 0.2, 0.92), Color(0.12, 0.04, 0.2, 0.92)]))
	for i in 4:
		draw_line(Vector2(0, size.y + i * 2), Vector2(size.x, size.y + i * 2), Color(0.93, 0.35, 1.0, 0.5 / (i + 1)), 2.0)


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
	var ink := Color(0.96, 0.8, 1.0)
	for i in 8:
		draw_set_transform(middle, i * TAU / 8.0)
		draw_rect(Rect2(-6, -26, 12, 14), ink)
	draw_set_transform(Vector2.ZERO)
	draw_arc(middle, 14.5, 0, TAU, 40, ink, 11.0, true)
