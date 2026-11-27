extends SceneTree
## Presentation and input of the 2D Memory Meadow, Melody Steps and Focus Finder.
const Art = preload("res://games/cognitive/scripts/cognitive_art.gd")
var game
func _initialize() -> void:
	call_deferred("run_tests")
func touch(at: Vector2) -> void:
	var event := InputEventScreenTouch.new()
	event.pressed = true
	event.position = at
	root.push_input(event, true)
func finish_animations() -> void:
	for i in 20:
		for tile in game.buttons: tile.advance_animation(0.1)
func run_tests() -> void:
	game = load("res://games/cognitive/scenes/cognitive_hub.tscn").instantiate()
	game.persist = false
	root.add_child(game)
	game.set_process(false)
	root.size = Vector2i(1920, 1080)
	for sound in game.find_children("*Sound", "AudioStreamPlayer", true, false): sound.stream = null
	await process_frame
	for mode in 3:
		for level in 3:
			for sheet in Art.game_sheets(mode, level):
				assert(ResourceLoader.exists(Art.path(sheet)), sheet)
	for theme in Art.THEMES:
		assert(ResourceLoader.exists(Art.path("objects/%s_4x4" % theme)))

	# Memory: every pair has its own object, tiles stay on screen and apart.
	for level in 3:
		game.mode = 0
		game.difficulty = level
		var themes_before: Array = game._last_themes.duplicate()
		game.start_session()
		for theme in game.session_themes: assert(theme not in themes_before, "Objects change every session")
		var ids := {}
		for tile in game.buttons:
			ids[tile.icon_id] = true
			assert(Rect2(480, 120, 1440, 960).encloses(Rect2(tile.position - Vector2.ONE * tile.side * 0.4, Vector2.ONE * tile.side * 0.8)))
		assert(ids.size() == game.buttons.size() / 2)
	finish_animations()

	# One finger opens one flower, even if the frame reports it twice.
	# (Sessions here start directly, so the shell is told play has begun.)
	game.shell._show("playing")
	game._process(1.0)
	var tile: Node2D = game.buttons[0]
	touch(tile.global_position)
	assert(game.selected == [0], "Touch the visible flower")
	touch(tile.global_position + Vector2(40, 0))
	assert(game.selected == [0] and game.attempts == 0)
	game._process(0.2)
	assert(tile.open > 0.0 and tile.open < 1.0)
	var before: float = tile.open
	game.toggle_pause()
	game._process(5)
	assert(tile.open == before, "Pause freezes the flower")
	game.toggle_pause()
	game._process(0.5)
	assert(tile.open == 1.0)
	var other := 1
	while game.cards[other] == game.cards[0]: other += 1
	game._process(0.3)
	touch(game.buttons[other].global_position)
	assert(game.phase == "hide_cards" and game.host.anim == "encourage")
	game._process(0.6)
	assert(game.buttons[other].open == 1.0 and game.phase == "hide_cards", "Time to look at the second object")
	game._process(2.0)
	assert(game.phase == "" and not tile.shown)
	game._process(0.5)
	assert(tile.open == 0.0)

	# A mouse click must count once: only its touch copy reaches the board.
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	click.position = tile.global_position
	root.push_input(click, true)
	assert(game.selected.is_empty())

	# Real fingers press the buttons.
	game.shell._show("playing")
	touch(game.shell._pause.get_global_rect().get_center())
	assert(game.state == "paused")
	game._process(1.0)
	touch(game.shell._pause_box.get_node("Continue").get_global_rect().get_center())
	assert(game.state == "playing")

	# Melody: the musician glows, the stars count and a double contact is one step.
	game.mode = 1
	game.difficulty = 0
	game.start_session()
	game.advance_phase()
	assert(game.buttons[game.sequence[0]].halo == 0.0 and game.buttons[game.sequence[0]]._halo_target == 1.0)
	assert(game.host.anim == "conduct")
	while game.phase != "": game.advance_phase()
	assert(game.host.anim == "listen")
	game.sequence = [2, 2]
	game._process(1.0)
	touch(game.buttons[2].global_position)
	touch(game.buttons[2].global_position + Vector2(50, 10))
	assert(game.sequence_index == 1 and game.attempts == 1)
	game._process(0.5)
	touch(game.buttons[2].global_position)
	assert(game.phase == "next_sequence" and game.host.anim == "happy")

	# Focus: one target, all choices different, a new target every round.
	for level in 3:
		game.mode = 2
		game.difficulty = level
		game.start_session()
		for step in game.focus_goal() - 1:
			assert(game.get_node("%TargetIcon").icon_id == game.target)
			assert(game.cards.count(game.target) == 1)
			var kinds := {}
			for card in game.cards: kinds[card] = true
			assert(kinds.size() == game.buttons.size())
			var last: int = game.target
			game.on_tile(game.cards.find(game.target))
			game.advance_phase()
			assert(game.target != last)

	# Reduced motion shows everything at once.
	game.reduced_motion = true
	game.mode = 0
	game.difficulty = 0
	game.start_session()
	game.on_tile(0)
	assert(game.buttons[0].open == 1.0 and game.buttons[0]._bounce == 1.0)
	game.finish(true)
	assert(game.fx._pieces.is_empty())
	var best_file := FileAccess.get_modified_time("user://cognitive_progress.cfg")
	game.start_session()
	game.finish(false)
	assert(FileAccess.get_modified_time("user://cognitive_progress.cfg") == best_file)
	game.queue_free()
	await process_frame
	print("PASS: sprite sheets, boards, touch filtering, finger buttons, pause freeze, hosts, targets and reduced motion")
	quit()
