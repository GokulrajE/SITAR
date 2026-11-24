class_name Sfx

## Fire-and-forget sound effects. Each call spawns a short-lived
## AudioStreamPlayer parented to the current scene (not the caller), so a
## sound finishes playing even if the dosa/node that triggered it is freed
## a moment later. Plays on the Master bus, so the app's existing mute
## toggle (AudioServer.set_bus_mute(0, ...)) silences these too.

static func play(tree: SceneTree, path: String, volume_db: float = 0.0) -> void:
	if tree == null or tree.current_scene == null:
		return
	var stream := load(path) as AudioStream
	if stream == null:
		push_warning("Sfx: missing audio - " + path)
		return
	var p := AudioStreamPlayer.new()
	p.stream = stream
	p.volume_db = volume_db
	tree.current_scene.add_child(p)
	p.play()
	p.finished.connect(p.queue_free)
