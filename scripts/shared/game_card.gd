extends Button
## Launcher card: a small moving picture of the game and its name.
## All pictures are small copies made by tools/build_launcher_art.py.

const ART := "res://assets/images/launcher/"
const STRIP := 62.0
const CORNER := 26.0
const NIGHT_TOP := Color("1b2350")
const NIGHT_BOTTOM := Color("3b3f86")
## A house drawn in one line, in card units of 0 to 1.
const HOUSE := [Vector2(0.32, 0.46), Vector2(0.32, 0.88), Vector2(0.68, 0.88), Vector2(0.68, 0.46), Vector2(0.5, 0.14), Vector2(0.32, 0.46), Vector2(0.68, 0.46)]

@export var game := "focus"
@export var title := ""
@export var skill := Color("9a5200")
var _clock := 0.0
var _appear := 0.0
var _lift := 1.0
var _bump := 1.0
var _art := {}
var _frame_style := StyleBoxFlat.new()
var _strip_style := StyleBoxFlat.new()


func _ready() -> void:
	_clock = randf() * 4.0
	pivot_offset = size * 0.5
	tooltip_text = ""
	_frame_style.draw_center = false
	_frame_style.set_border_width_all(5)
	_frame_style.border_color = Color.WHITE
	_frame_style.set_corner_radius_all(int(CORNER))
	_frame_style.shadow_color = Color(0.1, 0.13, 0.05, 0.28)
	_frame_style.shadow_size = 10
	_frame_style.shadow_offset = Vector2(0, 5)
	_strip_style.bg_color = skill
	_strip_style.corner_radius_bottom_left = int(CORNER)
	_strip_style.corner_radius_bottom_right = int(CORNER)
	pressed.connect(func(): _bump = 0.0)


## The card pops in after a moment.
func appear(delay: float) -> void:
	_appear = -delay / 0.5
	modulate.a = 0.0


func _process(delta: float) -> void:
	_clock += delta
	_appear = minf(1.0, _appear + delta / 0.5)
	_bump = minf(1.0, _bump + delta / 0.35)
	var goal := 0.95 if button_pressed or is_pressed() else (1.03 if is_hovered() else 1.0)
	_lift = lerpf(_lift, goal, 1.0 - exp(-14.0 * delta))
	var shown := clampf(_appear, 0.0, 1.0)
	modulate.a = minf(1.0, shown * 2.5)
	scale = Vector2.ONE * _lift * (0.8 + 0.2 * _back_out(shown)) * (1.0 - sin(_bump * PI) * 0.06)
	queue_redraw()


func _draw() -> void:
	var area := Vector2(size.x, size.y - STRIP)
	draw_style_box(_frame_style, Rect2(Vector2.ZERO, size))
	call("_draw_" + game, area)
	draw_set_transform(Vector2.ZERO)
	draw_style_box(_strip_style, Rect2(0, area.y, size.x, STRIP))
	_frame_style.shadow_size = 0
	draw_style_box(_frame_style, Rect2(Vector2.ZERO, size))
	_frame_style.shadow_size = 10
	var font := get_theme_font("font")
	draw_string(font, Vector2(0, area.y + STRIP * 0.5 + 11), title, HORIZONTAL_ALIGNMENT_CENTER, size.x, 32, Color.WHITE)


# ---------------------------------------------------------------- pictures

func _draw_focus(area: Vector2) -> void:
	_backdrop(area, "bg_focus")
	_actor("tashi_4x4", int(_clock * 8.0) % 16, Vector2(area.x * 0.3, area.y - 8), area.y * 1.38)
	var at := Vector2(area.x * 0.7 + sin(_clock * 1.1) * 12.0, area.y * 0.46 + cos(_clock * 1.4) * 6.0)
	var side := area.y * 1.0
	draw_set_transform(at)
	draw_circle(Vector2.ZERO, side * 0.285, Color(1, 0.99, 0.95), true, -1.0, true)
	_picture("apple", Vector2.ZERO, side * 0.46)
	_picture("lens", Vector2(side * 0.107, side * 0.121), side)


func _draw_dosa(area: Vector2) -> void:
	_backdrop(area, "bg_dosa")
	for i in 2:
		var at := Vector2(area.x * (0.2 + 0.3 * i), area.y * 0.6)
		var side := area.y * 0.82
		_picture("tawa", at, side)
		var t := fmod(_clock * 0.22 + i * 0.5, 1.0)
		var flip := absf(cos(clampf((t - 0.9) * 10.0, 0.0, 1.0) * PI))
		_sheet("dosa_4x4", mini(int(t * 12.0), 9), at, Vector2(side * 0.66 * maxf(flip, 0.05), side * 0.66))
	var nod := sin(_clock * 2.0) * 0.02
	draw_set_transform(Vector2(area.x * 0.785, area.y + 4), nod)
	_picture("chef", Vector2(0, -area.y * 0.47), area.y * 0.94)


func _draw_butterfly(area: Vector2) -> void:
	_backdrop(area, "bg_butterfly")
	for i in 3:
		var at := Vector2(area.x * (0.24 + 0.27 * i) + sin(_clock * 0.9 + i * 2.1) * 26.0,
			area.y * (0.42 + 0.14 * (i % 2)) + cos(_clock * 1.3 + i * 1.7) * 18.0)
		_sheet("butterflies_4x4", i * 4 + int(_clock * 7.0 + i) % 4, at, Vector2.ONE * area.y * (0.56 - 0.06 * (i % 2)))


func _draw_memory(area: Vector2) -> void:
	_backdrop(area, "bg_memory")
	_actor("moti_4x4", int(_clock * 8.0) % 16, Vector2(area.x * 0.33, area.y * 0.97), area.y * 1.08)
	var t := fmod(_clock, 5.0)
	var open := clampf((t - 0.6) / 0.8, 0.0, 1.0) - clampf((t - 3.8) / 0.7, 0.0, 1.0)
	var side := area.y * 0.6
	var at := Vector2(area.x * 0.77, area.y * 0.64)
	_sheet("lotus_4x4", clampi(int(open * 15.99), 0, 15), at, Vector2.ONE * side)
	if open > 0.7: _picture("mango", at + Vector2(0, side * 0.012), side * 0.56 * _back_out((open - 0.7) / 0.3))


func _draw_melody(area: Vector2) -> void:
	_backdrop(area, "bg_melody")
	_actor("nila_4x4", int(_clock * 9.0) % 16, Vector2(area.x * 0.3, area.y * 0.97), area.y * 1.4)
	_sheet("robin_4x4", 4 + int(_clock * 7.0) % 8, Vector2(area.x * 0.74, area.y * 0.68), Vector2.ONE * area.y * 0.52)
	for i in 3:
		var t := fmod(_clock * 0.4 + i / 3.0, 1.0)
		_note(i, Vector2(area.x * (0.72 + 0.1 * sin(t * 5.0 + i * 2.0)), area.y * (0.5 - 0.45 * t)), area.y * 0.14, sin(t * PI))


func _draw_sounds(area: Vector2) -> void:
	_gradient(area, Color("fdf3d6"), Color("bfe3f2"))
	_sheet("sounds_3x3", 0, Vector2(area.x * 0.28, area.y * 0.52 + sin(_clock * 3.0) * 3.0), Vector2.ONE * area.y * 0.84, 3)
	for i in 3:
		var t := fmod(_clock * 0.6 + i / 3.0, 1.0)
		draw_arc(Vector2(area.x * 0.39, area.y * 0.3), area.y * (0.1 + 0.3 * t), -0.75, 0.75, 24, Color(0.11, 0.35, 0.6, 1.0 - t), 7.0, true)
	draw_set_transform(Vector2(area.x * 0.78, area.y * 0.2), sin(_clock * 4.0) * 0.14)
	_sheet("sounds_3x3", 3, Vector2(0, area.y * 0.32), Vector2.ONE * area.y * 0.8, 3)


func _draw_patterns(area: Vector2) -> void:
	_gradient(area, Color("fffaf0"), Color("f3e6cb"))
	var points := PackedVector2Array()
	for point in HOUSE: points.append(Vector2((point.x - 0.5) * area.y * 1.7 + area.x * 0.5, point.y * area.y * 0.94))
	var t := fmod(_clock, 6.0)
	var reach := clampf(t / 4.2, 0.0, 1.0) * (points.size() - 1)
	var head := points[0]
	for i in points.size() - 1:
		var part := clampf(reach - i, 0.0, 1.0)
		if part <= 0.0: break
		head = points[i].lerp(points[i + 1], part)
		draw_line(points[i], head, Color("1f5a96"), 9.0, true)
	for i in 5:
		var done := reach >= i
		draw_circle(points[i], 13.0, Color("e0862a") if done else Color("b9c3cc"), true, -1.0, true)
		draw_circle(points[i], 6.0, Color.WHITE, true, -1.0, true)
	if t < 4.2: draw_circle(head, 18.0 + sin(_clock * 9.0) * 3.0, Color(0.88, 0.52, 0.16, 0.45), true, -1.0, true)


func _draw_shape(area: Vector2) -> void:
	_backdrop(area, "bg_shape")
	var turn := fmod(_clock * 0.7, 3.0)
	for i in 3:
		var hop := sin(clampf(turn - i, 0.0, 1.0) * PI)
		var at := Vector2(area.x * (0.22 + 0.28 * i), area.y * 0.78)
		draw_set_transform(at, 0.0, Vector2(1, 0.34))
		draw_circle(Vector2.ZERO, area.y * 0.3, Color(0.06, 0.45, 0.45, 0.2 + 0.5 * hop), true, -1.0, true)
		draw_circle(Vector2.ZERO, area.y * 0.24, Color("fffdf5"), true, -1.0, true)
		draw_set_transform(Vector2.ZERO)
		_picture(["cup", "cone", "cylinder"][i], at + Vector2(0, -area.y * 0.28 - hop * area.y * 0.12), area.y * 0.68)


func _draw_ocean(area: Vector2) -> void:
	# The picture rocks slowly like a boat.
	_backdrop(area, "bg_ocean", Vector2(sin(_clock * 0.5) * 0.02, sin(_clock * 0.9) * 0.02), 0.06)


func _draw_seed(area: Vector2) -> void:
	_gradient(area, NIGHT_TOP, NIGHT_BOTTOM)
	_stars(area)
	for i in 3:
		var at := Vector2(area.x * [0.5, 0.68, 0.86][i], area.y * [0.62, 0.34, 0.6][i] + sin(_clock * 2.0 + i * 1.6) * 8.0)
		draw_circle(at, area.y * 0.2, Color(1, 0.8, 0.3, 0.16 + 0.06 * sin(_clock * 3.0 + i)), true, -1.0, true)
		_picture("seed", at, area.y * 0.3)
	_picture("nova", Vector2(area.x * 0.24, area.y * 0.52 + sin(_clock * 2.4) * 5.0), area.y * 0.84)


func _draw_sentinel(area: Vector2) -> void:
	_gradient(area, Color("2a1c4d"), Color("6a3a6d"))
	_stars(area)
	var centre := Vector2(area.x * 0.5, area.y * 0.53)
	var pulse := fmod(_clock * 0.6, 1.0)
	draw_arc(centre, area.y * (0.36 + 0.3 * pulse), 0, TAU, 48, Color(0.5, 0.9, 1, 0.8 * (1.0 - pulse)), 4.0, true)
	draw_circle(centre, area.y * 0.44, Color(0.45, 0.85, 1, 0.16), true, -1.0, true)
	draw_arc(centre, area.y * 0.44, 0, TAU, 48, Color(0.65, 0.95, 1, 0.9), 4.0, true)
	_picture("nova", centre, area.y * 0.7)
	for i in 2:
		var side := -1.0 if i == 0 else 1.0
		_picture("drone", centre + Vector2(side * (area.x * 0.34 + sin(_clock * 1.8 + i * 2.0) * 14.0), sin(_clock * 2.2 + i * 2.6) * area.y * 0.16), area.y * 0.42)


# ---------------------------------------------------------------- helpers

func _texture(name_: String) -> Texture2D:
	if name_ not in _art: _art[name_] = load(ART + name_ + ".png")
	return _art[name_]


## Fills the card's picture area, with rounded top corners.
func _corner_points(area: Vector2) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in 9: points.append(Vector2(CORNER, CORNER) + Vector2.from_angle(PI + i * PI / 16.0) * CORNER)
	for i in 9: points.append(Vector2(area.x - CORNER, CORNER) + Vector2.from_angle(-PI * 0.5 + i * PI / 16.0) * CORNER)
	points.append(Vector2(area.x, area.y + 1))
	points.append(Vector2(0, area.y + 1))
	return points


## The picture covers the area without being stretched.
func _backdrop(area: Vector2, name_: String, shift := Vector2.ZERO, crop := 0.0) -> void:
	var texture := _texture(name_)
	var points := _corner_points(area)
	var factor := maxf(area.x / texture.get_width(), area.y / texture.get_height())
	var part := area / (Vector2(texture.get_size()) * factor) * (1.0 - crop)
	var start := (Vector2.ONE - part) * 0.5 + shift
	var uvs := PackedVector2Array()
	for point in points: uvs.append(start + point / area * part)
	draw_polygon(points, PackedColorArray([Color.WHITE]), uvs, texture)


func _gradient(area: Vector2, top: Color, bottom: Color) -> void:
	var points := _corner_points(area)
	var colors := PackedColorArray()
	for point in points: colors.append(top.lerp(bottom, point.y / area.y))
	draw_polygon(points, colors)


func _stars(area: Vector2) -> void:
	for i in 16:
		var at := Vector2(fmod(i * 97.0 + 31.0, area.x - 40.0) + 20.0, fmod(i * 53.0 + 17.0, area.y - 40.0) + 20.0)
		draw_circle(at, 2.2, Color(1, 1, 1, 0.35 + 0.35 * sin(_clock * 1.6 + i * 1.3)))


func _picture(name_: String, centre: Vector2, side: float) -> void:
	draw_texture_rect(_texture(name_), Rect2(centre - Vector2.ONE * side * 0.5, Vector2.ONE * side), false)


func _sheet(name_: String, index: int, centre: Vector2, area: Vector2, columns := 4) -> void:
	var texture := _texture(name_)
	var cell := float(texture.get_width()) / columns
	draw_texture_rect_region(texture, Rect2(centre - area * 0.5, area),
		Rect2((index % columns) * cell, floorf(float(index) / columns) * cell, cell, cell))


## A host stands with its feet at a point.
func _actor(name_: String, index: int, feet: Vector2, side: float) -> void:
	draw_set_transform(feet, 0.0, Vector2(1, 0.22))
	draw_circle(Vector2.ZERO, side * 0.2, Color(0.05, 0.08, 0.02, 0.22), true, -1.0, true)
	draw_set_transform(Vector2.ZERO)
	_sheet(name_, index, feet + Vector2(0, side * (0.5 - 463.0 / 512.0)), Vector2.ONE * side)


func _note(index: int, centre: Vector2, side: float, alpha: float) -> void:
	var sheet: Texture2D = preload("res://assets/images/cognitive/shared/particles_4x4.png")
	draw_texture_rect_region(sheet, Rect2(centre - Vector2.ONE * side * 0.5, Vector2.ONE * side),
		Rect2(index * 256, 512, 256, 256), Color(1, 1, 1, alpha))


func _back_out(t: float) -> float:
	if t <= 0.0: return 0.0
	var u := t - 1.0
	return 1.0 + 2.2 * u * u * u + 1.2 * u * u
