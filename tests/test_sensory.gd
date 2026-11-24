extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func settle() -> void:
	await process_frame
	await process_frame
func capture(file: String) -> void:
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_root().get_texture().get_image().save_png("res://.test-data/"+file+".png")
func run() -> void:
	change_scene_to_file("res://games/sensory/scenes/patterns.tscn")
	await settle()
	var game = current_scene
	assert(game.game == 0)
	assert(not game.has_node("%Sounds"))
	assert(not game.get_node("%Difficulty").visible)
	var board = game.get_node("%Board")
	game.get_node("%Mode").select(0)
	game.new_round()
	var seen: Array[int] = []
	game.pattern_bag.clear()
	var shapes: Array[String] = []
	for pattern in game.patterns:
		assert(pattern.points.size() >= 3 and pattern.points.size() <= 10)
		assert(not shapes.has(str(pattern.points)))
		shapes.append(str(pattern.points))
		for i in pattern.points.size():
			assert(Rect2(630,0,1170,600).has_point(pattern.points[i]))
			for j in range(i+1,pattern.points.size()):
				assert(pattern.points[i].distance_to(pattern.points[j]) > 96)
	for i in 28:
		game.draw_pattern()
		assert(not seen.has(game.current_pattern))
		seen.append(game.current_pattern)
	game.draw_pattern()
	assert(game.current_pattern != seen.back())
	var remaining: Array = game.pattern_bag.duplicate()
	var config := ConfigFile.new()
	assert(config.load("user://sensory_progress.cfg") == OK)
	assert(config.get_value("patterns","remaining") == remaining)
	game.current_pattern = 9 # House screenshot and matching checks.
	game.new_round()
	board.tap(Vector2.ZERO)
	assert(game.score == 0)
	for p in board.targets: board.tap(p)
	assert(game.score == 100)
	game.reward()
	assert(game.score == 100)
	game.next_round()
	assert(board.selected.is_empty())
	game.get_node("%Mode").select(1)
	game.new_round()
	for i in board.targets.size(): board.touches[i] = board.targets[i]
	board._process(0.7)
	assert(game.score == 200)
	game.next_round()
	for i in board.targets.size(): board.touches[i] = board.targets[0]
	board._process(1.0)
	assert(game.score == 200)
	game.set_paused(true)
	assert(board.touches.is_empty())
	assert(not board.enabled)
	game.start_game(0)
	game.current_pattern = 9
	game.new_round()
	var touch := InputEventScreenTouch.new()
	touch.index = 7
	touch.pressed = true
	touch.position = board.get_global_transform_with_canvas() * board.targets[0]
	board._input(touch)
	assert(board.occupied().size() == 1)
	touch.pressed = false
	board._input(touch)
	assert(board.touches.is_empty())
	await settle()
	await capture("patterns_expanded")
	# Blank canvas copies retain points and compare proportions, not screen positions.
	game.get_node("%Mode").select(2)
	game.new_round()
	assert(board.free_copy and board.drawn.is_empty())
	await settle()
	await capture("blank_pattern_start")
	var matcher = load("res://games/sensory/scripts/pattern_matcher.gd")
	var copied: Array[Vector2] = []
	for p in board.targets: copied.append((p-Vector2(870,85))*0.65+Vector2(1000,170))
	assert(matcher.matches(board.targets,copied,true))
	var reversed := copied.duplicate()
	reversed.reverse()
	assert(matcher.matches(board.targets,reversed,true))
	var wrong := copied.duplicate()
	wrong[2] += Vector2(200,150)
	assert(not matcher.matches(board.targets,wrong,true))
	var tiny: Array[Vector2] = [Vector2(1,1),Vector2(2,2),Vector2(3,3)]
	assert(not matcher.matches(board.targets,tiny,true))
	board.tap(Vector2(100,100))
	assert(board.drawn.is_empty())
	board.tap(copied[0])
	board.tap(copied[0])
	assert(board.drawn.size()==1)
	assert(not board.check_drawing())
	board.undo()
	assert(board.drawn.is_empty())
	for p in wrong: board.tap(p)
	game.get_node("%Check").pressed.emit()
	assert(game.score == 0 and not game.solved)
	assert(game.get_node("%Feedback").text.begins_with("Not a match"))
	game.new_round()
	# Touch-generated dots survive release, and dragging changes the held vertex.
	touch.pressed = true
	touch.position = board.get_global_transform_with_canvas()*copied[0]
	board._input(touch)
	var drag := InputEventScreenDrag.new()
	drag.index = touch.index
	drag.position = touch.position+Vector2(5,0)
	board._input(drag)
	assert(board.drawn.size()==1 and board.drawn[0] != copied[0])
	touch.pressed = false
	board._input(touch)
	assert(board.drawn.size()==1 and board.touch_vertices.is_empty())
	game.set_paused(true)
	board.undo()
	assert(board.drawn.size()==1)
	game.set_paused(false)
	game.new_round()
	for p in copied: board.tap(p)
	assert(board.check_drawing())
	assert(game.score==100)
	board.check_drawing()
	assert(game.score==100)
	await settle()
	await capture("blank_pattern_correct")
	# Each of the three sound levels must have distinct correct choices and finish.
	change_scene_to_file("res://games/sensory/scenes/sounds.tscn")
	await settle()
	game = current_scene
	assert(game.game == 1)
	assert(not game.get_node("%Mode").visible)
	assert(game.get_node("%Difficulty").visible)
	for level in 3:
		game.get_node("%Difficulty").select(level)
		game.get_node("%Difficulty").item_selected.emit(level)
		assert(game.difficulty == level and game.score == 0)
		assert(game.round_count() == [4,6,9][level])
		var heard_answers: Array[int] = []
		for round_number in game.round_count():
			assert(not heard_answers.has(game.answer))
			heard_answers.append(game.answer)
			var options: Array[int] = []
			for button in game.get_node("%Choices").get_children():
				if button.visible: options.append(button.get_meta("item"))
			assert(options.size() == level+2)
			assert(options.count(game.answer) == 1)
			var unique: Array[int] = []
			for id in options:
				assert(not unique.has(id))
				unique.append(id)
			if level == 2:
				var similar := false
				for id in options:
					if id != game.answer and game.ITEMS[id].category == game.ITEMS[game.answer].category: similar = true
				assert(similar)
			var before: int = game.score
			game.choose(game.answer)
			assert(game.score == before)
			game.play_sound()
			game.choose((game.answer+1)%9)
			assert(game.score == before)
			game.choose(game.answer)
			assert(game.score == before+100)
			game.choose(game.answer)
			assert(game.score == before+100)
			game.next_round()
		assert(game.finished)
		assert(game.score == [400,600,900][level])
		assert(game.sound_best[level] >= game.score)
		if level < 2:
			assert(not game.get_node("%Next").disabled)
			game.next_round()
			assert(game.difficulty == level+1 and game.score == 0 and not game.finished)
			game.difficulty = level
			game.get_node("%Difficulty").select(level)
		game.start_game(1)
		if level == 2:
			game.answer = 4 # Seven-second rain recording.
			game.play_sound()
			game.get_node("%Audio").seek(3.2)
			game._process(0.1)
			assert(not game.get_node("%Audio").playing)
		await settle()
		await capture("sounds_level_"+str(level+1))
	for item in game.ITEMS:
		var audio = load("res://assets/audio/sensory/"+item.audio+".ogg")
		assert(audio.get_length() > 0)
	change_scene_to_file("res://scenes/ui/launcher.tscn")
	await settle()
	await capture("separate_games_library")
	for route in ["Patterns","Sounds"]:
		current_scene.transition = 0.0
		current_scene.get_node("%"+route).pressed.emit()
		await settle()
		assert(current_scene.game == (0 if route == "Patterns" else 1))
		current_scene.get_node("%Home").pressed.emit()
		await settle()
		assert(current_scene.has_node("%"+route))
	print("PASS: 28 unique separated patterns, saved shuffle bag, touch matching, independent routes, all sound levels, unique choices, similar distractors, scoring, persistence and audio")
	quit()
