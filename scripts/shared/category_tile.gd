extends Button
## Launcher home row: a slanted neon bar with a hexagon icon and the skill name.
## Tapping it shows that skill's games.

const ICONS := preload("res://assets/images/cognitive/shared/ui_icons_4x4.png")
const NEON := Color(0.93, 0.35, 1.0)
const SLANT := 0.32

@export var heading := ""
@export var icon_index := 0
## Text drawn in the hexagon instead of an icon, e.g. "1+2".
@export var glyph := ""
## A picture drawn in the hexagon instead of an icon, e.g. a pegboard object.
@export var picture: Texture2D
@export var count := 3
var _glow := 0.0
var _press := 0.0
var _appear := 1.0
var _clock := 0.0
var _home_x := 0.0


func _ready() -> void:
	flat = true
	focus_mode = FOCUS_NONE
	_clock = randf() * 6.0
	_home_x = position.x


func appear(delay: float) -> void:
	_appear = -delay / 0.4
	modulate.a = 0.0


func _process(delta: float) -> void:
	_clock += delta
	_appear = minf(1.0, _appear + delta / 0.4)
	var shown := clampf(_appear, 0.0, 1.0)
	_glow = lerpf(_glow, 1.0 if is_hovered() or is_pressed() else 0.0, 1.0 - exp(-12.0 * delta))
	_press = lerpf(_press, 1.0 if is_pressed() else 0.0, 1.0 - exp(-20.0 * delta))
	modulate.a = shown
	# Rows slide in from the left and lean forward on hover.
	position.x = _home_x - (1.0 - _ease(shown)) * 120.0 + _glow * 18.0
	queue_redraw()


func _draw() -> void:
	var h := size.y
	var lean := h * SLANT
	var bar := PackedVector2Array([Vector2(lean + h * 0.4, 0), Vector2(size.x, 0), Vector2(size.x - lean, h), Vector2(h * 0.4, h)])
	# Outer glow, then the bar fading from bright on the left to clear on the right.
	for i in 3:
		var grow := (3 - i) * 5.0 * (0.6 + _glow)
		draw_colored_polygon(_inflate(bar, grow), Color(NEON, 0.05 + 0.05 * _glow))
	var bright := 0.55 + 0.3 * _glow - 0.2 * _press
	var colours := PackedColorArray([Color(0.62, 0.12, 0.78, bright), Color(0.3, 0.05, 0.42, 0.15),
		Color(0.3, 0.05, 0.42, 0.15), Color(0.5, 0.08, 0.66, bright)])
	draw_polygon(bar, colours)
	draw_line(bar[0], bar[1], Color(NEON, 0.9), 3.0, true)
	draw_line(bar[3], bar[2], Color(NEON, 0.35), 2.0, true)
	# A light sweep runs along the top edge now and then.
	var sweep := fmod(_clock * 0.35, 1.6)
	if sweep < 1.0:
		var x := lerpf(bar[0].x, size.x, sweep)
		draw_line(Vector2(x - 80, 0), Vector2(x, 0), Color(1, 0.85, 1, 0.8 * sin(sweep * PI)), 4.0, true)
	# Hexagon badge holding the icon.
	var centre := Vector2(h * 0.62, h * 0.5)
	var radius := h * 0.56
	draw_colored_polygon(_hexagon(centre, radius + 6.0 + 4.0 * _glow), Color(NEON, 0.25 + 0.25 * _glow))
	draw_colored_polygon(_hexagon(centre, radius), Color(0.1, 0.03, 0.17))
	var ring := _hexagon(centre, radius)
	ring.append(ring[0])
	draw_polyline(ring, NEON, 4.0, true)
	var side := radius * 1.25
	var font := get_theme_font("font")
	if picture:
		draw_texture_rect(picture, Rect2(centre - Vector2.ONE * side * 0.55, Vector2.ONE * side * 1.1), false)
	elif glyph != "":
		draw_string(font, centre + Vector2(-radius, radius * 0.2), glyph, HORIZONTAL_ALIGNMENT_CENTER, radius * 2, int(radius * 0.58), Color(1, 0.9, 0.55))
	else:
		draw_texture_rect_region(ICONS, Rect2(centre - Vector2.ONE * side * 0.5, Vector2.ONE * side),
			Rect2((icon_index % 4) * 256, floorf(icon_index / 4.0) * 256, 256, 256))
	draw_string(font, Vector2(h * 1.35, h * 0.5 + 20), heading.to_lower(), HORIZONTAL_ALIGNMENT_LEFT, -1, 60, Color.WHITE)
	draw_string(font, Vector2(0, h * 0.5 + 12), "%d games  ›" % count, HORIZONTAL_ALIGNMENT_RIGHT, size.x - lean - 40, 30, Color(1, 0.85, 1, 0.75 + 0.25 * _glow))


func _hexagon(centre: Vector2, radius: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in 6: points.append(centre + Vector2.from_angle(i * TAU / 6.0) * radius)
	return points


func _inflate(points: PackedVector2Array, amount: float) -> PackedVector2Array:
	var grown := Geometry2D.offset_polygon(points, amount)
	return grown[0] if grown.size() > 0 else points


func _ease(t: float) -> float:
	return 1.0 - pow(1.0 - t, 3.0)
