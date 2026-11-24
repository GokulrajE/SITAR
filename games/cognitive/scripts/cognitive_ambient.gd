extends Node2D
## Quiet life around the board: one small animal at a time and swaying plants.
## Everything here is drawn behind the board, so it never covers a choice.
const Art = preload("res://games/cognitive/scripts/cognitive_art.gd")

## What each row of ambient_4x4.png does.
const HABITS := [
	["fly", "fly", "crawl", "fly"],
	["swim", "fly", "fly", "drift"],
	["fly", "fly", "fall", "crawl"]]
const LEFT_PLANTS := Rect2(0, 780, 290, 300)
const RIGHT_PLANTS := Rect2(1700, 780, 220, 300)

var reduced_motion := false
var mode := 0
var level := 0
var _clock := 0.0
var _wait := 2.0
var _visitor := {}
var _last_row := -1


func setup(new_mode: int, new_level: int) -> void:
	mode = new_mode
	level = new_level
	_visitor = {}
	_wait = 2.5
	queue_redraw()


func advance(delta: float) -> void:
	if reduced_motion:
		_visitor = {}
		return
	_clock += delta
	if _visitor.is_empty():
		_wait -= delta
		if _wait <= 0.0: _visit()
	else:
		_visitor.age += delta
		_visitor.pos += _visitor.velocity * delta
		if not Rect2(-160, -60, 2240, 1260).has_point(_visitor.pos):
			_visitor = {}
			_wait = randf_range(4.0, 8.0)
	queue_redraw()


func _visit() -> void:
	var row := randi_range(0, 3)
	if row == _last_row: row = (row + 1) % 4
	_last_row = row
	var right := randf() < 0.5
	var heading := 1.0 if right else -1.0
	var start := -120.0 if right else 2040.0
	var habit: String = HABITS[mode][row]
	_visitor = {row = row, habit = habit, age = 0.0, right = right, side = 96.0, speed = 9.0, alpha = 1.0}
	match habit:
		"fly":
			_visitor.pos = Vector2(start, randf_range(150, 230))
			_visitor.velocity = Vector2(heading * randf_range(110, 160), 0)
		"crawl":
			_visitor.pos = Vector2(start, 1052)
			_visitor.velocity = Vector2(heading * 40.0, 0)
			_visitor.side = 72.0
			_visitor.speed = 4.0
		"swim":
			_visitor.pos = Vector2(start, randf_range(560, 640))
			_visitor.velocity = Vector2(heading * 80.0, 0)
			_visitor.side = 130.0
			_visitor.speed = 5.0
			_visitor.alpha = 0.6
		"drift":
			_visitor.pos = Vector2(start, randf_range(1000, 1040))
			_visitor.velocity = Vector2(heading * 45.0, 0)
			_visitor.side = 64.0
			_visitor.speed = 1.2
		"fall":
			_visitor.pos = Vector2(randf_range(480, 1860), -50)
			_visitor.velocity = Vector2(-18, 70)
			_visitor.side = 70.0
			_visitor.speed = 4.0


func _draw() -> void:
	# The plants are painted in daylight colours of the first level.
	if level == 0:
		_draw_plants(LEFT_PLANTS, 0.0)
		_draw_plants(RIGHT_PLANTS, 1.7)
	if _visitor.is_empty(): return
	var bob := sin(_visitor.age * 2.2) * 16.0 if _visitor.habit in ["fly", "fall"] else 0.0
	var offset := Vector2(bob, 0) if _visitor.habit == "fall" else Vector2(0, bob)
	var side: float = _visitor.side
	draw_set_transform(_visitor.pos + offset, 0.0, Vector2(1 if _visitor.right else -1, 1))
	draw_texture_rect_region(Art.texture(Art.GAMES[mode].dir + "/ambient_4x4"),
		Rect2(-Vector2.ONE * side * 0.5, Vector2.ONE * side),
		Art.cell(_visitor.row * 4 + int(_visitor.age * _visitor.speed) % 4), Color(1, 1, 1, _visitor.alpha))
	draw_set_transform(Vector2.ZERO)


## Leans the plants around the ground line.
func _draw_plants(part: Rect2, phase: float) -> void:
	var lean := 0.0 if reduced_motion else sin(_clock * 0.9 + phase) * 0.035
	var ground := part.end.y
	draw_set_transform_matrix(Transform2D(Vector2.RIGHT, Vector2(-lean, 1), Vector2(lean * ground, 0)))
	draw_texture_rect_region(Art.texture("%s/%s" % [Art.GAMES[mode].dir, Art.GAMES[mode].fg]), part, part)
	draw_set_transform_matrix(Transform2D.IDENTITY)
