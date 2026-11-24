extends SceneTree
## Renders the menu, every game at every level, pause and result to .test-data/.
## Add "-- 1080" to the command line for smaller pictures.
var viewport: SubViewport
var game
func _initialize() -> void:
	call_deferred("capture")
func snap(name: String) -> void:
	for frame in range(4): await process_frame
	await RenderingServer.frame_post_draw
	assert(viewport.get_texture().get_image().save_png("res://.test-data/cognitive_%s.png" % name) == OK)
func run_for(seconds: float) -> void:
	var left := seconds
	while left > 0.0 and game.state in ["playing", "finished", "ready"]:
		game._process(0.04)
		left -= 0.04
func capture() -> void:
	seed(7)
	viewport = SubViewport.new()
	viewport.size = Vector2i(1920, 1080) if "1080" in OS.get_cmdline_user_args() else Vector2i(3840, 2160)
	viewport.size_2d_override = Vector2i(1920, 1080)
	viewport.size_2d_override_stretch = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	game = load("res://games/cognitive/scenes/cognitive_hub.tscn").instantiate()
	viewport.add_child(game)
	game.set_process(false)
	game.auto_fullscreen = false
	game.persist = false
	for mode in range(3):
		game.finish(false)
		game.choose_game(mode)
		run_for(1.0)
		if mode == 0: await snap("menu")
		for level in range(3):
			game.difficulty = level
			game.start_session()
			run_for(1.5)
			match mode:
				0:
					game.on_tile(0)
					var pair = game.cards.find(game.cards[0], 1)
					game.on_tile(pair)
					run_for(0.3)
					await snap("meadow_%d_bloom" % (level + 1))
					run_for(0.8)
					var other := 1
					while other == pair: other += 1
					game.on_tile(other)
					run_for(0.8)
				1:
					game.begin_playback()
					run_for(1.05)
					await snap("melody_%d_note" % (level + 1))
					while game.phase != "": game.advance_phase()
					run_for(0.6)
				2:
					await snap("focus_%d_search" % (level + 1))
					game.on_tile(game.cards.find(game.target))
					run_for(0.35)
			await snap("%s_%d" % [["meadow", "melody", "focus"][mode], level + 1])
			if level == 0:
				game.toggle_pause()
				await snap("%s_pause" % ["meadow", "melody", "focus"][mode])
				game.toggle_pause()
				game.correct = 5
				game.attempts = 6
				game.finish(true)
				run_for(1.4)
				await snap("%s_result" % ["meadow", "melody", "focus"][mode])
	viewport.queue_free()
	await process_frame
	print("PASS: menu, three games at three levels, pause and results rendered")
	quit()
