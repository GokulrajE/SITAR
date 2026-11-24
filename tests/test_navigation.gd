extends SceneTree
func _initialize() -> void:
	call_deferred("run_tests")
func settle() -> void:
	await process_frame
	await process_frame
	# Open games at once, without the launcher's closing animation.
	if "transition" in current_scene: current_scene.transition = 0.0
func touch(at: Vector2) -> void:
	var event := InputEventScreenTouch.new()
	event.pressed = true
	event.position = at
	root.push_input(event, true)
func run_tests() -> void:
	change_scene_to_file("res://scenes/ui/launcher.tscn")
	await settle()
	root.size = Vector2i(1920, 1080)
	# A finger opens the panel; the panel keeps touches from the cards behind it.
	touch(current_scene.get_node("%More").get_global_rect().get_center())
	assert(current_scene.get_node("%MorePanel").visible)
	touch(current_scene.get_node("%Ocean").get_global_rect().get_center())
	await settle()
	assert(current_scene.name == "GameLibrary")
	current_scene.get_node("%Credits").pressed.emit()
	assert(not current_scene.get_node("%MorePanel").visible)
	assert(current_scene.get_node("%CreditsPanel").visible)
	current_scene.get_node("%CloseCredits").pressed.emit()
	assert(not current_scene.get_node("%CreditsPanel").visible)
	# Cards stay inside the screen and do not overlap.
	var rects: Array[Rect2] = []
	for column in current_scene.get_node("%Columns").get_children():
		for card in column.get_children():
			if not card is BaseButton: continue
			var rect := Rect2(column.position + card.position, card.size)
			assert(Rect2(0, 112, 1920, 968).encloses(rect))
			for other in rects: assert(not rect.intersects(other))
			rects.append(rect)
	assert(rects.size() == 11)
	touch(current_scene.get_node("%Garden").get_global_rect().get_center())
	await settle()
	assert(current_scene.name == "CognitiveGarden")
	current_scene.get_node("%FocusCard").pressed.emit()
	assert(current_scene.mode == 2)
	current_scene.get_node("%Home").pressed.emit()
	await settle()
	current_scene.get_node("%Adventure").pressed.emit()
	await settle()
	assert(current_scene.name == "Adventure")
	current_scene.get_node("%Mode").item_selected.emit(1)
	assert(current_scene.mode == 1)
	current_scene.get_node("%Mute").button_pressed = true
	assert(AudioServer.is_bus_mute(0))
	current_scene.get_node("%Home").pressed.emit()
	await settle()
	assert(current_scene.get_node("%Mute").button_pressed)
	current_scene.get_node("%Ocean").pressed.emit()
	await settle()
	assert(current_scene.name == "OceanRescue")
	current_scene.get_node("%Home").pressed.emit()
	await settle()
	assert(current_scene.has_node("%Ocean"))
	# Skill cards open the right sub-game directly.
	for route in [["FocusFinder", "CognitiveGarden", 2], ["MelodySteps", "CognitiveGarden", 1],
			["Garden", "CognitiveGarden", 0], ["SentinelDash", "Adventure", 1], ["Adventure", "Adventure", 0]]:
		current_scene.get_node("%" + route[0]).pressed.emit()
		await settle()
		assert(current_scene.name == route[1])
		assert(current_scene.mode == route[2])
		current_scene.get_node("%Home").pressed.emit()
		await settle()
	current_scene.get_node("%ShapeMatch").pressed.emit()
	await settle()
	assert(current_scene.name == "PegMatch")
	change_scene_to_file("res://scenes/ui/launcher.tscn")
	await settle()
	assert(not get_root().get_tree().has_meta("start_mode"))
	print("PASS: launcher, credits, skill-card routes, direct sub-game links, game selectors and shared mute")
	quit()
