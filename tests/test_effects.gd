extends SceneTree
var game
func _initialize() -> void:
	call_deferred("run_tests")
func run_tests() -> void:
	game = load("res://games/adventure/scenes/adventure.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	for sound in game.find_children("*Sound", "AudioStreamPlayer", true, false):
		assert(sound.stream != null)
		sound.stream = null
	game.shell.auto_fullscreen = false
	game.shell.begin()
	assert(game.get_node("%HUD").visible and game.shell.state == "playing")
	assert(not game.has_node("Feedback") and not game.has_node("MissionCard"))
	var hud_labels := []
	for label in game.find_children("*", "Label", true, false):
		if label.is_visible_in_tree() and not game.shell.is_ancestor_of(label): hud_labels.append(String(label.name))
	hud_labels.sort()
	# Time and level now live in the shell's status pill.
	assert(hud_labels == ["Score", "ScoreCaption", "Status"])
	assert(game.ready_notifications == 1)
	game.crystals[0].position = game.player.position
	game.check_collisions()
	assert(game.score == 100 and game.get_node("%Score").text == "0100")
	var pickup = game.get_node("%Effects").get_child(1)
	assert(pickup.get_node("Points").text == "+100")
	game.advance_effects(0.25)
	assert(pickup.get_node("Points").position.y > 1.8)
	var before = pickup.get_node("AnimationPlayer").current_animation_position
	game.toggle_pause()
	game._process(1.0)
	await process_frame
	assert(pickup.get_node("AnimationPlayer").current_animation_position == before)
	game.toggle_pause()
	game.clear_actors()
	game.send_pulse()
	assert(game.get_node("%PulseAnimation").current_animation == "pulse_cooling")
	game._process(2.9)
	assert(game.ready_notifications == 1 and game.get_node("%Pulse").disabled)
	game._process(0.11)
	assert(game.ready_notifications == 2 and not game.get_node("%Pulse").disabled)
	assert(game.get_node("%PulseAnimation").current_animation == "pulse_ready")
	game._process(0.1)
	assert(game.ready_notifications == 2)
	await process_frame
	assert(not is_instance_valid(pickup))
	game.start_session()
	game.collected = 9
	game.crystals[0].position = game.player.position
	game.check_collisions()
	assert(game.win_delay > 0 and game.shell.state != "results")
	game._process(0.45)
	assert(game.state == "playing")
	game._process(0.5)
	assert(game.state == "finished" and game.shell.state == "results")
	game.start_session()
	assert(game.score == 0 and game.win_delay == 0 and game.ready_notifications == 1)
	game.queue_free()
	await process_frame
	print("PASS: minimal HUD, crystal score/effect, pause-safe animation, cooldown cue once, effect cleanup, final-pickup celebration and replay reset")
	quit()

