extends Control
## The same frame around every game, so each one is learnt once:
##   start screen  - game name, one card per level, one big Start button
##   while playing - Home top left; Pause and Sound top right; a status pill
##   pause         - Continue or End game
##   results       - stars, one line, Play again / Next level / Levels
## The game keeps its own art behind this layer and listens to the signals.
const TouchButtons = preload("res://scripts/shared/touch_buttons.gd")
const ICONS := preload("res://assets/images/cognitive/shared/ui_icons_4x4.png")
const FONT := preload("res://assets/fonts/Nunito-SemiBold.ttf")
const LAUNCHER := "res://scenes/ui/launcher.tscn"
const ICON := {home = 0, pause = 1, sound = 4, muted = 5, star = 7, no_star = 8}
const INK := Color("1d2b33")

signal start_pressed(level: int)
signal pause_changed(paused: bool)
## The player ended a session from the pause screen.
signal stop_pressed
signal extra_pressed

@export var title := ""
@export var levels: PackedStringArray = ["Easy", "Medium", "Hard"]
## One short line per level, e.g. "2 choices".
@export var notes: PackedStringArray = []
@export var accent := Color("2f8f83")
## An optional small button under Start, e.g. "Set up boards".
@export var extra := ""
@export_range(0.0, 1.0) var dim := 0.45
## Top of the short message; games with something at the bottom move it up.
@export var toast_y := 900.0
## Tests switch this off.
@export var auto_fullscreen := true

var level := 0
var state := "start"
var _veil: ColorRect
var _start: Control
var _pause_box: Control
var _results: Control
var _cards: Array[Button] = []
var _status: Label
var _toast: Label
var _toast_tween: Tween
var _home: Button
var _pause: Button
var _sound: Button
var _result_title: Label
var _result_line: Label
var _stars: Array[TextureRect] = []
var _next: Button
var _again: Button


func _ready() -> void:
	# The whole project is laid out on a 1920 × 1080 canvas.
	size = Vector2(1920, 1080)
	mouse_filter = MOUSE_FILTER_IGNORE
	theme = Theme.new()
	theme.default_font = FONT
	theme.default_font_size = 32
	_veil = ColorRect.new()
	_veil.color = Color(0.02, 0.03, 0.05, dim)
	_veil.size = size
	add_child(_veil)
	_build_hud()
	_build_start()
	_build_pause()
	_build_results()
	choose_level(clampi(level, 0, levels.size() - 1))
	_show("start")


# ------------------------------------------------------------------ public

## The start screen, e.g. after a session was ended.
func show_start() -> void:
	_show("start")


func set_status(text: String) -> void:
	_status.text = text
	_status.visible = text != "" and state != "start"


## A short message that fades by itself. Replaces paragraphs of instructions.
func toast(text: String, good := true) -> void:
	_toast.text = text
	_toast.add_theme_color_override("font_color", Color("1f7a4d") if good else Color("9a4a14"))
	_toast.show()
	_toast.modulate.a = 1.0
	if _toast_tween: _toast_tween.kill()
	_toast_tween = create_tween()
	_toast_tween.tween_interval(1.4)
	_toast_tween.tween_property(_toast, "modulate:a", 0.0, 0.4)
	_toast_tween.tween_callback(_toast.hide)


## Ends a session. `stars` 0..3; 0 means the level was not completed.
func finish(stars: int, headline: String, line: String) -> void:
	_result_title.text = headline
	_result_line.text = line
	for index in 3:
		_stars[index].texture = _icon(ICON.star if index < stars else ICON.no_star)
		_stars[index].visible = stars > 0
	_next.visible = stars > 0 and level < levels.size() - 1
	_show("results")


func pause() -> void:
	if state != "playing": return
	_show("paused")
	pause_changed.emit(true)


func resume() -> void:
	if state != "paused": return
	_show("playing")
	pause_changed.emit(false)


func choose_level(index: int) -> void:
	level = index
	for card in _cards.size():
		_style_card(_cards[card], card == level)


func begin() -> void:
	_show("playing")
	if auto_fullscreen and DisplayServer.get_name() != "headless" and get_viewport() == get_window():
		get_window().mode = Window.MODE_FULLSCREEN
	start_pressed.emit(level)


# ------------------------------------------------------------------ building

func _build_hud() -> void:
	_home = _round_button(Vector2(28, 22), ICON.home, "Home")
	_home.pressed.connect(func(): get_tree().change_scene_to_file(LAUNCHER))
	_sound = _round_button(Vector2(1800, 22), ICON.sound, "Sound")
	_sound.toggle_mode = true
	_sound.button_pressed = AudioServer.is_bus_mute(0)
	_sound.toggled.connect(func(value: bool):
		AudioServer.set_bus_mute(0, value)
		_show_mute())
	_show_mute()
	_pause = _round_button(Vector2(1680, 22), ICON.pause, "Pause")
	_pause.pressed.connect(pause)
	_status = Label.new()
	_status.position = Vector2(560, 28)
	_status.size = Vector2(800, 80)
	_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_status.add_theme_font_size_override("font_size", 36)
	_status.add_theme_color_override("font_color", INK)
	_status.add_theme_stylebox_override("normal", _box(Color(1, 1, 1, 0.9), 40))
	_status.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(_status)
	_toast = Label.new()
	_toast.position = Vector2(460, toast_y)
	_toast.size = Vector2(1000, 110)
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_toast.add_theme_font_size_override("font_size", 46)
	_toast.add_theme_stylebox_override("normal", _box(Color(1, 1, 1, 0.94), 55))
	_toast.mouse_filter = MOUSE_FILTER_IGNORE
	_toast.hide()
	add_child(_toast)


func _build_start() -> void:
	_start = Control.new()
	_start.size = size
	_start.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(_start)
	var name_label := _label(title, 92, Color.WHITE)
	name_label.position = Vector2(0, 170)
	name_label.size = Vector2(1920, 130)
	name_label.add_theme_constant_override("outline_size", 14)
	name_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.55))
	_start.add_child(name_label)
	var count := levels.size()
	var width := 300.0 if count <= 3 else (280.0 if count == 4 else 250.0)
	var gap := 36.0
	var left := (1920.0 - count * width - (count - 1) * gap) * 0.5
	for index in count:
		var card := Button.new()
		card.position = Vector2(left + index * (width + gap), 360)
		card.size = Vector2(width, 250)
		card.focus_mode = FOCUS_NONE
		card.pressed.connect(func(): choose_level(index))
		var number := _label(str(index + 1), 80, INK)
		number.name = "Number"
		number.position = Vector2(0, 16)
		number.size = Vector2(width, 100)
		card.add_child(number)
		var heading := _label(levels[index], 38, INK)
		heading.name = "Heading"
		heading.position = Vector2(0, 118)
		heading.size = Vector2(width, 56)
		card.add_child(heading)
		var note := _label(notes[index] if index < notes.size() else "", 26, INK)
		note.name = "Note"
		note.position = Vector2(10, 174)
		note.size = Vector2(width - 20, 56)
		note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		card.add_child(note)
		_start.add_child(card)
		_cards.append(card)
	var start := _wide_button("Start", Vector2(680, 680), Vector2(560, 130), 60, true)
	start.name = "Start"
	start.pressed.connect(begin)
	_start.add_child(start)
	if extra != "":
		var more := _wide_button(extra, Vector2(760, 840), Vector2(400, 86), 32, false)
		more.name = "Extra"
		more.pressed.connect(func(): extra_pressed.emit())
		_start.add_child(more)


func _build_pause() -> void:
	_pause_box = _panel(Vector2(660, 300), Vector2(600, 480))
	var heading := _label("Paused", 64, INK)
	heading.position = Vector2(0, 40)
	heading.size = Vector2(600, 90)
	_pause_box.add_child(heading)
	var go_on := _wide_button("Continue", Vector2(80, 170), Vector2(440, 120), 46, true)
	go_on.name = "Continue"
	go_on.pressed.connect(resume)
	_pause_box.add_child(go_on)
	var stop := _wide_button("End game", Vector2(80, 320), Vector2(440, 100), 36, false)
	stop.name = "EndGame"
	stop.pressed.connect(func():
		_show("start")
		stop_pressed.emit())
	_pause_box.add_child(stop)


func _build_results() -> void:
	_results = _panel(Vector2(510, 200), Vector2(900, 700))
	_result_title = _label("", 62, INK)
	_result_title.position = Vector2(0, 40)
	_result_title.size = Vector2(900, 90)
	_results.add_child(_result_title)
	var row := HBoxContainer.new()
	row.position = Vector2(225, 150)
	row.size = Vector2(450, 150)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 20)
	_results.add_child(row)
	for index in 3:
		var star := TextureRect.new()
		star.custom_minimum_size = Vector2(136, 136)
		star.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		star.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		row.add_child(star)
		_stars.append(star)
	_result_line = _label("", 36, INK)
	_result_line.position = Vector2(40, 310)
	_result_line.size = Vector2(820, 110)
	_result_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_results.add_child(_result_line)
	_next = _wide_button("Next level", Vector2(230, 440), Vector2(440, 110), 44, true)
	_next.name = "NextLevel"
	_next.pressed.connect(func():
		choose_level(mini(level + 1, levels.size() - 1))
		begin())
	_results.add_child(_next)
	_again = _wide_button("Play again", Vector2(90, 575), Vector2(340, 90), 34, false)
	_again.name = "PlayAgain"
	_again.pressed.connect(begin)
	_results.add_child(_again)
	var menu := _wide_button("Levels", Vector2(470, 575), Vector2(340, 90), 34, false)
	menu.name = "Levels"
	menu.pressed.connect(show_start)
	_results.add_child(menu)


func _show(which: String) -> void:
	state = which
	_start.visible = which == "start"
	_pause_box.visible = which == "paused"
	_results.visible = which == "results"
	_veil.visible = which != "playing"
	_veil.color.a = dim if which == "start" else 0.5
	_pause.visible = which == "playing"
	_status.visible = _status.text != "" and which != "start"
	if which != "playing": _toast.hide()
	# Results slide in rather than pop.
	if which in ["results", "paused"]:
		var box := _results if which == "results" else _pause_box
		box.pivot_offset = box.size * 0.5
		box.scale = Vector2.ONE * 0.9
		create_tween().tween_property(box, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


# ------------------------------------------------------------------ input

func _input(event: InputEvent) -> void:
	if TouchButtons.is_finger_down(event):
		var button := TouchButtons.button_at(self, event.position)
		if button:
			get_viewport().set_input_as_handled()
			TouchButtons.press(button)
		elif state != "playing":
			# The game behind the menus never sees touches.
			get_viewport().set_input_as_handled()
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if state == "playing": pause()
			elif state == "paused": resume()
			else: return
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_F11:
			var window := get_window()
			window.mode = Window.MODE_WINDOWED if window.mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN
			get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT: pause()


# ------------------------------------------------------------------ helpers

func _show_mute() -> void:
	_sound.icon = _icon(ICON.muted if AudioServer.is_bus_mute(0) else ICON.sound)


func _icon(index: int) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = ICONS
	atlas.region = Rect2((index % 4) * 256, floorf(index / 4.0) * 256, 256, 256)
	return atlas


func _box(colour: Color, radius: int, border := Color.TRANSPARENT) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = colour
	box.set_corner_radius_all(radius)
	box.content_margin_left = 24
	box.content_margin_right = 24
	if border.a > 0:
		box.set_border_width_all(6)
		box.border_color = border
	box.shadow_color = Color(0, 0, 0, 0.22)
	box.shadow_size = 10
	box.shadow_offset = Vector2(0, 4)
	return box


func _label(text: String, font_size: int, colour: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", colour)
	label.mouse_filter = MOUSE_FILTER_IGNORE
	return label


func _panel(at: Vector2, area: Vector2) -> Panel:
	var panel := Panel.new()
	panel.position = at
	panel.size = area
	panel.add_theme_stylebox_override("panel", _box(Color(1, 0.99, 0.96, 0.97), 40))
	add_child(panel)
	return panel


func _round_button(at: Vector2, icon_index: int, tip: String) -> Button:
	var button := Button.new()
	button.position = at
	button.size = Vector2(92, 92)
	button.tooltip_text = tip
	button.icon = _icon(icon_index)
	button.expand_icon = true
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.focus_mode = FOCUS_NONE
	for look in ["normal", "hover", "pressed", "hover_pressed"]:
		var box := _box(Color(1, 1, 1, 0.92 if look == "normal" else 1.0), 46)
		box.content_margin_left = 10
		box.content_margin_right = 10
		box.content_margin_top = 10
		box.content_margin_bottom = 10
		button.add_theme_stylebox_override(look, box)
	add_child(button)
	return button


func _wide_button(text: String, at: Vector2, area: Vector2, font_size: int, main: bool) -> Button:
	var button := Button.new()
	button.text = text
	button.position = at
	button.size = area
	button.focus_mode = FOCUS_NONE
	button.add_theme_font_size_override("font_size", font_size)
	var fill := accent if main else Color(1, 1, 1, 0.95)
	var ink := Color.WHITE if main else INK
	for look in ["normal", "hover", "pressed", "hover_pressed"]:
		var shade := fill.lightened(0.1) if look == "hover" else (fill.darkened(0.15) if "pressed" in look else fill)
		button.add_theme_stylebox_override(look, _box(shade, int(area.y * 0.5), Color.TRANSPARENT if main else Color(accent, 0.6)))
	for key in ["font_color", "font_hover_color", "font_pressed_color", "font_hover_pressed_color"]:
		button.add_theme_color_override(key, ink)
	return button


func _style_card(card: Button, chosen: bool) -> void:
	var fill := accent if chosen else Color(1, 1, 1, 0.93)
	for look in ["normal", "hover", "pressed", "hover_pressed"]:
		var box := _box(fill if look != "hover" or chosen else Color.WHITE, 34, Color.WHITE if chosen else Color.TRANSPARENT)
		card.add_theme_stylebox_override(look, box)
	var ink := Color.WHITE if chosen else INK
	for part in ["Number", "Heading", "Note"]:
		card.get_node(part).add_theme_color_override("font_color", ink)
	card.scale = Vector2.ONE * (1.04 if chosen else 1.0)
	card.pivot_offset = card.size * 0.5
