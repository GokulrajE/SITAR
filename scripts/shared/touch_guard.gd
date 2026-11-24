extends Node

## IR touch frame filter — autoload as "TouchGuard".
##
## Solves two IR-frame problems:
##   1. One finger breaks two adjacent beams → reported as 2 close points
##      Fix: merge any two touches closer than MERGE_RADIUS pixels
##   2. Beam noise / brief finger lift → phantom touch appears for < GHOST_MS
##      Fix: only confirm a touch after it has held for CONFIRM_MS

## Distance below which two touch points are merged into one (pixels at 1920 wide).
## GreenTouch IR beam pitch ~5 mm → finger (~15 mm) breaks ~3 beams → ~70 px on a 23" 1920-wide display.
## Increase toward 90 if you still see doubles; decrease toward 50 if two close fingers merge incorrectly.
const MERGE_RADIUS   := 70.0

## A touch must persist this many milliseconds before being confirmed as real.
## GreenTouch frames report at ~125 Hz (8 ms intervals); 40 ms = ~5 frames of hold = reliable.
const CONFIRM_MS     := 40

## If a touch disappears within this many milliseconds treat it as noise and discard.
## GreenTouch ghost spikes are typically 1-2 frames (~8-16 ms); 50 ms catches them.
const GHOST_MS       := 50

# --- internal state ---

# Raw touches straight from Godot: index -> {pos, time_began}
var _raw: Dictionary = {}

# Confirmed, deduplicated touches exposed to game code: logical_id -> Vector2
var touches: Dictionary = {}

# logical_id counter
var _next_id: int = 0

# Maps raw index -> logical_id (set once touch is confirmed)
var _raw_to_logical: Dictionary = {}

signal touch_began(index: int, position: Vector2)
signal touch_moved(index: int, position: Vector2)
signal touch_ended(index: int, position: Vector2)
signal touch_count_changed(count: int)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_raw[event.index] = {pos = event.position, began = Time.get_ticks_msec()}
		else:
			_release_raw(event.index)
	elif event is InputEventScreenDrag:
		if event.index in _raw:
			_raw[event.index].pos = event.position
		if event.index in _raw_to_logical:
			var lid: int = _raw_to_logical[event.index]
			touches[lid] = event.position
			touch_moved.emit(lid, event.position)

func _process(_delta: float) -> void:
	var now := Time.get_ticks_msec()

	# Confirm raw touches that have held long enough
	for idx in _raw.keys():
		if idx in _raw_to_logical:
			continue  # already confirmed
		var held: int = now - (_raw[idx].began as int)
		if held < CONFIRM_MS:
			continue

		# Check if this touch is too close to an already-confirmed touch
		var pos: Vector2 = _raw[idx].pos
		var duplicate := false
		for lid in touches:
			if pos.distance_to(touches[lid]) < MERGE_RADIUS:
				duplicate = true
				break

		if duplicate:
			# Treat as noise from the same finger — merge silently
			_raw_to_logical[idx] = -1  # mark as suppressed
		else:
			var lid := _next_id
			_next_id += 1
			_raw_to_logical[idx] = lid
			touches[lid] = pos
			touch_began.emit(lid, pos)
			touch_count_changed.emit(touches.size())

func _release_raw(idx: int) -> void:
	var now := Time.get_ticks_msec()

	if idx in _raw_to_logical:
		var lid: int = _raw_to_logical[idx]
		_raw_to_logical.erase(idx)
		if lid >= 0:
			# Ghost check: if the touch was confirmed but vanished very fast,
			# still emit ended so games don't get stuck
			touches.erase(lid)
			touch_ended.emit(lid, _raw[idx].pos if idx in _raw else Vector2.ZERO)
			touch_count_changed.emit(touches.size())
	else:
		# Touch released before CONFIRM_MS — check ghost threshold
		if idx in _raw:
			var age: int = now - (_raw[idx].began as int)
			if age < GHOST_MS:
				pass  # discard silently — noise spike

	_raw.erase(idx)

# --- helpers for game scripts ---

func get_touch_count() -> int:
	return touches.size()

func get_touch_position(logical_id: int) -> Vector2:
	return touches.get(logical_id, Vector2.ZERO)

func get_all_positions() -> Array[Vector2]:
	var out: Array[Vector2] = []
	for v in touches.values():
		out.append(v)
	return out
