extends Control
## Game library: one picture card per game, in four skill columns.
## Games that live inside a shared scene (Cognitive Garden, Adventure) are
## opened on the right sub-game via the "start_mode" tree meta.
const TouchButtons = preload("res://scripts/shared/touch_buttons.gd")

const COGNITIVE := "res://games/cognitive/scenes/cognitive_hub.tscn"
const ADVENTURE := "res://games/adventure/scenes/adventure.tscn"
const ICON := {sound = 4, muted = 5}

## Seconds until a chosen game opens. Tests set 0.
@export var transition := 0.4
var _leaving := false


func _ready() -> void:
	# Attention
	_route(%FocusFinder, COGNITIVE, 2)
	_route(%DosaMaster, "res://games/dosa/scenes/dosa_game.tscn")
	_route(%ButterflyGarden, "res://games/butterfly_garden/scenes/garden.tscn")
	# Memory
	_route(%Garden, COGNITIVE, 0)          # Memory Meadow
	_route(%MelodySteps, COGNITIVE, 1)
	# Perception
	_route(%Sounds, "res://games/sensory/scenes/sounds.tscn")
	_route(%Patterns, "res://games/sensory/scenes/patterns.tscn")
	_route(%ShapeMatch, "res://games/pegboard/scenes/peg_match.tscn")
	# Planning & movement
	_route(%Ocean, "res://games/ocean_rescue/scenes/ocean_rescue.tscn")
	_route(%Adventure, ADVENTURE, 0)       # Seed Quest
	_route(%SentinelDash, ADVENTURE, 1)
	# For therapists
	_route(%PegTest, "res://games/pegboard/scenes/peg_test.tscn")

	%More.pressed.connect(func(): _show_panel(%MorePanel))
	%CloseMore.pressed.connect(func(): %MorePanel.hide())
	%Credits.pressed.connect(func():
		%MorePanel.hide()
		_show_panel(%CreditsPanel))
	%CloseCredits.pressed.connect(func(): %CreditsPanel.hide())
	%Fullscreen.pressed.connect(_toggle_fullscreen)
	%Mute.button_pressed = AudioServer.is_bus_mute(0)
	%Mute.toggled.connect(func(value: bool):
		AudioServer.set_bus_mute(0, value)
		_show_mute())
	_show_mute()
	_enter()


func _route(button: Button, scene: String, mode := -1) -> void:
	button.pressed.connect(func(): _open(button, scene, mode))


func _open(button: Button, scene: String, mode: int) -> void:
	if _leaving: return
	_leaving = true
	if mode >= 0: get_tree().set_meta("start_mode", mode)
	if transition <= 0.0:
		get_tree().change_scene_to_file(scene)
		return
	%ClickSound.play()
	# A cream circle grows out of the chosen card.
	%Curtain.mouse_filter = MOUSE_FILTER_STOP
	%Curtain.centre = button.get_global_rect().get_center()
	var tween := create_tween()
	tween.tween_interval(transition * 0.3)
	tween.tween_property(%Curtain, "cover", 1.0, transition * 0.7).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): get_tree().change_scene_to_file(scene))


## The bar slides down, then the columns appear from left to right.
func _enter() -> void:
	var top: Control = %TopBar
	top.position.y = -140.0
	create_tween().tween_property(top, "position:y", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var columns := %Columns.get_children()
	for column in columns.size():
		var row := 0
		for item in columns[column].get_children():
			if item.has_method("appear"):
				item.appear(0.25 + column * 0.09 + row * 0.07)
				row += 1
			else:
				item.modulate.a = 0.0
				create_tween().tween_property(item, "modulate:a", 1.0, 0.35).set_delay(0.2 + column * 0.09)


func _show_panel(panel: Control) -> void:
	panel.show()
	var paper: Control = panel.get_node("Paper")
	paper.pivot_offset = paper.size * 0.5
	paper.scale = Vector2.ONE * 0.85
	panel.modulate.a = 0.0
	var tween := create_tween().set_parallel()
	tween.tween_property(paper, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 0.15)


func _show_mute() -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = preload("res://assets/images/cognitive/shared/ui_icons_4x4.png")
	var index: int = ICON.muted if AudioServer.is_bus_mute(0) else ICON.sound
	atlas.region = Rect2((index % 4) * 256, floorf(index / 4.0) * 256, 256, 256)
	%Mute.icon = atlas


func _toggle_fullscreen() -> void:
	var window := get_window()
	window.mode = Window.MODE_WINDOWED if window.mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F11:
			_toggle_fullscreen()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_ESCAPE:
			%MorePanel.hide()
			%CreditsPanel.hide()
	elif TouchButtons.is_finger_down(event):
		get_viewport().set_input_as_handled()
		if _leaving: return
		# An open panel keeps touches away from the cards behind it.
		var layer: Node = self
		for panel in [%MorePanel, %CreditsPanel]:
			if panel.visible: layer = panel
		var button := TouchButtons.button_at(layer, event.position)
		if button: TouchButtons.press(button)
