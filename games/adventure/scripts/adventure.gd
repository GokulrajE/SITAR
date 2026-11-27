extends Control
## Seed Quest: Nova collects golden seeds in a night garden while dodging drones.
## Level 3 brings the heavier drone traffic that used to be "Sentinel Dash".
## Session state, input, movement and collision rules. Menus come from the shared shell.
const Shell = preload("res://scripts/shared/game_shell.gd")
const ENEMY = preload("res://games/adventure/scenes/3d/enemy.tscn")
const COLLECT_EFFECT = preload("res://games/adventure/scenes/3d/collect_effect.tscn")
const READY_EFFECT = preload("res://games/adventure/scenes/3d/ready_effect.tscn")
const PULSE_EFFECT = preload("res://games/adventure/scenes/3d/pulse_burst.tscn")
var win_delay := 0.0
var defeat_delay := 0.0
var hit_time := 0.0
var ready_notifications := 0
const CRYSTAL = preload("res://games/adventure/scenes/3d/crystal.tscn")
const BOUNDS := Rect2(-13.2, -5.6, 26.4, 14.8)
const PLAYER_SPEED := 5.8
const PULSE_RADIUS := 3.0
var shell: Control
var level := 0
var completed_level := false
var enemy_serial := 0
func seed_goal() -> int:
	return [10, 14, 18][level]
var state := "ready"
var score := 0
var hearts := 3
var collected := 0
var elapsed := 0.0
var remaining := 60.0
var invincible := 0.0
var cooldown := 0.0
var pulse_time := 0.0
var spawn_time := 0.0
var enemies: Array[Node3D] = []
var crystals: Array[Node3D] = []
var move_target := Vector3.ZERO
var has_move_target := false
var best: Dictionary = {}
@onready var player: Node3D = %Player

func _ready() -> void:
	var config := ConfigFile.new()
	if config.load("user://adventure_progress.cfg") == OK:
		best = config.get_value("progress", "best", {})
	%Pulse.pressed.connect(send_pulse)
	shell = Shell.new()
	shell.title = "Seed Quest"
	shell.levels = ["Scout", "Ranger", "Sentinel"]
	shell.notes = ["10 seeds", "14 seeds", "18 seeds, more drones"]
	shell.accent = Color("5b4bc4")
	shell.dim = 0.3
	add_child(shell)
	shell.start_pressed.connect(func(chosen: int):
		level = chosen
		start_session())
	shell.pause_changed.connect(func(_paused: bool): toggle_pause())
	shell.stop_pressed.connect(func():
		state = "ready"
		prepare())
	prepare()

func clear_actors() -> void:
	for actor in %Actors.get_children():
		%Actors.remove_child(actor)
		actor.queue_free()
	enemies.clear()
	crystals.clear()

func prepare() -> void:
	level = clampi(level, 0, 2)
	completed_level = false
	enemy_serial = 0
	state = "ready"
	clear_actors()
	clear_effects()
	win_delay = 0.0
	defeat_delay = 0.0
	hit_time = 0.0
	reset_hit_feedback()
	ready_notifications = 0
	%ScoreAnimation.stop()
	%Score.scale = Vector2.ONE
	%Score.modulate = Color.WHITE
	%PulseAnimation.play("pulse_cooling")
	%PulseAnimation.advance(0)
	score = 0
	hearts = 3
	collected = 0
	elapsed = 0
	remaining = [75.0, 70.0, 65.0][level]
	invincible = 0
	cooldown = 0
	pulse_time = 0
	spawn_time = 2.5
	player.position = Vector3.ZERO
	player.rotation = Vector3.ZERO
	player.face(Vector3.ZERO)
	player.set_protected(false)
	%PulseRing.hide()
	reset_input()
	set_animation_active(false)
	update_hud()

func start_session() -> void:
	prepare()
	%NightThemes.begin_session()
	state = "playing"
	for index in range(3 + level): spawn_enemy()
	for index in range(3): spawn_crystal()
	set_animation_active(true)
	%ClickSound.play()
	notify_pulse_ready()
	update_hud()

func safe_position(from_player: float, others: Array = []) -> Vector3:
	for attempt in range(100):
		var point := Vector3(randf_range(-12.2, 12.2), 0, randf_range(-5.2, 8.2))
		if point.distance_to(player.position) < from_player: continue
		var available := true
		for other in others:
			if point.distance_to(other.position) < 1.5: available = false
		if available: return point
	return Vector3(-10, 0, -5) if player.position.x > 0 else Vector3(10, 0, 5)

func spawn_enemy() -> void:
	var enemy: Node3D = ENEMY.instantiate()
	enemy.position = safe_position(5.75, enemies)
	%Actors.add_child(enemy)
	enemy.set_meta("role", enemy_serial % 3)
	enemy.set_meta("attack", "hunt")
	enemy.set_meta("clock", 2.0 + (enemy_serial % 3) * 0.6)
	enemy.set_meta("previous_position", enemy.position)
	enemy_serial += 1
	enemies.append(enemy)

func spawn_crystal() -> void:
	var crystal: Node3D = CRYSTAL.instantiate()
	crystal.position = safe_position(1.8, crystals)
	%Actors.add_child(crystal)
	crystals.append(crystal)

func _process(delta: float) -> void:
	if state != "playing": return
	advance_effects(delta)
	hit_time = maxf(0, hit_time - delta)
	if defeat_delay > 0:
		defeat_delay = maxf(0, defeat_delay - delta)
		update_hud()
		if defeat_delay <= 0: finish("A brave adventure!")
		return
	if win_delay > 0:
		win_delay = maxf(0, win_delay - delta)
		if win_delay <= 0:
			completed_level = true
			finish("Level complete!")
		return
	elapsed += delta
	remaining = maxf(0, remaining - delta)
	invincible = maxf(0, invincible - delta)
	var previous_cooldown := cooldown
	cooldown = maxf(0, cooldown - delta)
	if previous_cooldown > 0 and cooldown <= 0: notify_pulse_ready()
	pulse_time = maxf(0, pulse_time - delta)
	%PulseRing.visible = false
	%PulseRing.position = player.position + Vector3(0, 0.12, 0)
	%PulseRing.scale = Vector3.ONE * (1.0 - pulse_time * 0.6)
	player.set_protected(invincible > 0)
	move_player(delta)
	move_enemies(delta)
	check_collisions()
	if state != "playing": return
	spawn_time -= delta
	if spawn_time <= 0:
		spawn_time = (4.0 if level < 2 else 2.5) - level * 0.55
		if enemies.size() < (5 if level < 2 else 7) + level * 2: spawn_enemy()
	if remaining <= 0: finish("Time is up")
	update_hud()

func ground_point(screen_position: Vector2) -> Variant:
	var camera := get_viewport().get_camera_3d()
	if camera == null: return null
	var point = Plane(Vector3.UP, 0.0).intersects_ray(
		camera.project_ray_origin(screen_position), camera.project_ray_normal(screen_position))
	if not get_viewport_rect().has_point(screen_position): return null
	if point == null or absf(point.x) > 15.0 or absf(point.z) > 13.0: return null
	return point

func set_mouse_target(screen_position: Vector2) -> bool:
	if state != "playing" or win_delay > 0 or defeat_delay > 0: return false
	var point = ground_point(screen_position)
	if point == null: return false
	move_target = Vector3(clampf(point.x, BOUNDS.position.x, BOUNDS.end.x),
		0, clampf(point.z, BOUNDS.position.y, BOUNDS.end.y))
	has_move_target = true
	%MoveMarker.position = move_target + Vector3(0, 0.1, 0)
	%MoveMarker.show()
	return true

func _unhandled_input(event: InputEvent) -> void:
	if state != "playing": return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and set_mouse_target(event.position):
			if event.double_click: send_pulse()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		if set_mouse_target(event.position): get_viewport().set_input_as_handled()
	elif event is InputEventScreenTouch and event.pressed:
		if set_mouse_target(event.position):
			if event.double_tap: send_pulse()
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag:
		if set_mouse_target(event.position): get_viewport().set_input_as_handled()

func move_player(delta: float) -> void:
	if state != "playing" or not has_move_target: return
	var direction := move_target - player.position
	player.position = player.position.move_toward(move_target, PLAYER_SPEED * delta)
	if player.position.distance_to(move_target) < 0.01:
		reset_input()
	else:
		player.face(direction.normalized())

func move_enemies(delta: float) -> void:
	for index in range(enemies.size()):
		var enemy := enemies[index]
		enemy.set_meta("previous_position", enemy.position)
		var role := int(enemy.get_meta("role", 0))
		var attack := str(enemy.get_meta("attack", "hunt"))
		var clock := float(enemy.get_meta("clock", 2.0)) - delta
		var aim := player.position
		if role == 1 and has_move_target:
			aim += (move_target - player.position).normalized() * (1.6 + level * 0.6)
		elif role == 2:
			aim += Vector3(sin(elapsed + index), 0, cos(elapsed + index)) * 2.0
		var direction: Vector3 = (aim - enemy.position).normalized()
		if attack == "windup":
			if clock <= 0:
				attack = "dash"
				clock = 0.65
				enemy.get_node("ChargeWarning").hide()
		elif attack == "dash":
			direction = enemy.get_meta("heading", Vector3.FORWARD)
			enemy.position += direction * (7.0 + level * 1.5) * minf(delta, maxf(0, clock + delta))
			if clock <= 0:
				attack = "recover"
				clock = 1.2
		elif attack == "recover":
			if clock <= 0:
				attack = "hunt"
				clock = 2.5 - level * 0.4
		else:
			enemy.position += direction * (2.0 + level * 0.45 + minf(elapsed, 90.0) * 0.008) * delta
			if role == 0 and clock <= 0 and enemy.position.distance_to(player.position) < 7.5:
				attack = "windup"
				clock = 0.95 - level * 0.15
				enemy.set_meta("heading", direction)
				enemy.rotation.y = atan2(direction.x, direction.z)
				enemy.get_node("ChargeWarning/Lane").scale.z = (7.0 + level * 1.5) * 0.65 / 6.5
				enemy.get_node("ChargeWarning").show()
		enemy.set_meta("attack", attack)
		enemy.set_meta("clock", clock)
		enemy.position.x = clampf(enemy.position.x, BOUNDS.position.x, BOUNDS.end.x)
		enemy.position.z = clampf(enemy.position.z, BOUNDS.position.y, BOUNDS.end.y)
		if attack == "hunt" or attack == "dash": enemy.face(direction)

func check_collisions() -> void:
	if state != "playing" or win_delay > 0 or defeat_delay > 0: return
	for crystal in crystals.duplicate():
		if crystal.position.distance_to(player.position) < 0.75:
			spawn_effect(COLLECT_EFFECT, crystal.position)
			crystals.erase(crystal)
			crystal.queue_free()
			collected += 1
			add_points(100)
			%CollectSound.play()
			if collected >= seed_goal():
				win_delay = 0.9
				reset_input()
				set_animation_active(false)
				return
			spawn_crystal()
	if invincible > 0: return
	for enemy in enemies:
		var previous: Vector3 = enemy.get_meta("previous_position", enemy.position)
		var nearest := Geometry3D.get_closest_point_to_segment(player.position, previous, enemy.position)
		if nearest.distance_to(player.position) < 0.8:
			hearts -= 1
			invincible = 1.8
			play_hit_feedback()
			%HurtSound.play()
			if hearts <= 0:
				defeat_delay = 1.0
				reset_input()
				set_animation_active(false)
			update_hud()
			break

func send_pulse() -> void:
	if state != "playing" or cooldown > 0 or win_delay > 0 or defeat_delay > 0: return
	cooldown = 3.0
	%NovaPulse.get_node("AnimationPlayer").stop()
	%NovaPulse.get_node("Status").modulate = Color.WHITE
	%PulseAnimation.play("pulse_cooling")
	%PulseAnimation.advance(0)
	pulse_time = 0.45
	for effect in %Effects.get_children():
		if effect.scene_file_path == READY_EFFECT.resource_path:
			%Effects.remove_child(effect)
			effect.queue_free()
	spawn_effect(PULSE_EFFECT, player.position)
	%PulseSound.play()
	var hits := 0
	for enemy in enemies.duplicate():
		if enemy.position.distance_to(player.position) <= PULSE_RADIUS:
			enemies.erase(enemy)
			enemy.queue_free()
			hits += 1
	add_points(hits * 50)
	update_hud()

func add_points(amount: int) -> void:
	if amount <= 0: return
	score += amount
	%Score.text = "%04d" % score
	%ScoreAnimation.stop()
	%ScoreAnimation.play("score_pop")
	%ScoreAnimation.advance(0)

func spawn_effect(scene: PackedScene, location: Vector3) -> void:
	var effect := scene.instantiate() as Node3D
	effect.position = location
	%Effects.add_child(effect)

func clear_effects() -> void:
	for effect in %Effects.get_children():
		%Effects.remove_child(effect)
		effect.queue_free()

func advance_effects(delta: float) -> void:
	for effect in %Effects.get_children():
		if not effect.is_queued_for_deletion(): effect.advance_effect(delta)
	player.get_node("HitAnimation").advance(delta)
	%DamageCue.get_node("AnimationPlayer").advance(delta)
	for heart in %Lives.get_children(): heart.get_node("AnimationPlayer").advance(delta)
	%ScoreAnimation.advance(delta)
	%PulseAnimation.advance(delta)
	%NovaPulse.get_node("AnimationPlayer").advance(delta)

func notify_pulse_ready() -> void:
	ready_notifications += 1
	%NovaPulse.get_node("AnimationPlayer").play("breathe")
	%NovaPulse.get_node("AnimationPlayer").advance(0)
	spawn_effect(READY_EFFECT, player.position)
	%ReadySound.play()
	%PulseAnimation.play("pulse_ready")
	%PulseAnimation.advance(0)

func reset_input() -> void:
	has_move_target = false
	move_target = player.position
	%MoveMarker.hide()
	player.face(Vector3.ZERO)

func set_animation_active(active: bool) -> void:
	player.set_animation_active(active)
	for actor in %Actors.get_children(): actor.set_animation_active(active)

func toggle_pause() -> void:
	if state == "playing":
		state = "paused"
		reset_input()
		set_animation_active(false)
	elif state == "paused":
		state = "playing"
		set_animation_active(true)
	update_hud()

func _input(event: InputEvent) -> void:
	if state != "playing": return
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_SPACE:
		send_pulse()
		get_viewport().set_input_as_handled()

func finish(message: String) -> void:
	if state not in ["playing", "paused"]: return
	state = "finished"
	reset_input()
	set_animation_active(false)
	var key := "0_%d" % level
	best[key] = maxi(score, int(best.get(key, 0)))
	var config := ConfigFile.new()
	config.set_value("progress", "best", best)
	config.save("user://adventure_progress.cfg")
	var stars := 0
	if completed_level: stars = 3 if hearts == 3 else (2 if hearts == 2 else 1)
	shell.finish(stars, message, "%d seeds  •  %d points  •  best %d" % [collected, score, best[key]])
	update_hud()

func update_hud() -> void:
	update_nova_pulse()
	%DamageCue.visible = hit_time > 0
	%NovaPulse.get_node("Status").visible = hit_time <= 0
	%NovaPulse.get_node("Charge").visible = hit_time <= 0
	%HUD.visible = state == "playing"
	%Score.text = "%04d" % score
	if shell: shell.set_status("Seeds %d of %d   •   %ds" % [collected, seed_goal(), ceili(remaining)])
	%Pulse.disabled = state != "playing" or cooldown > 0 or win_delay > 0 or defeat_delay > 0
	%PulseCharge.value = (1.0 - cooldown / 3.0) * 100.0

func update_nova_pulse() -> void:
	var camera := get_viewport().get_camera_3d()
	if camera == null: return
	var screen := camera.unproject_position(player.global_position + Vector3(0, 3.0, 0))
	var extent := get_viewport_rect().size
	%NovaPulse.position = Vector2(clampf(screen.x - 100, 12, extent.x - 212), clampf(screen.y - 48, 122, extent.y - 60))
	%NovaPulse.get_node("Charge").value = (1.0 - cooldown / 3.0) * 100.0
	%NovaPulse.get_node("Status").text = "PULSE  %.1fs" % cooldown if cooldown > 0 else "PULSE READY"

func play_hit_feedback() -> void:
	hit_time = 1.0
	player.set_protected(true)
	player.get_node("HitAnimation").play("hit")
	player.get_node("HitAnimation").advance(0)
	%DamageCue.get_node("AnimationPlayer").play("hit")
	%DamageCue.get_node("AnimationPlayer").advance(0)
	var heart := %Lives.get_child(clampi(hearts, 0, 2))
	heart.get_node("AnimationPlayer").play("lost")
	heart.get_node("AnimationPlayer").advance(0)

func reset_hit_feedback() -> void:
	player.get_node("HitAnimation").stop()
	player.get_node("Model").rotation.x = 0
	player.get_node("HitFlash").mesh.material.albedo_color.a = 0
	player.get_node("Shield/Bubble").mesh.material.albedo_color.a = 0
	player.get_node("Shield/Ring").scale = Vector3.ONE
	%DamageCue.get_node("AnimationPlayer").stop()
	%DamageCue.hide()
	for heart in %Lives.get_children():
		heart.get_node("AnimationPlayer").stop()
		heart.get_node("Fill").scale = Vector2.ONE
		heart.get_node("Fill").modulate = Color.WHITE
