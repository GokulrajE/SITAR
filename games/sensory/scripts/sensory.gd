extends Control
const ITEMS = [
	{"name":"Bird", "category":"Nature", "cell":0, "audio":"bird"},
	{"name":"Guitar", "category":"Music", "cell":3, "audio":"guitar"},
	{"name":"Telephone", "category":"Everyday life", "cell":6, "audio":"phone"},
	{"name":"Car", "category":"Vehicles", "cell":7, "audio":"car"},
 {"name":"Rain", "category":"Nature", "cell":1, "audio":"rain"},
 {"name":"Waves", "category":"Nature", "cell":2, "audio":"waves"},
 {"name":"Train", "category":"Vehicles", "cell":8, "audio":"train"},
 {"name":"Piano", "category":"Music", "cell":4, "audio":"piano"},
 {"name":"Bell", "category":"Everyday life", "cell":5, "audio":"bell"}
]
const PATTERNS = preload("res://games/sensory/scripts/pattern_catalog.gd")
const CONTACT_PATTERNS = [
	{"name":"Triangle", "cell":-1,"closed":true,"points":[Vector2(1000,390),Vector2(1200,110),Vector2(1400,390)]},
	{"name":"Square", "cell":-1,"closed":true,"points":[Vector2(1020,120),Vector2(1350,120),Vector2(1350,450),Vector2(1020,450)]},
	{"name":"Rectangle", "cell":-1,"closed":true,"points":[Vector2(950,170),Vector2(1450,170),Vector2(1450,410),Vector2(950,410)]},
	{"name":"Diamond", "cell":-1,"closed":true,"points":[Vector2(1200,85),Vector2(1430,285),Vector2(1200,485),Vector2(970,285)]},
	{"name":"Trapezoid", "cell":-1,"closed":true,"points":[Vector2(1080,130),Vector2(1320,130),Vector2(1450,440),Vector2(950,440)]}
]
const LEVELS = [
 {"name":"Easy", "choices":2, "rounds":4, "seconds":7.0, "pool":[0,1,2,3]},
 {"name":"Medium", "choices":3, "rounds":6, "seconds":7.0, "pool":[0,1,2,3,4,5,6,7,8]},
 {"name":"Hard", "choices":4, "rounds":9, "seconds":3.0, "pool":[0,1,2,3,4,5,6,7,8]}
]
@export_enum("Patterns", "Sounds") var game: int = 0
var difficulty := 0
var sound_best := [0,0,0]
var patterns: Array[Dictionary] = PATTERNS.all()
var pattern_bag: Array[int] = []
var last_pattern := -1
var current_pattern := -1
var settings := ConfigFile.new()
var session_patterns: Array[int] = []
var round_index := 0
var score := 0
var best := [0,0]
var solved := false
var paused := false
var finished := false
var answer := 0
var deck: Array[int] = []
var atlas: Texture2D
var celebration: Tween
var heard := false

func _ready() -> void:
	atlas = load("res://assets/images/sensory/atlas.png")
	# Local overrides keep the existing games' shared theme untouched.
	for node in find_children("*","Label",true,false):
		node.add_theme_color_override("font_color",Color("243e40"))
	for node in find_children("*","Button",true,false):
		style_button(node)
	%Mode.add_item("One dot at a time")
	%Mode.add_item("Hold all dots together")
	%Mode.add_item("Copy on blank canvas")
	%Mode.add_item("Live finger / piece")
	if game == 0: %Mode.select(3)
	%Mode.item_selected.connect(func(_i): start_game(0))
	for level in LEVELS: %Difficulty.add_item(level.name)
	%Difficulty.item_selected.connect(func(index):
		difficulty = index
		start_game(game))
	%Home.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/launcher.tscn"))
	%Pause.pressed.connect(func(): set_paused(not paused))
	%Stop.pressed.connect(finish)
	%Listen.pressed.connect(play_sound)
	%Next.pressed.connect(next_round)
	%Reset.pressed.connect(func():
		if finished: start_game(game)
		elif not paused and not solved: new_round())
	%Motion.toggled.connect(func(value):
		%Board.motion = value
		if not value and celebration: celebration.kill()
		%Feedback.modulate = Color.WHITE)
	%Volume.value_changed.connect(func(value): %Audio.volume_db = linear_to_db(value))
	%Audio.volume_db = linear_to_db(%Volume.value)
	%Audio.finished.connect(func(): %Listen.text = "Play again")
	%Board.matched.connect(reward)
	%Board.live_status.connect(func(message):
		if not solved and not paused and not finished: %Feedback.text = message)
	%Board.drawing_changed.connect(func():
		if %Board.free_copy and not solved:
			%Feedback.text = "%d / %d dots placed. Press Check pattern when ready." % [%Board.drawn.size(),%Board.targets.size()])
	%Check.pressed.connect(func():
		if paused or finished or solved: return
		if not %Board.check_drawing():
			%Feedback.text = "Not a match yet. Adjust your dots, Undo, or Clear and try again.")
	%Undo.pressed.connect(func(): %Board.undo())
	for i in 4:
		get_node("Choices/Choice"+str(i)).pressed.connect(func(): choose(int(get_node("Choices/Choice"+str(i)).get_meta("item"))))
	settings.load("user://sensory_progress.cfg")
	for i in 2: best[i] = int(settings.get_value("best",str(i),0))
	for i in 3: sound_best[i] = int(settings.get_value("sound_levels",str(i),0))
	last_pattern = int(settings.get_value("patterns","last",-1))
	var saved: Array = settings.get_value("patterns","remaining",[])
	for id in saved:
		if id is int and id >= 0 and id < patterns.size() and not pattern_bag.has(id): pattern_bag.append(id)
	start_game(game)

func sprite(cell: int) -> AtlasTexture:
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	var unit := atlas.get_size()/3.0
	tex.region = Rect2(Vector2(cell%3,cell/3)*unit,unit)
	return tex

func style_button(button: Button) -> void:
	button.add_theme_font_size_override("font_size",26)
	for state in ["normal","hover","pressed","disabled","focus"]:
		var box := StyleBoxFlat.new()
		box.bg_color = Color("236c67")
		if state == "hover": box.bg_color = Color("318179")
		if state == "pressed": box.bg_color = Color("194f4c")
		if state == "disabled": box.bg_color = Color("dce6e1")
		if state == "focus":
			box.bg_color = Color.TRANSPARENT
			box.set_border_width_all(4)
			box.border_color = Color("b56e29")
		box.set_corner_radius_all(22)
		box.content_margin_left = 22
		box.content_margin_right = 22
		button.add_theme_stylebox_override(state,box)
	button.add_theme_color_override("font_disabled_color",Color("5b706b"))

func start_game(which: int) -> void:
	game = which
	score = 0
	round_index = 0
	finished = false
	session_patterns.clear()
	deck.assign(LEVELS[difficulty].pool)
	deck.shuffle()
	if game == 0: draw_pattern()
	set_paused(false)
	new_round()

func new_round() -> void:
	%Audio.stop()
	if celebration and celebration.is_valid(): celebration.kill()
	%Feedback.modulate = Color.WHITE
	solved = false
	heard = false
	%Next.disabled = true
	%Board.visible = game == 0
	%Choices.visible = game == 1
	%Listen.visible = game == 1
	%Mode.visible = game == 0
	%Mode.disabled = paused or finished
	%Check.visible = game == 0 and %Mode.selected == 2
	%Undo.visible = %Check.visible
	%Difficulty.visible = game == 1
	%Volume.visible = game == 1
	%VolumeLabel.visible = game == 1
	%Session.text = "28 patterns • a fresh set of 8" if game == 0 else "%s • %d choices • %d rounds" % [LEVELS[difficulty].name,LEVELS[difficulty].choices,LEVELS[difficulty].rounds]
	%Feedback.text = "Take your time. Every try is welcome."
	%Reset.text = "Clear dots / Try again"
	if game == 0:
		var pattern: Dictionary = patterns[current_pattern]
		if %Mode.selected == 3:
			pattern = CONTACT_PATTERNS[round_index % CONTACT_PATTERNS.size()]
			%Session.text = "Live contacts • 5 shapes • hold to check"
		%Title.text = "Connect the picture • " + pattern.name
		%Board.configure(pattern.points,sprite(pattern.cell) if pattern.cell >= 0 else null,%Mode.selected == 1,pattern.closed,%Mode.selected == 2,%Mode.selected == 3)
		%Board.enabled = not paused
		%Cue.text = "Touch dots 1 to %d in order to copy the pattern." % pattern.points.size() if %Mode.selected == 0 else "Place %d fingers on the dots. Hold gently until they connect." % pattern.points.size()
		%Next.text = "Next picture"
		if %Mode.selected == 2:
			%Cue.text = "Copy the reference into the blank area. Touch to place dots; then press Check pattern."
			%Feedback.text = "You can lift each finger. Dots stay in place. Size and position can vary."
		if %Mode.selected == 3:
			%Cue.text = "Hold %d fingers in the blank area to copy the shape. It checks automatically." % pattern.points.size()
			%Feedback.text = "Match the orientation and proportions. Size and position can vary."
	else:
		answer = deck[round_index % deck.size()]
		%Title.text = "Listen & discover • " + LEVELS[difficulty].name
		%Cue.text = "Press Play sound. Then choose the picture you hear."
		%Listen.text = "Play sound"
		var options: Array[int] = [answer]
		var others: Array[int] = []
		others.assign(LEVELS[difficulty].pool)
		others.erase(answer)
		others.shuffle()
		# Hard prioritizes similar sources, e.g. guitar versus piano, rain versus waves.
		if difficulty == 2:
			var similar: Array[int] = []
			for id in others:
				if ITEMS[id].category == ITEMS[answer].category: similar.append(id)
			for id in similar: others.erase(id)
			similar.append_array(others)
			others = similar
		options.append_array(others.slice(0,int(LEVELS[difficulty].choices)-1))
		options.shuffle()
		for i in 4:
			var button: Button = get_node("Choices/Choice"+str(i))
			button.visible = i < options.size()
			if not button.visible: continue
			button.text = ITEMS[options[i]].name
			button.icon = sprite(ITEMS[options[i]].cell)
			button.set_meta("item",options[i])
			button.disabled = false
			var colors := [Color("e2eeea"),Color("f4e8d5"),Color("e5e8f3"),Color("f3e2df")]
			var box: StyleBoxFlat = button.get_theme_stylebox("normal").duplicate()
			box.bg_color = colors[i]
			button.add_theme_stylebox_override("normal",box)
			button.add_theme_color_override("font_color",Color("243e40"))
		%Next.text = "Next sound"
	update_score()

func play_sound() -> void:
	if paused or finished: return
	if %Volume.value == 0 or AudioServer.is_bus_mute(0):
		%Feedback.text = "Sound is muted. Raise Volume or unmute in the library."
		return
	var path: String = "res://assets/audio/sensory/"+ITEMS[answer].audio+".ogg"
	var stream := load(path) as AudioStream
	if not stream:
		%Feedback.text = "This sound could not be loaded. Please return to the library."
		return
	%Audio.stream = stream
	%Audio.play()
	heard = true
	%Listen.text = "Playing • tap to replay"
	%Feedback.text = "Listen, then choose. You can replay whenever you like."

func choose(item: int) -> void:
	if paused or solved or finished: return
	if not heard:
		%Feedback.text = "Press Play sound first, then choose a picture."
		return
	if item == answer:
		reward()
	else:
		%Feedback.text = "Let's listen once more. Try another picture."

func reward() -> void:
	if solved or paused or finished: return
	solved = true
	%Mode.disabled = true
	score += 100
	%Audio.stop()
	%Listen.text = "Play again"
	%Feedback.text = "Beautiful match! +100 points" if game == 0 else "That's right — %s! +100 points" % ITEMS[answer].name
	%Next.disabled = false
	if game == 1:
		for i in 4: get_node("Choices/Choice"+str(i)).disabled = true
	if %Motion.button_pressed:
		%Feedback.modulate.a = 0.3
		celebration = create_tween()
		celebration.tween_property(%Feedback,"modulate:a",1.0,0.6)
	if game == 0:
		best[0] = maxi(best[0],score)
		settings.set_value("best","0",best[0])
	else:
		sound_best[difficulty] = maxi(sound_best[difficulty],score)
		settings.set_value("sound_levels",str(difficulty),sound_best[difficulty])
	settings.save("user://sensory_progress.cfg")
	update_score()

func next_round() -> void:
	if finished and game == 1 and round_index >= round_count() and difficulty < 2:
		difficulty += 1
		%Difficulty.select(difficulty)
		start_game(1)
		return
	if not solved or paused or finished: return
	round_index += 1
	if round_index >= round_count(): finish()
	else:
		if game == 0: draw_pattern()
		new_round()

func round_count() -> int:
	if game == 0 and %Mode.selected == 3: return CONTACT_PATTERNS.size()
	return 8 if game == 0 else int(LEVELS[difficulty].rounds)

func draw_pattern() -> void:
	if pattern_bag.is_empty():
		pattern_bag.assign(range(patterns.size()))
		pattern_bag.shuffle()
		if pattern_bag.back() == last_pattern:
			var first: int = pattern_bag[0]
			pattern_bag[0] = pattern_bag[-1]
			pattern_bag[-1] = first
	var pick := pattern_bag.size()-1
	while pick > 0 and session_patterns.has(pattern_bag[pick]): pick -= 1
	current_pattern = pattern_bag[pick]
	pattern_bag.remove_at(pick)
	session_patterns.append(current_pattern)
	last_pattern = current_pattern
	settings.set_value("patterns","remaining",pattern_bag)
	settings.set_value("patterns","last",last_pattern)
	settings.save("user://sensory_progress.cfg")

func update_score() -> void:
	var high: int = best[0] if game == 0 else sound_best[difficulty]
	%Score.text = "Points %d • Best %d • Round %d / %d" % [score,high,mini(round_index+1,round_count()),round_count()]

func finish() -> void:
	finished = true
	%Audio.stop()
	%Board.enabled = false
	%Board.touches.clear()
	%Board.touch_vertices.clear()
	%Cover.show()
	%CoverText.text = "Well done. You earned %d points.\nPress Play again for a fresh session." % score
	%Next.disabled = true
	if game == 1 and round_index >= round_count() and difficulty < 2:
		%Next.disabled = false
		%Next.text = "Next level"
	%Pause.disabled = true
	%Mode.disabled = true
	%Reset.text = "Play again"

func set_paused(value: bool) -> void:
	paused = value
	%Pause.disabled = finished
	%Pause.text = "Resume" if paused else "Pause"
	%Cover.visible = paused or finished
	%CoverText.text = "Paused. Press Resume when ready."
	%Board.enabled = not paused and not finished
	%Board.touches.clear()
	%Board.touch_vertices.clear()
	%Board.hold = 0.0
	%Audio.stop()
	%Listen.text = "Play sound"
	%Mode.disabled = paused or finished
	%Difficulty.disabled = paused
	if celebration and celebration.is_valid():
		if paused: celebration.pause()
		else: celebration.play()

func _process(_delta: float) -> void:
	if %Audio.playing and %Audio.get_playback_position() >= float(LEVELS[difficulty].seconds):
		%Audio.stop()
		%Listen.text = "Play again"

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and is_node_ready() and not finished:
		set_paused(true)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not finished: set_paused(not paused)
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F11:
		get_window().mode = Window.MODE_WINDOWED if get_window().mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN

