extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func contact(board, id: int, point: Vector2, down: bool) -> void:
	var event := InputEventScreenTouch.new()
	event.index = id
	event.position = board.get_global_transform_with_canvas()*point
	event.pressed = down
	board._input(event)
func run() -> void:
	change_scene_to_file("res://games/sensory/scenes/patterns.tscn")
	await process_frame
	await process_frame
	var game = current_scene
	var board = game.get_node("%Board")
	assert(board.live_contacts and game.round_count()==5)
	for shape in 5:
		var points: Array[Vector2] = []
		for p in board.targets: points.append((p-Vector2(1200,285))*0.65+Vector2(1200,285))
		# Different contact arrival order must not affect recognition.
		for i in range(points.size()-1,-1,-1): contact(board,i,points[i],true)
		board._process(0.3)
		assert(not game.solved)
		contact(board,0,points[0],false)
		board._process(0.4)
		assert(not game.solved and board.drawn.size()==points.size()-1)
		contact(board,0,points[0],true)
		contact(board,9,Vector2(1600,400),true)
		board._process(1.0)
		assert(not game.solved)
		contact(board,9,Vector2(1600,400),false)
		game.set_paused(true)
		assert(board.touches.is_empty())
		game.set_paused(false)
		for i in points.size(): contact(board,i,points[i],true)
		board._process(0.7)
		assert(game.solved and game.score==(shape+1)*100)
		board._process(1.0)
		assert(game.score==(shape+1)*100)
		if shape==1 and DisplayServer.get_name()!="headless":
			await RenderingServer.frame_post_draw
			get_root().get_texture().get_image().save_png("res://.test-data/live_contacts.png")
		game.next_round()
	assert(game.finished)
	game.start_game(0)
	for i in 3: contact(board,i,Vector2(900+i*180,300),true)
	board._process(1.0)
	assert(not game.solved and game.score==0)
	assert(game.get_node("%Feedback").text.begins_with("Not a match"))
	print("PASS: live touch ordering, all five shapes, release, extra contact, pause, hold duration, wrong shape and one-time scoring")
	quit()
