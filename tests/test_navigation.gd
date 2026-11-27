extends SceneTree
## Launcher: six skill rows, one shelf per skill, every game opens its own scene
## with the shared shell, and Home returns to the same shelf.
const ROUTES := [
	["FocusFinder", "FocusFinder"], ["DosaMaster", "DosaGame"],
	["MemoryMeadow", "MemoryMeadow"], ["MelodySteps", "MelodySteps"],
	["Sounds", "SoundDiscovery"], ["Patterns", "PatternDrawing"],
	["Ocean", "OceanRescue"], ["SeedQuest", "Adventure"],
	["QuickSums", "QuickSums"], ["MarketBasket", "MarketBasket"],
	["ShapeMatch", "PegMatch"], ["ShapeSpots", "ShapeSpots"], ["HandShape", "HandAndShape"],
]


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


func find_shell(node: Node) -> Node:
	for child in node.get_children():
		if child.has_signal("start_pressed"): return child
		var found := find_shell(child)
		if found: return found
	return null


func run_tests() -> void:
	root.size = Vector2i(1920, 1080)
	change_scene_to_file("res://scenes/ui/launcher.tscn")
	await settle()
	var library := current_scene
	# A finger opens the settings panel; the panel keeps touches from the rows behind it.
	touch(library.get_node("%More").get_global_rect().get_center())
	assert(library.get_node("%MorePanel").visible)
	touch(Vector2(420, library.get_node("%MemoryTile").get_global_rect().get_center().y))   # on the row, beside the panel
	assert(library.get_node("%Home").visible)
	library.get_node("%Credits").pressed.emit()
	assert(library.get_node("%CreditsPanel").visible)
	library.get_node("%CloseCredits").pressed.emit()
	# Home shows only the skill rows; one tap shows that skill's games.
	assert(library.get_node("%Home").visible and not library.get_node("%Shelf").visible)
	touch(library.get_node("%MemoryTile").get_global_rect().get_center())
	assert(library.get_node("%Shelf").visible and not library.get_node("%Home").visible)
	assert(library.get_node("%MemoryMeadow").is_visible_in_tree())
	assert(not library.get_node("%Ocean").is_visible_in_tree())
	library.get_node("%Back").pressed.emit()
	assert(library.get_node("%Home").visible)
	# Cards of every skill stay inside the screen and do not overlap.
	var count := 0
	for group in library.GROUPS.size():
		library.show_group(group)
		var rects: Array[Rect2] = []
		for card in library.get_node("%Shelf").get_node(library.GROUPS[group]).get_children():
			var rect := Rect2(card.position, card.size)
			assert(Rect2(0, 112, 1920, 968).encloses(rect))
			for other in rects: assert(not rect.intersects(other))
			rects.append(rect)
			count += 1
	assert(count == ROUTES.size())
	# Every card opens its own game, which has the shell; Home comes back to the same skill.
	for route in ROUTES:
		var group := -1
		for index in library.GROUPS.size():
			if library.get_node("%Shelf").get_node(library.GROUPS[index]).has_node(route[0]): group = index
		library.show_group(group)
		library.get_node("%" + route[0]).pressed.emit()
		await settle()
		assert(current_scene.name == route[1])
		var shell := find_shell(current_scene)
		assert(shell != null and shell.state == "start")
		change_scene_to_file("res://scenes/ui/launcher.tscn")
		await settle()
		library = current_scene
		assert(library.get_node("%Shelf").visible)
		assert(library.get_node("%" + route[0]).is_visible_in_tree())
	# The shell's sound button is shared with the library.
	library.get_node("%Mute").button_pressed = true
	assert(AudioServer.is_bus_mute(0))
	library.get_node("%Mute").button_pressed = false
	print("PASS: launcher rows and shelves, credits, 14 games each with the shared shell, return to shelf, shared mute")
	quit()
