extends Node

## Manages staggered dosa spawning on a fixed set of tawa positions.

const DOSA_SCENE := preload("res://games/dosa/scenes/dosa.tscn")

## Absolute positions — the center of each StoveRig's TAWA (not the stove's
## own origin: the tawa sits offset (0,-47) within each rig to align with the
## burner ring in the stove artwork). DosaContainer sits at origin (0,0), so
## these are world coordinates, one dosa per burner.
const SLOTS: Array[Vector2] = [
	Vector2(360,  263),
	Vector2(960,  263),
	Vector2(1560, 263),
	Vector2(360,  743),
	Vector2(960,  743),
	Vector2(1560, 743),
]

var max_dosas: int = 4
var spawn_min: float = 2.0
var spawn_max: float = 3.0
var cooking_duration: float = 6.0
var ready_window: float = 1.8

var _occupied: Array[bool] = [false, false, false, false, false, false]
var _active: Array[DosaEntity] = []
var _timer: float = 0.0
var _next: float = 0.0
var _running: bool = false

@export var container: Node2D

signal dosa_spawned(dosa: DosaEntity)

func start(cfg: Dictionary) -> void:
	max_dosas       = cfg.max_dosas
	spawn_min       = cfg.spawn_min
	spawn_max       = cfg.spawn_max
	cooking_duration = cfg.cooking_duration
	ready_window    = cfg.ready_window
	_active.clear()
	_occupied.fill(false)
	_timer  = 0.0
	_next   = 0.0   # spawn first dosa immediately
	_running = true

func stop() -> void:
	_running = false

func _process(delta: float) -> void:
	if not _running:
		return
	_timer += delta
	if _timer >= _next:
		_try_spawn()
		_timer = 0.0
		_next  = randf_range(spawn_min, spawn_max)

func _try_spawn() -> void:
	if _active.size() >= max_dosas:
		return
	var slot := _free_slot()
	if slot == -1:
		return
	_spawn(slot)

func _free_slot() -> int:
	var free: Array[int] = []
	for i in _occupied.size():
		if not _occupied[i]:
			free.append(i)
	if free.is_empty():
		return -1
	return free[randi() % free.size()]

func _spawn(slot: int) -> void:
	_occupied[slot] = true
	var dosa: DosaEntity = DOSA_SCENE.instantiate()
	dosa.position = SLOTS[slot]
	dosa.cooking_duration = cooking_duration + randf_range(-0.4, 0.4)
	dosa.ready_window     = ready_window
	dosa.slot_index       = slot
	dosa.removed.connect(_on_removed.bind(slot))
	container.add_child(dosa)
	_active.append(dosa)
	dosa_spawned.emit(dosa)

func _on_removed(_dosa: DosaEntity, slot: int) -> void:
	_occupied[slot] = false
	# Remove any freed dosa from active list (may already be queued_free)
	_active = _active.filter(func(d): return is_instance_valid(d) and not d.is_queued_for_deletion())
