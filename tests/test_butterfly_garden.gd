extends SceneTree

func _initialize() -> void:
	call_deferred("run_tests")

func settle() -> void:
	await process_frame
	await process_frame

func run_tests() -> void:
	change_scene_to_file("res://scenes/ui/launcher.tscn")
	await settle()
	current_scene.transition = 0.0
	current_scene.get_node("%ButterflyGarden").pressed.emit()
	await settle()
	var game = current_scene
	assert(game.name=="ButterflyGarden")
	for level in range(3):
		game._select_level(level)
		game.start_game()
		assert(game.actors.size()==level+2)
		var wrong = game.actors.filter(func(a): return a.kind!=game.target)[0]
		game._choose(wrong)
		assert(game.score==0 and game.state=="playing")
		for round_index in range(game.goal):
			var correct = game.actors.filter(func(a): return a.kind==game.target)[0]
			var touch := InputEventScreenTouch.new()
			touch.pressed=true
			touch.device=0
			touch.position=correct.position
			game._input(touch)
			assert(game.state=="landing")
			game._choose(correct)
			assert(game.score==(round_index+1)*100)
			game._pause()
			var pos = correct.position
			game._process(0.5)
			assert(correct.position==pos)
			game._resume()
			game._process(1.2)
			assert(game.state=="matched")
			assert(correct.position==correct.flower)
			var old_target = game.target
			game._next()
			if round_index<game.goal-1: assert(game.target!=old_target)
		assert(game.state=="finished")
		assert(game.best[level]>=game.goal*100)
	game.reduced=true
	game.start_game()
	game._process(1.0)
	for actor in game.actors:
		assert(actor.position==actor.origin)
		assert(actor.sprite.speed_scale==0.0)
	assert(game.frames.get_frame_count("fly_0")==4)
	assert(game.flower_frames.get_frame_count("pollen")==4)
	game.get_node("%Home").pressed.emit()
	await settle()
	# Let the audio server retire playback created by accelerated rounds.
	await create_timer(0.5).timeout
	assert(current_scene.has_node("%ButterflyGarden"))
	print("PASS: Butterfly Garden routing, 3 levels, physical touch, retries, single scoring, landing, pause, completion, reduced motion and sprite sheets")
	quit()
