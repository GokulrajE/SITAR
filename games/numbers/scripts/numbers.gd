extends Control
## Calculation practice. Two games share this script, each with its own place:
##   0 Quick Sums    - a chalkboard sum, pick the answer
##   1 Market Basket - prices on a market counter: the total, or the change
## Ten questions per session; the next one follows by itself.
const Shell = preload("res://scripts/shared/game_shell.gd")
const TouchButtons = preload("res://scripts/shared/touch_buttons.gd")
const FRUITS := preload("res://assets/images/cognitive/objects/fruits_4x4.png")
const FONT := preload("res://assets/fonts/Nunito-SemiBold.ttf")
const FRUIT_NAMES := ["mango", "banana", "apple", "orange", "watermelon", "pineapple", "grapes", "pomegranate",
	"coconut", "papaya", "tomato", "carrot", "brinjal", "corn", "chilli", "pumpkin"]
const QUESTIONS := 10
const SAVE := "user://numbers_progress.cfg"

@export_enum("Quick Sums", "Market Basket") var game := 0

var shell: Control
var level := 0
var playing := false
var paused := false
var question := 0
var mistakes := 0
var score := 0
var answer := 0
var prompt := ""
var items: Array = []          ## market: {cell, price, count}
var paid := 0                  ## market level 3: the note handed over
var solved := false
var _wait := 0.0
var _clock := 0.0
var _wrong_flash := {}
var _buttons: Array[Button] = []
@onready var _chalk := Color(0.96, 0.96, 0.9)


func _ready() -> void:
	size = Vector2(1920, 1080)
	for index in 4:
		var button := Button.new()
		button.focus_mode = FOCUS_NONE
		button.add_theme_font_override("font", FONT)
		button.add_theme_font_size_override("font_size", 84)
		button.pressed.connect(func(): choose(index))
		add_child(button)
		_buttons.append(button)
	shell = Shell.new()
	if game == 0:
		shell.title = "Quick Sums"
		shell.levels = ["Simple", "Bigger", "Two steps"]
		shell.notes = ["Up to 20", "Up to 100, and times", "Like 6 × 4 − 9"]
		shell.accent = Color("2f6b4a")
	else:
		shell.title = "Market Basket"
		shell.levels = ["Two items", "Many items", "Change"]
		shell.notes = ["Add two prices", "Prices and quantities", "Count the change"]
		shell.accent = Color("b5532a")
	add_child(shell)
	shell.start_pressed.connect(start)
	shell.pause_changed.connect(func(value: bool): paused = value)
	shell.stop_pressed.connect(func(): playing = false; _show_buttons(false))
	_show_buttons(false)


func start(chosen: int) -> void:
	level = chosen
	question = 0
	mistakes = 0
	score = 0
	paused = false
	playing = true
	_wait = 0.0
	next_question()


func next_question() -> void:
	solved = false
	_wrong_flash.clear()
	if game == 0: _make_sum()
	else: _make_market()
	var options := _options()
	var count := options.size()
	var width := 330.0
	var gap := 40.0
	var left := (1920.0 - count * width - (count - 1) * gap) * 0.5
	for index in 4:
		var button := _buttons[index]
		button.visible = index < count
		if index >= count: continue
		button.set_meta("value", options[index])
		button.text = ("₹%d" % options[index]) if game == 1 else str(options[index])
		button.position = Vector2(left + index * (width + gap), 840)
		button.size = Vector2(width, 170)
		button.disabled = false
		_style(button, "idle")
	shell.set_status("Question %d of %d" % [question + 1, QUESTIONS])
	queue_redraw()


func choose(index: int) -> void:
	if not playing or paused or solved: return
	var button := _buttons[index]
	if int(button.get_meta("value")) == answer:
		solved = true
		score += 100 if not _wrong_flash else 50
		_style(button, "right")
		for other in _buttons: other.disabled = other != button
		shell.toast(["Correct!", "Well done!", "That's right!"][question % 3])
		_wait = 1.1
	else:
		mistakes += 1
		_wrong_flash[index] = 0.5
		_style(button, "wrong")
		button.disabled = true
		shell.toast("Not quite. Try again.", false)
	queue_redraw()


func _input(event: InputEvent) -> void:
	if playing and not paused and TouchButtons.is_finger_down(event):
		var button := TouchButtons.button_at(self, event.position)
		if button:
			get_viewport().set_input_as_handled()
			TouchButtons.press(button)


func _process(delta: float) -> void:
	_clock += delta
	if not playing or paused: return
	for key in _wrong_flash.keys(): _wrong_flash[key] = maxf(0.0, _wrong_flash[key] - delta)
	if _wait > 0.0:
		_wait -= delta
		if _wait <= 0.0:
			question += 1
			if question >= QUESTIONS: _finish()
			else: next_question()
	queue_redraw()


func _finish() -> void:
	playing = false
	_show_buttons(false)
	var stars := 3 if mistakes <= 1 else (2 if mistakes <= 4 else 1)
	var config := ConfigFile.new()
	config.load(SAVE)
	var key := "%d_%d" % [game, level]
	var best := maxi(score, int(config.get_value("best", key, 0)))
	config.set_value("best", key, best)
	config.save(SAVE)
	shell.finish(stars, "Level %d complete!" % (level + 1), "%d points  •  %d to try again  •  best %d" % [score, mistakes, best])


# ------------------------------------------------------------------ questions

func _make_sum() -> void:
	match level:
		0:
			var a := randi_range(2, 12)
			var b := randi_range(1, 9)
			if randf() < 0.5 or a <= b:
				answer = a + b
				prompt = "%d + %d" % [a, b]
			else:
				answer = a - b
				prompt = "%d − %d" % [a, b]
		1:
			match randi() % 3:
				0:
					var a := randi_range(12, 58)
					var b := randi_range(6, 39)
					answer = a + b
					prompt = "%d + %d" % [a, b]
				1:
					var a := randi_range(30, 95)
					var b := randi_range(8, a - 5)
					answer = a - b
					prompt = "%d − %d" % [a, b]
				_:
					var a := randi_range(2, 9)
					var b := randi_range(2, 10)
					answer = a * b
					prompt = "%d × %d" % [a, b]
		_:
			match randi() % 3:
				0:
					var a := randi_range(3, 9)
					var b := randi_range(3, 9)
					var c := randi_range(2, a * b - 1)
					answer = a * b - c
					prompt = "%d × %d − %d" % [a, b, c]
				1:
					var a := randi_range(2, 9)
					var b := randi_range(2, 9)
					var c := randi_range(2, 5)
					answer = (a + b) * c
					prompt = "(%d + %d) × %d" % [a, b, c]
				_:
					var a := randi_range(20, 60)
					var b := randi_range(5, 19)
					var c := randi_range(5, 30)
					answer = a - b + c
					prompt = "%d − %d + %d" % [a, b, c]


func _make_market() -> void:
	items.clear()
	paid = 0
	var cells := range(16)
	cells.shuffle()
	match level:
		0:
			for index in 2: items.append({cell = cells[index], price = randi_range(2, 10), count = 1})
		1:
			for index in randi_range(2, 3): items.append({cell = cells[index], price = randi_range(5, 30), count = 1})
			items[randi() % items.size()].count = randi_range(2, 3)
		_:
			for index in 2: items.append({cell = cells[index], price = randi_range(8, 60), count = 1})
	answer = 0
	for item in items: answer += item.price * item.count
	if level == 2:
		for note in [50, 100, 200, 500]:
			if note > answer:
				paid = note
				break
		answer = paid - answer


## The answer and close, believable wrong answers, shuffled.
func _options() -> Array:
	var count := 3 if level == 0 else 4
	var options := [answer]
	# Simple sums get very close neighbours; harder ones also the slips of ten.
	var near := [1, -1, 2, -2, 3, -3] if level == 0 else [1, -1, 2, -2, 10, -10, 5, -5]
	near.shuffle()
	for step in near:
		var value: int = answer + step
		if value >= 0 and value not in options: options.append(value)
		if options.size() == count: break
	options.shuffle()
	return options


# ------------------------------------------------------------------ art

func _draw() -> void:
	if game == 0: _draw_classroom()
	else: _draw_market()


func _draw_classroom() -> void:
	draw_rect(Rect2(0, 0, 1920, 1080), Color("e9dcc0"))
	for i in 24: draw_rect(Rect2(i * 80, 0, 2, 1080), Color(0, 0, 0, 0.03))
	draw_rect(Rect2(0, 780, 1920, 300), Color("c9a878"))
	draw_rect(Rect2(0, 780, 1920, 8), Color("8f6c3e"))
	# The board with a wooden frame and a chalk tray.
	draw_rect(Rect2(170, 130, 1580, 620), Color("6b4a2b"))
	draw_rect(Rect2(196, 156, 1528, 568), Color("2e4a3b"))
	for i in 40:
		var at := Vector2(fmod(i * 397.0, 1500.0) + 210, fmod(i * 211.0, 540.0) + 170)
		draw_circle(at, 30.0 + fmod(i * 7.0, 40.0), Color(1, 1, 1, 0.012))
	draw_rect(Rect2(260, 740, 1400, 24), Color("5a3d22"))
	draw_rect(Rect2(420, 728, 70, 14), Color.WHITE)
	draw_rect(Rect2(1320, 730, 50, 12), Color("f1d26a"))
	if not playing and question == 0: return
	var text := prompt + " = " + (str(answer) if solved else "?")
	var wobble := sin(_clock * 1.5) * 1.5
	draw_string(FONT, Vector2(196, 470 + wobble), text, HORIZONTAL_ALIGNMENT_CENTER, 1528, 170, _chalk)
	draw_line(Vector2(560, 540), Vector2(1360, 540), Color(_chalk, 0.25), 4.0, true)
	if solved: _tick(Vector2(1580, 300))


func _draw_market() -> void:
	draw_rect(Rect2(0, 0, 1920, 1080), Color("f6e7c8"))
	# Striped awning.
	for i in 13:
		draw_rect(Rect2(i * 150, 0, 150, 150), Color("c8462e") if i % 2 == 0 else Color("fbf3e4"))
	for i in 13:
		draw_circle(Vector2(i * 150 + 75, 150), 75, Color("c8462e") if i % 2 == 0 else Color("fbf3e4"))
	# Counter.
	draw_rect(Rect2(0, 640, 1920, 440), Color("9c6b3c"))
	for i in 6: draw_rect(Rect2(0, 660 + i * 70, 1920, 3), Color(0, 0, 0, 0.12))
	draw_rect(Rect2(0, 630, 1920, 24), Color("7a4f28"))
	if not playing and question == 0: return
	var count := items.size()
	var spacing := 420.0
	var left := 960.0 - (count - 1) * spacing * 0.5 - (180.0 if paid > 0 else 0.0)
	for index in count:
		var item: Dictionary = items[index]
		var centre := Vector2(left + index * spacing, 430)
		var cell: int = item.cell
		for copy in item.count:
			var shift := Vector2((copy - (item.count - 1) * 0.5) * 70.0, -copy * 8.0)
			draw_texture_rect_region(FRUITS, Rect2(centre + shift - Vector2(120, 140), Vector2(240, 240)),
				Rect2((cell % 4) * 512, floorf(cell / 4.0) * 512, 512, 512))
		var label := "₹%d" % item.price if item.count == 1 else "%d × ₹%d" % [item.count, item.price]
		_tag(Vector2(centre.x, 580), label)
	if paid > 0:
		var note := Rect2(1360, 330, 360, 190)
		draw_rect(note, Color("8fbf8a"))
		draw_rect(note.grow(-12), Color("b8dbb0"), false, 4.0)
		draw_string(FONT, Vector2(note.position.x, note.position.y + 125), "₹%d" % paid, HORIZONTAL_ALIGNMENT_CENTER, note.size.x, 86, Color("234a2a"))
		draw_string(FONT, Vector2(note.position.x, note.position.y - 20), "You pay", HORIZONTAL_ALIGNMENT_CENTER, note.size.x, 40, Color("3c2a16"))
	var ask := ("Change?" if paid > 0 else "Total?") if not solved else ("Change ₹%d" % answer if paid > 0 else "Total ₹%d" % answer)
	draw_string(FONT, Vector2(0, 760), ask, HORIZONTAL_ALIGNMENT_CENTER, 1920, 64, Color("fff4dc"))


func _tag(centre: Vector2, text: String) -> void:
	var width := maxf(200.0, FONT.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, 50).x + 60)
	var area := Rect2(centre.x - width * 0.5, centre.y - 40, width, 80)
	var box := StyleBoxFlat.new()
	box.bg_color = Color("fffaf0")
	box.set_corner_radius_all(18)
	box.set_border_width_all(4)
	box.border_color = Color("3c2a16")
	draw_style_box(box, area)
	draw_string(FONT, Vector2(area.position.x, area.position.y + 58), text, HORIZONTAL_ALIGNMENT_CENTER, width, 50, Color("3c2a16"))


func _tick(at: Vector2) -> void:
	draw_polyline(PackedVector2Array([at + Vector2(-50, 0), at + Vector2(-10, 45), at + Vector2(70, -60)]), Color("9be29b"), 16.0, true)


func _style(button: Button, look: String) -> void:
	var fill: Color = {idle = Color("fffaf0"), right = Color("3f9a5c"), wrong = Color("d9c9b5")}[look]
	var ink := Color.WHITE if look == "right" else (Color("8a7a66") if look == "wrong" else Color("26323a"))
	for state in ["normal", "hover", "pressed", "hover_pressed", "disabled"]:
		var box := StyleBoxFlat.new()
		box.bg_color = fill.lightened(0.05) if state == "hover" else fill
		box.set_corner_radius_all(36)
		box.set_border_width_all(6)
		box.border_color = Color("6b4a2b") if game == 0 else Color("7a4f28")
		box.shadow_color = Color(0, 0, 0, 0.25)
		box.shadow_size = 10
		box.shadow_offset = Vector2(0, 5)
		button.add_theme_stylebox_override(state, box)
	for key in ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color", "font_hover_pressed_color"]:
		button.add_theme_color_override(key, ink)


func _show_buttons(value: bool) -> void:
	for button in _buttons: button.visible = value and button.has_meta("value")
	queue_redraw()
