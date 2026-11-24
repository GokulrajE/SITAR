extends RefCounted
## Artwork for the pegboard games. Every picture is optional: drop a PNG with the
## right name in assets/images/peg_match/ and it replaces the drawn placeholder.
## File names and prompts: docs/PEG_MATCH_ART_PROMPTS.md

const DIR := "res://assets/images/peg_match/"
const FONT := preload("res://assets/fonts/Nunito-SemiBold.ttf")

const INK := Color("24405a")
const CREAM := Color("fffaf0")
const TEAL := Color("26a69a")
const GOLD := Color("ffb300")

static var _cache: Dictionary = {}


static func tex(file: String) -> Texture2D:
	if not _cache.has(file):
		_cache[file] = load(DIR + file) if ResourceLoader.exists(DIR + file) else null
	return _cache[file]

static func object_tex(id: String) -> Texture2D:
	return tex("objects/%s.png" % id)


## Draws frame n of a 4x4 sheet, centred. Returns false when the sheet is missing.
static func draw_sheet(c: CanvasItem, file: String, n: int, centre: Vector2, size: float, tint := Color.WHITE) -> bool:
	var t := tex(file)
	if t == null:
		return false
	var cell := t.get_size() / 4.0
	n = clampi(n, 0, 15)
	c.draw_texture_rect_region(t, Rect2(centre - Vector2(size, size) / 2.0, Vector2(size, size)),
		Rect2(Vector2(n % 4, n / 4) * cell, cell), tint)
	return true


static func draw_object(c: CanvasItem, id: String, centre: Vector2, size: float, tint := Color.WHITE) -> void:
	var t := object_tex(id)
	if t:
		c.draw_texture_rect(t, Rect2(centre - Vector2(size, size) / 2.0, Vector2(size, size)), false, tint)
	else:
		c.draw_circle(centre, size * 0.45, Color.GRAY * tint)


static func text(c: CanvasItem, s: String, centre: Vector2, size: int, color: Color, width := 900.0) -> void:
	c.draw_string(FONT, centre + Vector2(-width / 2.0, size * 0.36), s, HORIZONTAL_ALIGNMENT_CENTER, width, size, color)


static func panel(c: CanvasItem, r: Rect2, fill: Color, border := Color.TRANSPARENT, radius := 28, width := 0) -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = fill
	sb.border_color = border
	sb.set_border_width_all(width)
	sb.set_corner_radius_all(radius)
	sb.shadow_color = Color(0.1, 0.2, 0.3, 0.18)
	sb.shadow_size = 10
	sb.shadow_offset = Vector2(0, 5)
	sb.anti_aliasing = true
	c.draw_style_box(sb, r)


static func background(c: CanvasItem, size: Vector2, t: float) -> void:
	var bg := tex("bg_meadow.png")
	if bg:
		# cover the screen, keep the proportions
		var s := maxf(size.x / bg.get_width(), size.y / bg.get_height())
		var d := bg.get_size() * s
		c.draw_texture_rect(bg, Rect2((size - d) / 2.0, d), false)
		return
	c.draw_polygon(PackedVector2Array([Vector2.ZERO, Vector2(size.x, 0), size, Vector2(0, size.y)]),
		PackedColorArray([Color("bfe6f5"), Color("bfe6f5"), Color("eaf7e6"), Color("eaf7e6")]))
	for i in 4:                                            # slow clouds
		var x := fposmod(i * 560.0 + t * (6.0 + i * 2.0), size.x + 400.0) - 200.0
		for k in 3:
			c.draw_circle(Vector2(x + k * 55.0, 160.0 + i * 38.0 - (k % 2) * 22.0), 46.0, Color(1, 1, 1, 0.55))
	_hill(c, size, size.y - 210.0, 60.0, 0.0031, 0.4, Color("c5e8b7"))
	_hill(c, size, size.y - 110.0, 45.0, 0.0043, 2.1, Color("a5d796"))


static func _hill(c: CanvasItem, size: Vector2, y: float, amp: float, freq: float, phase: float, col: Color) -> void:
	var p := PackedVector2Array()
	for i in 49:
		var x := size.x * i / 48.0
		p.append(Vector2(x, y + sin(x * freq + phase) * amp))
	p.append(size)
	p.append(Vector2(0, size.y))
	c.draw_colored_polygon(p, col)


## Pip, the helper. mood: idle, think, happy, oops, cheer
static func draw_pip(c: CanvasItem, mood: String, centre: Vector2, size: float, t: float) -> void:
	if draw_sheet(c, "pip_%s_4x4.png" % mood, int(t * 10.0) % 16, centre, size):
		return
	var s := size / 400.0
	var bounce := {"idle": sin(t * 2.0) * 5.0, "think": sin(t * 1.5) * 3.0, "happy": -absf(sin(t * 6.0)) * 34.0,
		"oops": 0.0, "cheer": -absf(sin(t * 7.0)) * 52.0}
	var tilt := {"idle": 0.0, "think": 0.10, "happy": sin(t * 6.0) * 0.08, "oops": sin(t * 5.0) * 0.05, "cheer": sin(t * 7.0) * 0.13}
	c.draw_set_transform(centre + Vector2(0, 170 * s), 0.0, Vector2(s, s * 0.25))
	c.draw_circle(Vector2.ZERO, 120.0, Color(0.1, 0.25, 0.2, 0.18))
	c.draw_set_transform(centre + Vector2(0, bounce.get(mood, 0.0) * s), tilt.get(mood, 0.0), Vector2(s, s))
	var body := Color("5c9ded")
	var dark := Color("3f7fd0")
	var ink := Color("22344f")
	var up := mood == "happy" or mood == "cheer"
	for side in [-1.0, 1.0]:
		c.draw_circle(Vector2(side * 60, 152), 38, dark)                     # feet
		var hand := Vector2(side * 168, -70 if up else 62)
		c.draw_line(Vector2(side * 118, 20), hand, dark, 38)                 # arms
		c.draw_circle(hand, 26, dark)
		c.draw_circle(Vector2(side * 92, -128), 44, dark)                    # ears
		c.draw_circle(Vector2(side * 92, -128), 24, Color("ffc1cf"))
	c.draw_circle(Vector2(0, 10), 150, body)
	c.draw_circle(Vector2(0, 62), 88, Color("e3f0ff"))
	for side in [-1.0, 1.0]:
		var eye := Vector2(side * 52, -38)
		if up:
			c.draw_arc(eye + Vector2(0, 10), 24, PI, TAU, 20, ink, 9, true)
		else:
			c.draw_circle(eye, 30, Color.WHITE)
			var look := Vector2(8, -10) if mood == "think" else (Vector2(0, 6) if mood == "oops" else Vector2.ZERO)
			if fmod(t, 3.6) < 0.12:
				c.draw_circle(eye, 30, body)
				c.draw_line(eye - Vector2(22, 0), eye + Vector2(22, 0), ink, 7)
			else:
				c.draw_circle(eye + look, 16, ink)
				c.draw_circle(eye + look + Vector2(-5, -6), 5, Color.WHITE)
		if mood == "oops":
			c.draw_line(eye + Vector2(-22, -38 - side * 7), eye + Vector2(22, -38 + side * 7), ink, 7)
		c.draw_circle(Vector2(side * 92, 4), 20, Color(1, 0.55, 0.6, 0.45))
	if up:
		var mouth := PackedVector2Array()
		for i in 17:
			mouth.append(Vector2(0, 14) + Vector2.from_angle(PI * i / 16.0) * 34.0)
		c.draw_colored_polygon(mouth, ink)
		c.draw_circle(Vector2(0, 36), 10, Color("ff7b8a"))
	elif mood == "oops":
		c.draw_arc(Vector2(0, 24), 18, 0.2, PI - 0.2, 16, ink, 7, true)
	elif mood == "think":
		c.draw_line(Vector2(-14, 26), Vector2(18, 20), ink, 7)
	else:
		c.draw_arc(Vector2(0, 6), 28, 0.35, PI - 0.35, 20, ink, 7, true)
	c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


static func draw_star(c: CanvasItem, centre: Vector2, r: float, color: Color, turn := 0.0) -> void:
	var p := PackedVector2Array()
	for i in 10:
		p.append(centre + Vector2.from_angle(-PI / 2 + turn + i * PI / 5) * (r if i % 2 == 0 else r * 0.46))
	c.draw_colored_polygon(p, color)


static func button(parent: Control, label: String, r: Rect2, cb: Callable, color := TEAL) -> Button:
	var b := Button.new()
	b.text = label
	b.position = r.position
	b.size = r.size
	b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_override("font", FONT)
	b.add_theme_font_size_override("font_size", 26)
	for n in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		b.add_theme_color_override(n, Color.WHITE)
	for state in {"normal": 0.0, "hover": 0.12, "pressed": -0.15, "disabled": 0.0}:
		var sb := StyleBoxFlat.new()
		var v: float = {"normal": 0.0, "hover": 0.1, "pressed": -0.15, "disabled": 0.0}[state]
		sb.bg_color = color.lightened(v) if v >= 0.0 else color.darkened(-v)
		if state == "disabled":
			sb.bg_color = Color(0.6, 0.66, 0.7)
		sb.set_corner_radius_all(20)
		b.add_theme_stylebox_override(state, sb)
	b.pressed.connect(cb)
	parent.add_child(b)
	return b


## The object's picture without its colour ("shape only" level).
static func grey_tex(id: String) -> Texture2D:
	var key := "grey:" + id
	if not _cache.has(key):
		var t := object_tex(id)
		_cache[key] = null
		if t:
			var img := t.get_image()
			if img.is_compressed():
				img.decompress()
			img.convert(Image.FORMAT_LA8)
			_cache[key] = ImageTexture.create_from_image(img)
	return _cache[key]

static func draw_grey_object(c: CanvasItem, id: String, centre: Vector2, size: float) -> void:
	var t := grey_tex(id)
	if t:
		c.draw_texture_rect(t, Rect2(centre - Vector2(size, size) / 2.0, Vector2(size, size)), false, Color(1.1, 1.1, 1.15))
