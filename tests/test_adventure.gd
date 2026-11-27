extends SceneTree
var game
func _initialize() -> void:
	call_deferred("run_tests")
func run_tests() -> void:
	game = load("res://games/adventure/scenes/adventure.tscn").instantiate()
	root.add_child(game)
	game.set_process(false)
	game.shell.auto_fullscreen = false
	# Headless tests run many actions in one frame; keep audio resources checked, but skip mixing.
	for sound in game.find_children("*Sound", "AudioStreamPlayer", true, false):
		assert(sound.stream != null)
		sound.stream = null
	assert(game.state == "ready")
	game.shell.begin()
	assert(game.state == "playing" and game.enemies.size() == 3 and game.crystals.size() == 3)
	assert(game.set_mouse_target(game.get_viewport().get_camera_3d().unproject_position(Vector3(11, 0, 0))))
	var position = game.player.position
	game.move_player(0.1)
	assert(game.player.position.x > position.x)
	game.reset_input()
	game.crystals[0].position = game.player.position
	game.check_collisions()
	assert(game.collected == 1 and game.score == 100)
	game.enemies[0].position = game.player.position + Vector3(1.25, 0, 0)
	var count = game.enemies.size()
	game.get_node("%Pulse").pressed.emit()
	assert(game.enemies.size() < count and game.cooldown == 3)
	var score = game.score
	game.send_pulse()
	assert(game.score == score)
	game.shell.pause()
	var time = game.remaining
	position = game.player.position
	var enemy_position = game.enemies[0].position
	game._process(5)
	assert(game.remaining == time and game.player.position == position and game.enemies[0].position == enemy_position)
	game.shell.resume()
	assert(game.state == "playing")
	game.invincible = 0
	game.enemies[0].position = game.player.position
	game.check_collisions()
	assert(game.hearts == 2)
	game.check_collisions()
	assert(game.hearts == 2)
	game.hearts = 1
	game.invincible = 0
	game.check_collisions()
	assert(game.defeat_delay > 0)
	game._process(1.01)
	assert(game.state == "finished")
	game.shell.begin()
	assert(game.state == "playing" and game.score == 0 and game.hearts == 3)
	for index in range(10):
		game.crystals[0].position = game.player.position
		game.check_collisions()
	assert(game.win_delay > 0 and game.collected == 10)
	game._process(1.0)
	assert(game.state == "finished" and game.collected == 10)
	# Level 3 has the heavier drone traffic; running out of time ends without stars.
	game.shell.choose_level(2)
	game.shell.begin()
	assert(game.level == 2 and game.enemies.size() == 5)
	game.clear_actors()
	game.remaining = 0.01
	game._process(0.02)
	assert(game.state == "finished" and not game.completed_level and game.shell.state == "results")
	# Leaving from the pause screen returns to the start screen.
	game.shell.begin()
	game.shell._notification(Control.NOTIFICATION_APPLICATION_FOCUS_OUT)
	assert(game.state == "paused" and game.shell.state == "paused")
	game.shell._pause_box.get_node("EndGame").pressed.emit()
	assert(game.state == "ready" and game.enemies.is_empty() and game.shell.state == "start")
	var config := ConfigFile.new()
	assert(config.load("user://adventure_progress.cfg") == OK)
	assert(config.get_value("progress", "best").has("0_0"))
	game.queue_free()
	await process_frame
	await process_frame
	print("PASS: Seed Quest via the shell: controls, movement, collection, pulse/cooldown, pause freeze, damage/invincibility, defeat, win, timeout, replay, focus pause and persistence")
	await create_timer(0.15).timeout
	quit()
