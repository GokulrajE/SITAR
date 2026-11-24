extends SceneTree
func _initialize() -> void:
	call_deferred("capture")
func capture() -> void:
	change_scene_to_file("res://games/butterfly_garden/scenes/garden.tscn")
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://.test-data/butterfly-menu.png")
	current_scene._select_level(2)
	current_scene.start_game()
	await create_timer(0.3).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://.test-data/butterfly-game.png")
	var game = current_scene
	game._choose(game.actors.filter(func(a): return a.kind==game.target)[0])
	await create_timer(1.3).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://.test-data/butterfly-match.png")
	change_scene_to_file("res://scenes/ui/launcher.tscn")
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://.test-data/butterfly-library.png")
	quit()
