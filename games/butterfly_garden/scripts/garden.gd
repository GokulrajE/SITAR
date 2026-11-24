extends Control

const Actor = preload("res://games/butterfly_garden/scripts/butterfly_actor.gd")
const NAMES = ["Orange monarch", "Blue spotted", "Violet swallowtail", "Yellow scalloped"]
const MARKS = ["Black veins and\ndotted edges", "Round wings with\nivory spots", "Pointed tails and\npale stripes", "Scalloped wings with\nbrown crescents"]
var frames := SpriteFrames.new()
var flower_frames := SpriteFrames.new()
var level := 0
var target := -1
var score := 0
var round_number := 0
var goal := 5
var state := "menu"
var resume_state := "playing"
var elapsed := 0.0
var reduced := false
var best := [0, 0, 0]
var actors: Array = []
var flowers: Array = []
var pollen: AnimatedSprite2D

func atlas(texture: Texture2D, column: int, row: int, rows: int) -> AtlasTexture:
	var tile := AtlasTexture.new()
	tile.atlas = texture
	var cell := texture.get_size()/Vector2(4, rows)
	tile.region = Rect2(Vector2(column, row)*cell, cell)
	return tile

func _ready() -> void:
	var sheet = preload("res://assets/images/butterfly_garden/butterflies.png")
	for row in range(4):
		var animation = "fly_"+str(row)
		frames.add_animation(animation)
		frames.set_animation_speed(animation, 6)
		# Hand-painted frames need individual bounds: the first spread wing
		# extends beyond an equal-width grid cell. Transparent margins keep
		# every frame centred on a consistent 350 px canvas.
		for col in range(4):
			var tile := AtlasTexture.new()
			tile.atlas=sheet
			var widths = [345.0,285.0,140.0,314.0]
			tile.region=Rect2([0.0,350.0,720.0,940.0][col],row*313.5,widths[col],313.5)
			tile.margin=Rect2((350.0-widths[col])/2.0,0,350.0-widths[col],0)
			tile.filter_clip=true
			frames.add_frame(animation,tile)
	var floral = preload("res://assets/images/butterfly_garden/flowers.png")
	for row in range(2):
		var animation = "sway" if row==0 else "pollen"
		flower_frames.add_animation(animation)
		flower_frames.set_animation_speed(animation, 2 if row==0 else 5)
		flower_frames.set_animation_loop(animation, row==0)
		for col in range(4): flower_frames.add_frame(animation, atlas(floral,col,row,2))
	for x in [700, 1050, 1400, 1690]:
		var flower := AnimatedSprite2D.new()
		flower.sprite_frames = flower_frames
		flower.position = Vector2(x, 820)
		flower.scale = Vector2.ONE*0.36
		flower.play("sway")
		%Flowers.add_child(flower)
		flowers.append(flower)
	pollen = AnimatedSprite2D.new()
	pollen.sprite_frames = flower_frames
	pollen.scale = Vector2.ONE*0.45
	pollen.hide()
	%Flowers.add_child(pollen)
	pollen.animation_finished.connect(pollen.hide)
	_style()
	%Chime.stream = preload("res://assets/audio/confirmation_001.ogg")
	var config := ConfigFile.new()
	if config.load("user://butterfly_garden.cfg")==OK:
		reduced = config.get_value("settings","reduced_motion",false)
		for i in range(3): best[i] = int(config.get_value("best",str(i),0))
	%Reduced.button_pressed = reduced
	%Reduced.toggled.connect(func(value): reduced=value; _save())
	%Easy.pressed.connect(func(): _select_level(0))
	%Medium.pressed.connect(func(): _select_level(1))
	%Hard.pressed.connect(func(): _select_level(2))
	%Start.pressed.connect(start_game)
	%Continue.pressed.connect(_resume)
	%Next.pressed.connect(_next)
	%Pause.pressed.connect(_pause)
	%Finish.pressed.connect(_finish)
	%Home.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/launcher.tscn"))
	%Mute.pressed.connect(func(): AudioServer.set_bus_mute(0,not AudioServer.is_bus_mute(0)); _mute_text())
	_mute_text()
	%Continue.hide()
	%Next.disabled = true
	%Pause.disabled = true
	%Finish.disabled = true
	%Reference.texture = frames.get_frame_texture("fly_0",0)
	_select_level(0)

func _style() -> void:
	for panel in [%Header,%ReferencePanel,%Bottom,%Menu]:
		var box := StyleBoxFlat.new()
		box.bg_color = Color(0.98,0.98,0.92,0.96)
		box.set_corner_radius_all(24)
		panel.add_theme_stylebox_override("panel",box)
	for button in [%Home,%Pause,%Finish,%Mute,%Next,%Easy,%Medium,%Hard,%Start,%Continue,%Reduced]:
		button.add_theme_font_size_override("font_size",26)
		for key in ["normal","hover","pressed","disabled","focus"]:
			var box := StyleBoxFlat.new()
			box.bg_color = Color("27685d") if key!="disabled" else Color("667e72")
			box.set_corner_radius_all(14)
			if key=="hover" or key=="focus":
				box.set_border_width_all(4)
				box.border_color = Color("d4b85e")
			button.add_theme_stylebox_override(key,box)
		button.add_theme_color_override("font_color",Color.WHITE)
		button.add_theme_color_override("font_disabled_color",Color("e5e9de"))
	%Instruction.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func _select_level(value: int) -> void:
	level = value
	goal = [5,7,9][level]
	%Pace.text = ["Easy: 2 stationary choices", "Medium: 3 gently moving choices", "Hard: 4 gently moving choices"][level]+" · Best: "+str(best[level])+" points"
	for i in range(3): [%Easy,%Medium,%Hard][i].modulate = Color("f2d78b") if i==level else Color.WHITE

func start_game() -> void:
	score=0
	round_number=0
	target=-1
	%Menu.hide()
	%Shade.hide()
	%Pause.disabled=false
	%Finish.disabled=false
	for control in [%Easy,%Medium,%Hard]: control.disabled=false
	_new_round()

func _new_round() -> void:
	for actor in actors:
		%Actors.remove_child(actor)
		actor.queue_free()
	actors.clear()
	pollen.hide()
	var choices = [0,1,2,3]
	choices.erase(target)
	target = choices.pick_random()
	choices = [0,1,2,3]
	choices.erase(target)
	choices.shuffle()
	choices.resize(level+1)
	choices.append(target)
	choices.shuffle()
	var points = [Vector2(850,475),Vector2(1440,475)] if level==0 else ([Vector2(710,420),Vector2(1170,600),Vector2(1630,420)] if level==1 else [Vector2(740,365),Vector2(1420,365),Vector2(980,640),Vector2(1650,640)])
	for i in range(choices.size()):
		var actor = Actor.new()
		actor.setup(choices[i],frames,points[i],Vector2([700,1050,1400,1690][i],745))
		%Actors.add_child(actor)
		actor.chosen.connect(_choose)
		actors.append(actor)
	round_number+=1
	state="playing"
	%Reference.texture=frames.get_frame_texture("fly_"+str(target),0)
	%Species.text=NAMES[target]
	%Marking.text=MARKS[target]
	%Feedback.text="Find the matching butterfly. Take your time."
	%Score.text="Butterfly %d of %d  ·  %d points" % [round_number,goal,score]
	%Next.disabled=true
	%Next.text="Next butterfly" if round_number<goal else "See your garden"

func _choose(actor: Node2D) -> void:
	if state!="playing": return
	if actor.kind!=target:
		%Feedback.text="Look again at the wing shape and markings. You can try again."
		return
	score+=100
	%Chime.play()
	state="landing"
	%Feedback.text="A match! Your butterfly has found a flower."
	%Score.text="Butterfly %d of %d  ·  %d points" % [round_number,goal,score]
	for other in actors: other.button.disabled=true
	actor.settle_on_flower()

func _process(delta: float) -> void:
	var active = state=="playing" or state=="landing" or state=="matched"
	for flower in flowers: flower.speed_scale=1.0 if active and not reduced else 0.0
	pollen.speed_scale=1.0 if active and not reduced else 0.0
	if not active:
		for actor in actors: actor.sprite.speed_scale=0.0
		return
	elapsed+=delta
	for actor in actors:
		actor.step(delta,elapsed,level,reduced)
		if state=="landing" and actor.kind==target and actor.landed:
			state="matched"
			%Next.disabled=false
			%Next.grab_focus()
			if not reduced:
				pollen.position=actor.position
				pollen.show()
				pollen.play("pollen")

func _next() -> void:
	if state!="matched": return
	if round_number>=goal: _finish()
	else: _new_round()

func _pause() -> void:
	if state in ["playing","landing","matched"]:
		resume_state=state
		state="paused"
		%MenuTitle.text="Take a moment"
		%MenuText.text="Your garden will wait. Resume whenever you are ready."
		%Start.text="Restart garden"
		%Continue.show()
		%Menu.show()
		%Shade.show()
		for control in [%Easy,%Medium,%Hard]: control.disabled=true

func _resume() -> void:
	if state!="paused": return
	state=resume_state
	%Menu.hide()
	%Shade.hide()

func _finish() -> void:
	if state in ["menu","finished"]: return
	best[level]=maxi(best[level],score)
	_save()
	state="finished"
	%MenuTitle.text="Your garden is growing"
	%MenuText.text="%d butterflies found · %d points\nChoose a level to visit the garden again." % [score/100,score]
	%Start.text="Play again"
	%Continue.hide()
	%Menu.show()
	%Shade.show()
	%Pause.disabled=true
	%Finish.disabled=true
	%Next.disabled=true
	for control in [%Easy,%Medium,%Hard]: control.disabled=false
	_select_level(level)

func _save() -> void:
	var config := ConfigFile.new()
	config.set_value("settings","reduced_motion",reduced)
	for i in range(3): config.set_value("best",str(i),best[i])
	config.save("user://butterfly_garden.cfg")

func _mute_text() -> void:
	%Mute.text="Sound off" if AudioServer.is_bus_mute(0) else "Sound on"

func _notification(what: int) -> void:
	if what==NOTIFICATION_APPLICATION_FOCUS_OUT and is_node_ready(): _pause()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode==KEY_ESCAPE:
			if state=="paused": _resume()
			else: _pause()
		if event.keycode==KEY_F11:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if DisplayServer.window_get_mode()==DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_FULLSCREEN)
	if event is InputEventScreenTouch and event.pressed and event.device!=InputEvent.DEVICE_ID_EMULATION:
		var controls: Array=[%Home,%Mute]
		if %Menu.visible: controls.append_array([%Easy,%Medium,%Hard,%Reduced,%Start,%Continue])
		else:
			controls.append_array([%Pause,%Finish,%Next])
			if state=="playing":
				for actor in actors: controls.append(actor.button)
		for control in controls:
			if control.is_visible_in_tree() and not control.disabled and control.get_global_rect().has_point(event.position):
				if control is CheckButton: control.button_pressed=not control.button_pressed
				else: control.pressed.emit()
				get_viewport().set_input_as_handled()
				break
