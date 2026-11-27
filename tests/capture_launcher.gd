extends SceneTree
## Saves pictures of the launcher's home and one skill shelf to user://.
func _initialize() -> void:
	call_deferred("run")
func shot(name_: String) -> void:
	for i in 40: await process_frame
	var path := OS.get_user_data_dir() + "/" + name_ + ".png"
	root.get_texture().get_image().save_png(path)
	print("SAVED ", path)
func run() -> void:
	root.size = Vector2i(1920, 1080)
	change_scene_to_file("res://scenes/ui/launcher.tscn")
	await process_frame
	await shot("launcher_home")
	current_scene.show_group(0)
	await shot("launcher_attention")
	current_scene.show_group(1)
	await shot("launcher_memory")
	current_scene.get_node("%More").pressed.emit()
	await shot("launcher_settings")
	change_scene_to_file("res://games/cognitive/scenes/memory_meadow.tscn")
	await process_frame
	await shot("memory_meadow_setup")
	quit()
