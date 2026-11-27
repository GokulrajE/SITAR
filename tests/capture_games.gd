extends SceneTree
## Saves the start screen and a moment of play of each game to user://shots/.
## Pass scene names after --, e.g. -- quick_sums market_basket
## Example boards for the simulation only (the real games record them).
const BOARDS := {
	"A": [Vector2(-18.5, -19.5), Vector2(-2.5, 22.5), Vector2(15.0, -2.5)],
	"B": [Vector2(22.5, 20.0), Vector2(-30.0, -3.0), Vector2(16.5, -22.5)],
	"C": [Vector2(4.0, -30.0), Vector2(-14.5, 10.0), Vector2(13.5, 25.5)],
}
const SCENES := {
	quick_sums = "res://games/numbers/scenes/quick_sums.tscn",
	market_basket = "res://games/numbers/scenes/market_basket.tscn",
	patterns = "res://games/sensory/scenes/patterns.tscn",
	sounds = "res://games/sensory/scenes/sounds.tscn",
	dosa = "res://games/dosa/scenes/dosa_game.tscn",
	adventure = "res://games/adventure/scenes/adventure.tscn",
	ocean = "res://games/ocean_rescue/scenes/ocean_rescue.tscn",
	shape = "res://games/pegboard/scenes/peg_match.tscn",
	spots = "res://games/pegboard/scenes/shape_spots.tscn",
	hands = "res://games/pegboard/scenes/hand_and_shape.tscn",
	launcher = "res://scenes/ui/launcher.tscn",
	memory = "res://games/cognitive/scenes/memory_meadow.tscn",
	melody = "res://games/cognitive/scenes/melody_steps.tscn",
	focus = "res://games/cognitive/scenes/focus_finder.tscn",
}
func _initialize() -> void:
	call_deferred("run")
func shot(name_: String, frames := 50) -> void:
	for i in frames: await process_frame
	DirAccess.make_dir_recursive_absolute(OS.get_user_data_dir() + "/shots")
	var path := OS.get_user_data_dir() + "/shots/" + name_ + ".png"
	root.get_texture().get_image().save_png(path)
	print("SAVED ", path)
func find_shell(node: Node) -> Node:
	for child in node.get_children():
		if child.has_signal("start_pressed"): return child
		var found := find_shell(child)
		if found: return found
	return null
## Records example board legs for objects, in slot order A, B, C, as set-up would.
func record_boards(lib, objects: Array) -> void:
	lib.clear()
	var k := 1920.0 / 920.0
	for i in objects.size():
		var pts: Array[Vector2] = []
		for p: Vector2 in BOARDS[["A", "B", "C"][i]]:
			pts.append(Vector2(900, 500) + Vector2(p.x, -p.y) * k)
		var r: Dictionary = lib.record(objects[i], pts, 1.0 / k)
		assert(r.get("slot", "") == ["A", "B", "C"][i], str(r))

func run() -> void:
	root.size = Vector2i(1920, 1080)
	var names := OS.get_cmdline_user_args()
	if names.is_empty(): names = PackedStringArray(SCENES.keys())
	for key in names:
		change_scene_to_file(SCENES[key])
		await process_frame
		await shot(key + "_start")
		if "lib" in current_scene and current_scene.lib.objects().size() < 3:
			preload("res://games/pegboard/scripts/peg_library.gd").persist = false   # in memory only
			record_boards(current_scene.lib, ["cup", "cone", "cylinder"])
		var shell := find_shell(current_scene)
		if shell:
			shell.auto_fullscreen = false
			shell.choose_level(1)
			shell.begin()
			await shot(key + "_play", 150)
	quit()
