extends Control
## Game library in two simple steps: six skill rows, then the games of
## the chosen skill. Each game opens its own scene.
const TouchButtons = preload("res://scripts/shared/touch_buttons.gd")

const ICON := {sound = 4, muted = 5}
const GROUPS := ["Attention", "Memory", "Perception", "Movement", "Numbers", "Pegboard"]

## Seconds until a chosen game opens. Tests set 0.
@export var transition := 0.4
var _leaving := false
## The skill whose games were last shown, so Home from a game comes back to it.
static var _last_group := -1


func _ready() -> void:
	# Attention
	_route(%FocusFinder, "res://games/cognitive/scenes/focus_finder.tscn")
	_route(%DosaMaster, "res://games/dosa/scenes/dosa_game.tscn")
	# Memory
	_route(%MemoryMeadow, "res://games/cognitive/scenes/memory_meadow.tscn")
	_route(%MelodySteps, "res://games/cognitive/scenes/melody_steps.tscn")
	# Perception
	_route(%Sounds, "res://games/sensory/scenes/sounds.tscn")
	_route(%Patterns, "res://games/sensory/scenes/patterns.tscn")
	# Planning & movement
	_route(%Ocean, "res://games/ocean_rescue/scenes/ocean_rescue.tscn")
	_route(%SeedQuest, "res://games/adventure/scenes/adventure.tscn")
	# Numbers
	_route(%QuickSums, "res://games/numbers/scenes/quick_sums.tscn")
	_route(%MarketBasket, "res://games/numbers/scenes/market_basket.tscn")
	# Pegboard: the physical boards on the screen
	_route(%ShapeMatch, "res://games/pegboard/scenes/peg_match.tscn")
	_route(%ShapeSpots, "res://games/pegboard/scenes/shape_spots.tscn")
	_route(%HandShape, "res://games/pegboard/scenes/hand_and_shape.tscn")
	# For therapists
	_route(%PegTest, "res://games/pegboard/scenes/peg_test.tscn")

	for index in GROUPS.size():
		get_node("%" + GROUPS[index] + "Tile").pressed.connect(func(): show_group(index))
	%Back.pressed.connect(show_home)
	%BackArrow.pressed.connect(show_home)
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
	var top: Control = %TopBar
	top.position.y = -140.0
	create_tween().tween_property(top, "position:y", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if _last_group >= 0: show_group(_last_group)
	else: show_home()


## The skill rows.
func show_home() -> void:
	_last_group = -1
	%Shelf.hide()
	%Home.show()
	%BackArrow.hide()
	%Logo.show()
	%Title.text = "SITAR"
	var tiles := %Home.get_children().filter(func(item): return item is BaseButton)
	for index in tiles.size(): tiles[index].appear(0.1 + index * 0.08)


## Only the games of one skill, with a way back.
func show_group(index: int) -> void:
	_last_group = index
	%Home.hide()
	%Shelf.show()
	%BackArrow.show()
	%Logo.hide()
	%Title.text = "SITAR   ›   " + GROUPS[index].to_upper()
	%ShelfTitle.text = GROUPS[index].to_upper()
	for group in GROUPS.size():
		var shelf: Control = %Shelf.get_node(GROUPS[group])
		shelf.visible = group == index
		if group == index:
			var cards := shelf.get_children()
			for card in cards.size(): cards[card].appear(0.05 + card * 0.08)


func _route(button: Button, scene: String) -> void:
	button.pressed.connect(func(): _open(button, scene))


func _open(button: Button, scene: String) -> void:
	if _leaving: return
	_leaving = true
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
			if %MorePanel.visible or %CreditsPanel.visible:
				%MorePanel.hide()
				%CreditsPanel.hide()
			elif %Shelf.visible: show_home()
	elif TouchButtons.is_finger_down(event):
		get_viewport().set_input_as_handled()
		if _leaving: return
		# An open panel keeps touches away from the cards behind it.
		var layer: Node = self
		for panel in [%MorePanel, %CreditsPanel]:
			if panel.visible: layer = panel
		var button := TouchButtons.button_at(layer, event.position)
		if button: TouchButtons.press(button)
