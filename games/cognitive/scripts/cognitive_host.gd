extends Node2D
## Plays one animal host's sprite sheets. The node's origin is between the feet.
const Art = preload("res://games/cognitive/scripts/cognitive_art.gd")

const FEET := 463.0 / 512.0
const LIVELY := ["happy", "found", "dance", "cheer", "conduct", "water"]
## The open tail needs room, so this sheet's bird is smaller; drawn larger to match.
const SHEET_SCALE := {"nila_cheer": 1.57}

@export var dir := "meadow"
@export var host := "moti"
@export var cell_size := 640.0
var anim := "idle"
var reduced_motion := false
var _clock := 0.0
var _looping := true
var _accent := ""
var _accent_gap := 0.0
var _idle_time := 0.0


func setup(game: Dictionary, side: float) -> void:
	dir = game.dir
	host = game.host
	cell_size = side
	rest()


## Calm idle loop.
func rest() -> void:
	_accent = ""
	_start("idle", true)


## Repeats until something else is played.
func loop(new_anim: String) -> void:
	_accent = ""
	if anim == new_anim and _looping: return
	_start(new_anim, true)


## Plays once, then returns to idle.
func play_once(new_anim: String) -> void:
	_start(new_anim, false)


## Idle, with one animation played now and then in between.
func rest_with(accent: String, gap: float) -> void:
	_accent = accent
	_accent_gap = gap
	_start(accent, false)


## As rest_with, but lets the running animation finish first.
func then_rest_with(accent: String, gap: float) -> void:
	_accent = accent
	_accent_gap = gap


func _start(new_anim: String, looping: bool) -> void:
	anim = new_anim
	_looping = looping
	_clock = 0.0
	_idle_time = 0.0
	queue_redraw()


func advance(delta: float) -> void:
	var before := frame()
	_clock += delta
	if anim == "idle":
		_idle_time += delta
		if _accent != "" and _idle_time >= _accent_gap: _start(_accent, false)
	elif not _looping and _clock * _fps() >= 16.0:
		_start("idle", true)
	if frame() != before: queue_redraw()


func frame() -> int:
	if reduced_motion: return 0 if anim == "idle" else 7
	return int(_clock * _fps()) % 16


func _fps() -> float:
	return 12.0 if anim in LIVELY else 10.0


func _draw() -> void:
	var side: float = cell_size * SHEET_SCALE.get("%s_%s" % [host, anim], 1.0)
	draw_texture_rect(Art.soft_spot(), Rect2(-cell_size * 0.27, -cell_size * 0.055, cell_size * 0.54, cell_size * 0.1),
		false, Color(0.08, 0.1, 0.03, 0.3))
	draw_texture_rect_region(Art.texture("%s/%s_%s_4x4" % [dir, host, anim]),
		Rect2(-side * 0.5, -side * FEET, side, side), Art.cell(frame()))
