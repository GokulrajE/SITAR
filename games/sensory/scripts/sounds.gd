extends Control
## Listen & Discover: a sound plays by itself, then the player taps its picture.
## The big speaker replays it at any time. Rounds move on by themselves.
const Shell = preload("res://scripts/shared/game_shell.gd")
const TouchButtons = preload("res://scripts/shared/touch_buttons.gd")
const ATLAS := preload("res://assets/images/sensory/atlas.png")
const FONT := preload("res://assets/fonts/Nunito-SemiBold.ttf")
const ICONS := preload("res://assets/images/cognitive/shared/ui_icons_4x4.png")
const ITEMS = [
	{name = "Bird", category = "Nature", cell = 0, audio = "bird"},
	{name = "Guitar", category = "Music", cell = 3, audio = "guitar"},
	{name = "Telephone", category = "Everyday", cell = 6, audio = "phone"},
	{name = "Car", category = "Vehicles", cell = 7, audio = "car"},
	{name = "Rain", category = "Nature", cell = 1, audio = "rain"},
	{name = "Waves", category = "Nature", cell = 2, audio = "waves"},
	{name = "Train", category = "Vehicles", cell = 8, audio = "train"},
	{name = "Piano", category = "Music", cell = 4, audio = "piano"},
	{name = "Bell", category = "Everyday", cell = 5, audio = "bell"},
]
const LEVELS = [
	{choices = 2, rounds = 4, seconds = 7.0, pool = [0, 1, 2, 3]},
	{choices = 3, rounds = 6, seconds = 7.0, pool = [0, 1, 2, 3, 4, 5, 6, 7, 8]},
	{choices = 4, rounds = 9, seconds = 3.0, pool = [0, 1, 2, 3, 4, 5, 6, 7, 8]},
]
const SAVE := "user://sensory_progress.cfg"
const SPEAKER := Vector2(960, 330)

var shell: Control
var level := 0
var playing := false
var paused := false
var round_index := 0
var answer := 0
var mistakes := 0
var score := 0
var solved := false
var deck: Array = []
var _wait := 0.0
var _replay_in := 0.0
var _clock := 0.0
var _cards: Array[Button] = []
var _speaker: Button
@onready var audio := AudioStreamPlayer.new()


func _ready() -> void:
	size = Vector2(1920, 1080)
	add_child(audio)
	_speaker = Button.new()
	_speaker.position = SPEAKER - Vector2(120, 120)
	_speaker.size = Vector2(240, 240)
	_speaker.flat = true
	_speaker.focus_mode = FOCUS_NONE
	_speaker.pressed.connect(play_sound)
	add_child(_speaker)
	for index in 4:
		var card := Button.new()
		card.focus_mode = FOCUS_NONE
		card.flat = true
		card.pressed.connect(func(): choose(index))
		add_child(card)
		_cards.append(card)
	shell = Shell.new()
	shell.title = "Listen & Discover"
	shell.levels = ["Easy", "Medium", "Hard"]
	shell.notes = ["2 pictures", "3 pictures", "4 similar sounds"]
	shell.accent = Color("2f7f86")
	add_child(shell)
	shell.start_pressed.connect(start)
	shell.pause_changed.connect(func(value: bool):
		paused = value
		if value: audio.stop())
	shell.stop_pressed.connect(func():
		playing = false
		audio.stop()
		_show_board(false))
	_show_board(false)


func start(chosen: int) -> void:
	level = chosen
	round_index = 0
	mistakes = 0
	score = 0
	paused = false
	playing = true
	_wait = 0.0
	_replay_in = 0.0
	deck = LEVELS[level].pool.duplicate()
	deck.shuffle()
	_show_board(true)
	new_round()


func new_round() -> void:
	solved = false
	answer = deck[round_index % deck.size()]
	var options := [answer]
	var others: Array = LEVELS[level].pool.duplicate()
	others.erase(answer)
	others.shuffle()
	# Hard puts similar sounds side by side: guitar and piano, rain and waves.
	if level == 2:
		others.sort_custom(func(a, b): return ITEMS[a].category == ITEMS[answer].category and ITEMS[b].category != ITEMS[answer].category)
	options.append_array(others.slice(0, LEVELS[level].choices - 1))
	options.shuffle()
	var count := options.size()
	var width := 400.0 if count <= 3 else 380.0
	var gap := 40.0
	var left := (1920.0 - count * width - (count - 1) * gap) * 0.5
	for index in 4:
		var card := _cards[index]
		card.visible = index < count
		if index >= count: continue
		card.position = Vector2(left + index * (width + gap), 560)
		card.size = Vector2(width, 400)
		card.set_meta("item", options[index])
		card.set_meta("look", "idle")
		card.disabled = false
	shell.set_status("Sound %d of %d" % [round_index + 1, LEVELS[level].rounds])
	_replay_in = 0.6
	queue_redraw()


func play_sound() -> void:
	if not playing or paused: return
	audio.stream = load("res://assets/audio/sensory/%s.ogg" % ITEMS[answer].audio)
	audio.play()
	if AudioServer.is_bus_mute(0): shell.toast("Sound is off — tap the speaker at the top right", false)


func choose(index: int) -> void:
	if not playing or paused or solved: return
	var card := _cards[index]
	if int(card.get_meta("item")) == answer:
		solved = true
		score += 100 if card.get_meta("look") == "idle" else 0
		card.set_meta("look", "right")
		audio.stop()
		shell.toast("Yes — %s!" % ITEMS[answer].name.to_lower())
		_wait = 1.3
	else:
		mistakes += 1
		card.set_meta("look", "wrong")
		card.disabled = true
		shell.toast("Listen again", false)
		_replay_in = 0.5
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
	if audio.playing and audio.get_playback_position() >= LEVELS[level].seconds: audio.stop()
	if _replay_in > 0.0:
		_replay_in -= delta
		if _replay_in <= 0.0: play_sound()
	if _wait > 0.0:
		_wait -= delta
		if _wait <= 0.0:
			round_index += 1
			if round_index >= LEVELS[level].rounds: _finish()
			else: new_round()
	queue_redraw()


func _finish() -> void:
	playing = false
	audio.stop()
	_show_board(false)
	var config := ConfigFile.new()
	config.load(SAVE)
	var best := maxi(score, int(config.get_value("sound_levels", str(level), 0)))
	config.set_value("sound_levels", str(level), best)
	config.save(SAVE)
	var stars := 3 if mistakes == 0 else (2 if mistakes <= 2 else 1)
	shell.finish(stars, "Level %d complete!" % (level + 1), "%d points  •  best %d" % [score, best])


func _show_board(value: bool) -> void:
	_speaker.visible = value
	for card in _cards: card.visible = value and card.has_meta("item")
	queue_redraw()


# ------------------------------------------------------------------ art

func _draw() -> void:
	# A calm listening room: warm wall, soft rings spreading from the speaker.
	draw_rect(Rect2(0, 0, 1920, 1080), Color("eef3ee"))
	draw_rect(Rect2(0, 0, 1920, 520), Color("dcebe6"))
	for i in 5:
		var t := fmod(_clock * 0.35 + i / 5.0, 1.0) if audio.playing else i / 5.0
		draw_arc(SPEAKER, 140.0 + t * 380.0, 0, TAU, 96, Color(0.18, 0.5, 0.52, (0.35 if audio.playing else 0.1) * (1.0 - t)), 6.0, true)
	if not _speaker.visible: return
	var lift := 1.06 if _speaker.is_hovered() else 1.0
	draw_circle(SPEAKER + Vector2(0, 8), 124 * lift, Color(0, 0, 0, 0.12))
	draw_circle(SPEAKER, 120 * lift, Color("2f7f86"))
	draw_circle(SPEAKER, 104 * lift, Color("3c9aa1"))
	draw_texture_rect_region(ICONS, Rect2(SPEAKER - Vector2(78, 78) * lift, Vector2(156, 156) * lift), Rect2(0, 256, 256, 256), Color(1, 1, 1))
	for card in _cards:
		if card.visible: _draw_card(card)


func _draw_card(card: Button) -> void:
	var area := Rect2(card.position, card.size)
	var look: String = card.get_meta("look", "idle")
	var box := StyleBoxFlat.new()
	box.bg_color = {idle = Color.WHITE, right = Color("dff3e4"), wrong = Color("e9e9e4")}[look]
	box.set_corner_radius_all(36)
	box.set_border_width_all(8 if look == "right" else 0)
	box.border_color = Color("3f9a5c")
	box.shadow_color = Color(0, 0, 0, 0.14)
	box.shadow_size = 14
	box.shadow_offset = Vector2(0, 6)
	if card.is_hovered() and look == "idle": area = area.grow(6)
	draw_style_box(box, area)
	var item: Dictionary = ITEMS[card.get_meta("item")]
	var unit := ATLAS.get_size() / 3.0
	var tint := Color(1, 1, 1, 0.35) if look == "wrong" else Color.WHITE
	draw_texture_rect_region(ATLAS, Rect2(area.position + Vector2(area.size.x * 0.5 - 140, 30), Vector2(280, 280)),
		Rect2(Vector2(item.cell % 3, item.cell / 3) * unit, unit), tint)
	draw_string(FONT, Vector2(area.position.x, area.end.y - 32), item.name, HORIZONTAL_ALIGNMENT_CENTER, area.size.x, 44, Color("243e40", tint.a))
