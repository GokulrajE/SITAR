extends Control
## Memory Meadow, Melody Steps and Focus Finder in 2D.
## All delayed gameplay advances through _process, so pause freezes every phase.
const Art = preload("res://games/cognitive/scripts/cognitive_art.gd")
const Tile = preload("res://games/cognitive/scripts/cognitive_tile_2d.gd")
const TouchButtons = preload("res://scripts/shared/touch_buttons.gd")
const Fx = preload("res://games/cognitive/scripts/cognitive_fx.gd")
const NAMES = ["Memory Meadow", "Melody Steps", "Focus Finder"]

## The board lies to the right of the host.
const BOARD_AREA := Rect2(500, 140, 1360, 920)
const MELODY_AREA := Rect2(520, 215, 1300, 860)
const HOST_PLACE := [Vector2(250, 990), Vector2(235, 985), Vector2(235, 1020)]
const HOST_SIZE := [640.0, 800.0, 560.0]
## How long two different flowers stay open, after the second one has opened.
const LOOK_TIME := [1.3, 0.9, 0.6]
## One finger can break the infrared beams twice; a second touch this close in
## time and place is the same touch.
const SAME_TOUCH_TIME := 0.22
const SAME_TOUCH_DISTANCE := 120.0
## C major pentatonic, so every melody sounds pleasant.
const NOTE_HERTZ := [261.63, 293.66, 329.63, 392.0, 440.0, 523.25]
const ICON := {home = 0, pause = 1, sound = 4, muted = 5, clock = 6, star = 7, no_star = 8, look = 11, hand = 12}

static var _notes: Array[AudioStreamWAV] = []

@export var auto_fullscreen := true
## Tests switch this off, so that they never touch the saved best scores.
@export var persist := true
var mode := 0
var difficulty := 0
var state := "ready"
var score := 0
var attempts := 0
var correct := 0
var elapsed := 0.0
var remaining := 60.0
var stage := 1
var phase := ""
var delay := 0.0
var cards: Array = []
var selected: Array = []
var matched: Array = []
var sequence: Array = []
var sequence_index := 0
var playback := 0
var target := -1
var buttons: Array[Node2D] = []
var best: Dictionary = {}
var reduced_motion := false
var completed_level := false
var session_themes: Array = []
var _last_themes: Array = []
var _celebrations := 0
var _last_touch_time := -10.0
var _last_touch_place := Vector2.ZERO
var _touch_clock := 0.0
var _note_players: Array[AudioStreamPlayer] = []

@onready var board: Node2D = %Board
@onready var host: Node2D = %Host
@onready var ambient: Node2D = %Ambient
@onready var fx: Node2D = %Fx
@onready var target_tile: Node2D = %TargetIcon
@onready var stats: Label = %Stats
@onready var status_label: Label = %Status
@onready var progress: ProgressBar = %Progress
@onready var overlay: Control = %Overlay
@onready var overlay_title: Label = %OverlayTitle
@onready var overlay_text: Label = %OverlayText
@onready var overlay_action: Button = %OverlayAction
@onready var card_buttons: Array = [%MemoryCard, %MelodyCard, %FocusCard]
@onready var level_buttons: Array = [%Level1, %Level2, %Level3]


func focus_goal() -> int:
	return [5, 8, 12][difficulty]


func melody_goal() -> int:
	return [4, 6, 8][difficulty]


func is_timed() -> bool:
	return mode == 2 or (mode == 0 and difficulty > 0)


func _ready() -> void:
	var config := ConfigFile.new()
	if config.load("user://cognitive_progress.cfg") == OK:
		best = config.get_value("progress", "best", {})
	_make_note_players()
	_set_icons()
	for index in 3:
		card_buttons[index].pressed.connect(func(): choose_game(index))
		level_buttons[index].pressed.connect(func(): choose_level(index))
	%Start.pressed.connect(start_session)
	%Pause.pressed.connect(toggle_pause)
	%Leave.pressed.connect(toggle_pause)
	%Stop.pressed.connect(func(): finish(false))
	%NextLevel.pressed.connect(func():
		difficulty = mini(2, difficulty + 1)
		start_session())
	%Motion.toggled.connect(func(value: bool):
		reduced_motion = value
		%Motion.text = "Motion: calm" if value else "Motion: full")
	for button in [%Mute, %Sound]:
		button.button_pressed = AudioServer.is_bus_mute(0)
		button.toggled.connect(_set_mute)
	_show_mute()
	# The 3D quality choice has no effect here.
	%Display.get_node("Quality").hide()
	var fullscreen: Button = %Display.get_node("Fullscreen")
	fullscreen.custom_minimum_size = Vector2(318, 90)
	fullscreen.theme_type_variation = &"BlueButton"
	fullscreen.add_theme_font_size_override("font_size", 25)
	%Home.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/launcher.tscn"))
	%Resources.pressed.connect(func(): OS.shell_open("https://www.nia.nih.gov/health/brain-health/cognitive-health-and-older-adults"))
	overlay_action.pressed.connect(func():
		if state == "paused": toggle_pause()
		else: start_session())
	%Back.pressed.connect(func():
		if state == "paused": finish(false)
		prepare())
	# The game library can open a specific game directly.
	if get_tree().has_meta("start_mode"):
		mode = clampi(int(get_tree().get_meta("start_mode")), 0, 2)
		get_tree().remove_meta("start_mode")
	prepare()


func _exit_tree() -> void:
	Art.release_all()


func _set_icons() -> void:
	%Home.icon = Art.ui_icon(ICON.home)
	%Leave.icon = Art.ui_icon(ICON.home)
	%Pause.icon = Art.ui_icon(ICON.pause)
	%ScoreIcon.texture = Art.ui_icon(ICON.star)
	%ClockIcon.texture = Art.ui_icon(ICON.clock)


func _set_mute(value: bool) -> void:
	AudioServer.set_bus_mute(0, value)
	_show_mute()


func _show_mute() -> void:
	var muted := AudioServer.is_bus_mute(0)
	for button in [%Mute, %Sound]:
		button.set_pressed_no_signal(muted)
		button.icon = Art.ui_icon(ICON.muted if muted else ICON.sound)


func choose_game(index: int) -> void:
	if state in ["playing", "paused"]: return
	mode = index
	prepare()


func choose_level(index: int) -> void:
	if state in ["playing", "paused"]: return
	difficulty = index
	prepare()


func prepare() -> void:
	difficulty = clampi(difficulty, 0, 2)
	completed_level = false
	state = "ready"
	overlay.hide()
	score = 0
	attempts = 0
	correct = 0
	elapsed = 0
	remaining = [90.0, 60.0, 45.0][difficulty]
	if mode == 0: remaining = [0.0, 180.0, 120.0][difficulty]
	stage = 1
	delay = 0.0
	phase = ""
	target = -1
	fx.clear()
	for index in 3:
		card_buttons[index].choose(index == mode)
		level_buttons[index].theme_type_variation = &"OrangeButton" if index == difficulty else &"BlueButton"
	%LevelDetails.text = _level_details()
	status_label.text = ""
	%Background.texture = Art.texture("%s/%s_1" % [Art.GAMES[mode].dir, Art.GAMES[mode].bg])
	# The sheets of this game load while the player reads the menu.
	Art.keep_only(Art.menu_sheets() + Art.game_sheets(mode, difficulty))
	make_board()
	update_hud()


func _level_details() -> String:
	match mode:
		0: return ["4 pairs  •  no time limit  •  long look", "6 pairs  •  180 seconds  •  shorter look", "8 pairs  •  120 seconds  •  brief look"][difficulty]
		1: return ["4-step melody  •  slow", "6-step melody  •  medium", "8-step melody  •  fast"][difficulty]
	return "%d objects to find  •  %d choices  •  %d seconds%s" % [focus_goal(), [6, 9, 12][difficulty],
		int(remaining), "  •  mistakes cost 3 s" if difficulty == 2 else ""]


func make_board() -> void:
	for child in board.get_children():
		board.remove_child(child)
		child.queue_free()
	buttons.clear()
	cards.clear()
	selected.clear()
	matched.clear()
	var count := 6
	var columns := 3
	if mode == 0:
		count = [8, 12, 16][difficulty]
		columns = 4
		for index in count: cards.append(floori(index / 2.0))
		cards.shuffle()
	elif mode == 2:
		count = [6, 9, 12][difficulty]
		columns = 3 if count < 12 else 4
	var rows := ceili(float(count) / columns)
	var area := MELODY_AREA if mode == 1 else BOARD_AREA
	var pitch := Vector2(area.size.x / columns, area.size.y / rows)
	var icons := _choose_memory_icons(floori(count / 2.0)) if mode == 0 else []
	for index in count:
		var tile := Tile.new()
		tile.kind = [Tile.Kind.FLOWER, Tile.Kind.MUSICIAN, Tile.Kind.DISC][mode]
		tile.level = difficulty
		tile.reduced_motion = reduced_motion
		tile.side = _tile_side(pitch, rows)
		tile.position = area.position + pitch * Vector2(index % columns + 0.5, floorf(float(index) / columns) + 0.5)
		if mode == 0: tile.set_icon(icons[cards[index]])
		elif mode == 1: tile.set_icon(index)
		board.add_child(tile)
		tile.appear(0.15 + 0.05 * index)
		buttons.append(tile)
	target_tile.reduced_motion = reduced_motion
	target_tile.hide()


func _tile_side(pitch: Vector2, rows: int) -> float:
	match mode:
		0: return 370.0 if rows == 2 else (324.0 if rows == 3 else 262.0)
		1: return 400.0
	return 350.0 if rows == 2 else minf(pitch.x, pitch.y) * 0.96


## Easy boards mix two kinds of object; harder ones use one kind, whose objects
## are more alike.
func _choose_memory_icons(pairs: int) -> Array:
	_pick_themes(2 if difficulty == 0 else 1)
	var icons := []
	for part in session_themes.size():
		var theme_cells := range(16)
		theme_cells.shuffle()
		for i in floori(float(pairs) / session_themes.size()):
			icons.append(session_themes[part] * 16 + theme_cells[i])
	return icons


## Never the same themes twice in a row.
func _pick_themes(count: int) -> void:
	var fresh := range(Art.PLAIN_THEMES).filter(func(item): return item not in _last_themes)
	fresh.shuffle()
	session_themes = fresh.slice(0, count)
	_last_themes = session_themes.duplicate()
	var needed := session_themes.duplicate()
	if mode == 2 and difficulty == 2: needed.append_array([Art.FIRST_LOOKALIKE, Art.FIRST_LOOKALIKE + 1])
	Art.request(Art.object_sheets(needed))


func _input(event: InputEvent) -> void:
	if TouchButtons.is_finger_down(event):
		var button := TouchButtons.button_at(self, event.position)
		if button == null: return
		get_viewport().set_input_as_handled()
		if not _is_same_touch(event.position): TouchButtons.press(button)


func _is_same_touch(point: Vector2) -> bool:
	var same := _touch_clock - _last_touch_time < SAME_TOUCH_TIME and point.distance_to(_last_touch_place) < SAME_TOUCH_DISTANCE
	if not same:
		_last_touch_time = _touch_clock
		_last_touch_place = point
	return same


func _unhandled_input(event: InputEvent) -> void:
	# A mouse click also arrives as a touch (emulate_touch_from_mouse).
	if state != "playing" or not (event is InputEventScreenTouch and event.pressed): return
	for index in buttons.size():
		if buttons[index].contains(event.position):
			get_viewport().set_input_as_handled()
			if _is_same_touch(event.position): return
			fx.ring(event.position)
			on_tile(index)
			return


func start_session() -> void:
	prepare()
	state = "playing"
	if auto_fullscreen and DisplayServer.get_name() != "headless" and get_viewport() == get_window():
		get_window().mode = Window.MODE_FULLSCREEN
	%ClickSound.play()
	var game: Dictionary = Art.GAMES[mode]
	%Background.texture = Art.texture("%s/%s_%d" % [game.dir, game.bg, difficulty + 1])
	for item in [host, ambient, fx, %ResultHost]: item.reduced_motion = reduced_motion
	ambient.setup(mode, difficulty)
	host.setup(game, HOST_SIZE[mode])
	host.position = HOST_PLACE[mode]
	_celebrations = 0
	if mode == 1:
		sequence.clear()
		next_sequence()
	elif mode == 2:
		_pick_themes(2)
		host.rest_with("search", 3.0)
		next_focus()
	else:
		status_label.text = "Find a pair"
		host.play_once("water")
	update_hud()


func toggle_pause() -> void:
	if state == "playing":
		state = "paused"
		overlay_title.text = "Take a breath"
		overlay_text.text = "Your game is waiting.\nContinue whenever you feel ready."
		overlay_action.text = "Continue"
		%ResultStars.hide()
		%ResultHost.setup(Art.GAMES[mode], _result_host_size())
		overlay.show()
	elif state == "paused":
		state = "playing"
		overlay.hide()
	update_hud()


func _result_host_size() -> float:
	return [660.0, 760.0, 660.0][mode]


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and state in ["playing", "paused"]:
		toggle_pause()
		get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and state == "playing": toggle_pause()


func _process(delta: float) -> void:
	_touch_clock += delta
	Art.poll()
	if state == "ready":
		for card in card_buttons:
			card.host.reduced_motion = reduced_motion
			card.advance(delta)
		return
	if state == "finished":
		%ResultHost.advance(delta)
		fx.advance(delta)
		return
	if state != "playing": return
	for tile in buttons: tile.advance_animation(delta)
	target_tile.advance_animation(delta)
	host.advance(delta)
	ambient.advance(delta)
	fx.advance(delta)
	elapsed += delta
	if is_timed():
		remaining = maxf(0, remaining - delta)
		if remaining <= 0:
			finish(false)
			return
	if delay > 0:
		delay -= delta
		if delay <= 0: advance_phase()
	update_hud()


func on_tile(index: int) -> void:
	if state != "playing" or phase != "": return
	match mode:
		0: _on_flower(index)
		1: _on_musician(index)
		2: _on_disc(index)
	update_hud()


func _on_flower(index: int) -> void:
	if index in matched or index in selected: return
	%ClickSound.play()
	selected.append(index)
	buttons[index].reveal(true)
	buttons[index].bounce()
	if selected.size() == 1:
		host.rest_with("think", 2.5)
		return
	attempts += 1
	if cards[selected[0]] == cards[selected[1]]:
		correct += 1
		score += 100
		%SuccessSound.play()
		matched.append_array(selected)
		for item in selected:
			buttons[item].mark_matched()
			fx.burst(buttons[item].global_position, Fx.PETALS if matched.size() % 4 else Fx.STARS)
		selected.clear()
		status_label.text = "Lovely match!"
		_celebrate("happy")
		if matched.size() == cards.size(): finish(true)
	else:
		status_label.text = "Try again. Remember these two."
		host.play_once("encourage")
		host.then_rest_with("", 0.0)
		phase = "hide_cards"
		delay = Tile.OPEN_TIME + LOOK_TIME[difficulty]


func _on_musician(index: int) -> void:
	attempts += 1
	_play_note(index)
	buttons[index].play_note(0.6)
	fx.note(buttons[index].global_position + Vector2(0, -190), index)
	if index == sequence[sequence_index]:
		correct += 1
		score += 25
		sequence_index += 1
		if sequence_index == sequence.size():
			score += 100
			%SuccessSound.play()
			if stage == melody_goal():
				finish(true)
				return
			stage += 1
			status_label.text = "Beautiful! One more step."
			host.play_once("happy")
			for tile in buttons: tile.be_happy(1.1)
			fx.burst(buttons[index].global_position + Vector2(0, -80), Fx.NOTES + Fx.STARS)
			phase = "next_sequence"
			delay = 1.5
	else:
		status_label.text = "Let's watch that once more."
		host.play_once("encourage")
		phase = "repeat_sequence"
		delay = [1.6, 1.4, 1.2][difficulty]


func _on_disc(index: int) -> void:
	attempts += 1
	if cards[index] == target:
		correct += 1
		score += 50
		%SuccessSound.play()
		status_label.text = "You found it!"
		buttons[index].highlight(true)
		fx.burst(buttons[index].global_position, Fx.LEAVES + Fx.STARS)
		_celebrate("found")
		if correct >= focus_goal():
			finish(true)
			return
		phase = "next_focus"
		delay = 0.6
	else:
		%ClickSound.play()
		status_label.text = "Not that one. Look once more."
		buttons[index].shake()
		host.play_once("encourage")
		host.then_rest_with("search", 2.0)
		if difficulty == 2: remaining = maxf(0, remaining - 3.0)


## Two different celebrations take turns.
func _celebrate(first: String) -> void:
	host.play_once(first if _celebrations % 2 == 0 else "dance")
	host.then_rest_with("search" if mode == 2 else "", 3.0)
	_celebrations += 1


func next_sequence() -> void:
	sequence.append(randi_range(0, 5))
	begin_playback()


func begin_playback() -> void:
	sequence_index = 0
	playback = 0
	status_label.text = "Watch and listen"
	host.loop("conduct")
	phase = "flash"
	delay = 0.8


func advance_phase() -> void:
	match phase:
		"hide_cards":
			for index in selected: buttons[index].reveal(false)
			selected.clear()
			status_label.text = "Find a pair"
			phase = ""
		"next_sequence": next_sequence()
		"repeat_sequence": begin_playback()
		"flash":
			var length: float = [0.85, 0.65, 0.45][difficulty]
			var index: int = sequence[playback]
			buttons[index].highlight(true, minf(0.6, length))
			_play_note(index)
			fx.note(buttons[index].global_position + Vector2(0, -190), index)
			phase = "unflash"
			delay = length
		"unflash":
			buttons[sequence[playback]].highlight(false)
			playback += 1
			if playback == sequence.size():
				phase = ""
				status_label.text = "Your turn"
				host.rest_with("listen", 5.0)
			else:
				phase = "flash"
				delay = 0.3
		"next_focus": next_focus()
	update_hud()


func next_focus() -> void:
	phase = ""
	var previous := target
	cards = _choose_focus_icons(buttons.size())
	target = cards[0]
	if target == previous:
		target = cards[1]
	cards.shuffle()
	for index in buttons.size():
		buttons[index].highlight(false)
		buttons[index].set_icon(cards[index])
		buttons[index].reveal(true, false)
		buttons[index].flip_in(0.025 * index)
	target_tile.set_icon(target)
	target_tile.flip_in(0.0)
	target_tile.show()
	status_label.text = "Find this object"


## Distinct icons. Level 3 uses groups of four look-alikes in two of three rounds.
func _choose_focus_icons(count: int) -> Array:
	var icons := []
	if difficulty == 2 and correct % 3 != 2:
		var sheet := Art.FIRST_LOOKALIKE + correct % 2
		var groups := range(4)
		groups.shuffle()
		for group in groups.slice(0, floori(count / 4.0)):
			for variant in 4: icons.append(sheet * 16 + group * 4 + variant)
	else:
		var themes := session_themes if difficulty == 0 else [session_themes[correct % 2]]
		for theme_id in themes:
			var theme_cells := range(16)
			theme_cells.shuffle()
			for i in floori(float(count) / themes.size()): icons.append(theme_id * 16 + theme_cells[i])
	icons.shuffle()
	return icons


func stars() -> int:
	if not completed_level: return 0
	if mode == 0:
		# Turning over flowers takes luck as well as memory, so this is generous.
		var tries := float(attempts) / maxi(1, correct)
		return 3 if tries <= 2.0 else (2 if tries <= 3.0 else 1)
	var accuracy := float(correct) / maxi(1, attempts)
	return 3 if accuracy >= 0.9 else (2 if accuracy >= 0.7 else 1)


func update_hud() -> void:
	%NextLevel.visible = state == "finished" and completed_level and difficulty < 2
	%Stop.visible = state == "paused"
	overlay_action.position.y = 700.0 if %NextLevel.visible else 596.0
	overlay_action.theme_type_variation = &"OrangeButton" if %NextLevel.visible else &""
	%LevelHUD.text = "Level %d of 3" % (difficulty + 1)
	stats.text = str(score)
	%Clock.text = "%d s" % (ceili(remaining) if is_timed() else int(elapsed))
	%Setup.visible = state == "ready"
	%HUD.visible = state != "ready"
	for item in [board, ambient]: item.visible = state != "ready"
	# The panel shows its own host.
	host.visible = state == "playing"
	target_tile.visible = mode == 2 and state != "ready"
	%Steps.visible = mode == 1 and state != "ready"
	if mode == 1:
		var watching := phase in ["flash", "unflash"]
		%Steps.show_steps(sequence.size(), playback + int(phase == "unflash") if watching else sequence_index)
	%PhaseIcon.texture = _phase_icon()
	match mode:
		0: progress.value = 100.0 * matched.size() / maxi(1, cards.size())
		1: progress.value = 100.0 if completed_level else 100.0 * (stage - 1) / melody_goal()
		2: progress.value = 100.0 * correct / focus_goal()
	%Pause.disabled = state != "playing"
	%Leave.disabled = state != "playing"
	for index in buttons.size():
		buttons[index].disabled = state != "playing" or phase != "" or index in matched


var _phase_icons := {}
func _phase_icon() -> Texture2D:
	var index: int = ICON.look if phase in ["flash", "unflash", "next_sequence", "repeat_sequence", "hide_cards"] else ICON.hand
	if index not in _phase_icons: _phase_icons[index] = Art.ui_icon(index)
	return _phase_icons[index]


func finish(completed: bool) -> void:
	if state not in ["playing", "paused"]: return
	state = "finished"
	completed_level = completed
	phase = ""
	var key := "%d_%d" % [mode, difficulty]
	best[key] = maxi(score, int(best.get(key, 0)))
	var saved := _save_best()
	overlay_title.text = "Level %d complete!" % (difficulty + 1) if completed else ("Time is up" if is_timed() and remaining <= 0 else "Well practised")
	overlay_text.text = "%d points  •  %d seconds\n%d right in %d tries\n%s" % [score, int(elapsed), correct, attempts,
		"Best score: %d" % best[key] if saved else "Your score could not be saved on this device."]
	overlay_action.text = "Play again"
	var earned := stars()
	%ResultStars.visible = completed
	for index in 3:
		%ResultStars.get_child(index).texture = Art.ui_icon(ICON.star if index < earned else ICON.no_star)
	%ResultHost.setup(Art.GAMES[mode], _result_host_size())
	if completed:
		%ResultHost.loop("cheer")
		fx.confetti()
	else:
		%ResultHost.rest_with("encourage", 4.0)
	overlay.show()
	update_hud()


func _save_best() -> bool:
	if not persist: return true
	var config := ConfigFile.new()
	config.set_value("progress", "best", best)
	return config.save("user://cognitive_progress.cfg") == OK


func _make_note_players() -> void:
	if _notes.is_empty():
		for hertz in NOTE_HERTZ: _notes.append(_pluck(hertz))
	for index in _notes.size():
		var player := AudioStreamPlayer.new()
		player.name = "Note%dSound" % index
		player.stream = _notes[index]
		player.volume_db = -5.0
		add_child(player)
		_note_players.append(player)


func _play_note(index: int) -> void:
	_note_players[index].play()


## A soft plucked tone.
func _pluck(hertz: float) -> AudioStreamWAV:
	const RATE := 22050
	var count := int(RATE * 0.9)
	var bytes := PackedByteArray()
	bytes.resize(count * 2)
	for i in count:
		var t := float(i) / RATE
		var wave := sin(TAU * hertz * t) + 0.35 * sin(TAU * hertz * 2.0 * t) * exp(-t * 6.0) + 0.12 * sin(TAU * hertz * 3.0 * t) * exp(-t * 9.0)
		var envelope := minf(1.0, t / 0.008) * exp(-t * 4.2) * minf(1.0, (0.9 - t) / 0.05)
		bytes.encode_s16(i * 2, int(wave * envelope * 18000.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = RATE
	stream.data = bytes
	return stream
