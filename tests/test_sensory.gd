extends SceneTree
## Listen & Discover, Connect & Draw, Quick Sums, Market Basket and Dosa Master
## through the shared shell: levels, right and wrong answers, auto-advance,
## pause freeze, results and stars.
func _initialize() -> void:
	call_deferred("run_tests")


func open(path: String) -> Node:
	var game: Node = load(path).instantiate()
	root.add_child(game)
	await process_frame
	game.shell.auto_fullscreen = false
	return game


func tap(at: Vector2) -> void:
	var event := InputEventScreenTouch.new()
	event.pressed = true
	event.position = at
	event.device = 0
	root.push_input(event, true)


func run_tests() -> void:
	root.size = Vector2i(1920, 1080)
	await sounds()
	await patterns()
	await numbers()
	await dosa()
	print("PASS: sounds (auto-play, gating, similar distractors, auto-advance), patterns (connect, copy, memory, retry), sums, market change, dosa orders, pause freeze and shell results")
	quit()


func sounds() -> void:
	var game = await open("res://games/sensory/scenes/sounds.tscn")
	game.audio.volume_db = -80
	for level in 3:
		game.shell.choose_level(level)
		game.shell.begin()
		assert(game.playing and game.level == level)
		for round_index in game.LEVELS[level].rounds:
			var shown := 0
			var right := -1
			var wrong := -1
			for index in 4:
				if not game._cards[index].visible: continue
				shown += 1
				if int(game._cards[index].get_meta("item")) == game.answer: right = index
				else: wrong = index
			assert(shown == game.LEVELS[level].choices and right >= 0)
			if level == 2:
				# Hard puts a sound of the same kind beside the answer.
				var kinds := []
				for index in shown: kinds.append(game.ITEMS[game._cards[index].get_meta("item")].category)
				assert(kinds.count(game.ITEMS[game.answer].category) >= 2)
			if round_index == 0:
				game.choose(wrong)
				assert(not game.solved and game.mistakes == 1)
			game.choose(right)
			assert(game.solved)
			# Paused: nothing moves on.
			game.shell.pause()
			game._process(5.0)
			assert(game.round_index == round_index)
			game.shell.resume()
			game._process(1.4)
		assert(not game.playing and game.shell.state == "results")
		assert(game.shell._stars[0].visible)
	game.queue_free()


func patterns() -> void:
	var game = await open("res://games/sensory/scenes/patterns.tscn")
	# Connect: wrong dot first, then the right order.
	game.shell.choose_level(0)
	game.shell.begin()
	for round_index in game.ROUNDS:
		assert(game.targets.size() <= game.MAX_POINTS[0])
		if round_index == 0 and game.targets.size() > 1:
			game._tap_dot(game.targets[1])
			assert(game.reached == 0 and game.mistakes == 1)
		for point in game.targets:
			game._last_touch = -1.0
			game._tap_dot(point)
		assert(game.solved)
		game._process(1.5)
	assert(game.shell.state == "results")
	# Copy: a shifted, larger copy counts; a wrong one clears itself.
	game.shell.choose_level(1)
	game.shell.begin()
	var wrong: Array[Vector2] = []
	for index in game.targets.size(): wrong.append(Vector2(800 + index * 120, 500))
	for point in wrong: game._place_dot(point)
	assert(not game.solved and game.mistakes == 1)
	game._process(1.0)
	assert(game.drawn.is_empty())
	var centre := Rect2(game.CANVAS).get_center()
	for point in game.targets: game._place_dot(centre + (point - centre) * 0.8 + Vector2(20, 10))
	assert(game.solved)
	# From memory: the guide hides after a look and taps wait for it.
	game.shell.choose_level(2)
	game.shell.begin()
	game._place_dot(game.targets[0])
	assert(game.drawn.is_empty())
	game._process(game.LOOK_TIME + 0.1)
	for point in game.targets: game._place_dot(point)
	assert(game.solved)
	game.queue_free()


func numbers() -> void:
	for scene in ["res://games/numbers/scenes/quick_sums.tscn", "res://games/numbers/scenes/market_basket.tscn"]:
		var game = await open(scene)
		for level in 3:
			game.shell.choose_level(level)
			game.shell.begin()
			for question in game.QUESTIONS:
				var values := []
				for button in game._buttons:
					if button.visible: values.append(int(button.get_meta("value")))
				assert(values.size() == (3 if level == 0 else 4) and game.answer in values)
				for value in values: assert(values.count(value) == 1)
				if game.game == 1 and level == 2:
					assert(game.paid > 0 and game.answer >= 0)
				var right := values.find(game.answer)
				if question == 0:
					game.choose((right + 1) % values.size())
					assert(not game.solved)
				game.choose(right)
				assert(game.solved)
				game._process(1.2)
			assert(game.shell.state == "results" and game.shell._stars[2].texture != null)
		game.queue_free()


func dosa() -> void:
	var game = await open("res://games/dosa/scenes/dosa_game.tscn")
	for player in [game._bgm, game._ambience]: player.volume_db = -80
	game.shell.choose_level(0)
	game.shell.begin()
	assert(game._state == game.GameState.PLAYING)
	var fake: Node2D = load("res://games/dosa/scenes/dosa.tscn").instantiate()
	root.add_child(fake)
	fake.set_process(false)
	game._on_picked(fake, "early", -1.0)
	assert(game._served == 0)
	for order in game.LEVELS[0].orders - 1: game._on_picked(fake, "perfect", 0.5)
	assert(game._served == game.LEVELS[0].orders - 1)
	game.shell.pause()
	var elapsed: float = game._elapsed
	game._process(3.0)
	assert(game._elapsed == elapsed and game._dosa_root.process_mode == Node.PROCESS_MODE_DISABLED)
	game.shell.resume()
	game._on_picked(fake, "late", 2.0)
	assert(game._state == game.GameState.OVER and game.shell.state == "results")
	game.shell.begin()
	game._elapsed = 1000.0
	game._process(0.1)
	assert(game.shell.state == "results" and not game.shell._stars[0].visible)
	fake.free()
	game.queue_free()
