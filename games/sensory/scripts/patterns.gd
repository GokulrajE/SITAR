extends Control
## Connect & Draw: line patterns only, no pictures.
##   1 Connect     - tap the numbered dots in order
##   2 Copy        - tap dots on a blank grid to copy the pattern beside it
##   3 From memory - the pattern shows for a moment, then is hidden
## A copy is checked by itself once enough dots are placed.
const Shell = preload("res://scripts/shared/game_shell.gd")
const Catalog = preload("res://games/sensory/scripts/pattern_catalog.gd")
const Matcher = preload("res://games/sensory/scripts/pattern_matcher.gd")
const FONT := preload("res://assets/fonts/Nunito-SemiBold.ttf")
const SAVE := "user://sensory_progress.cfg"
const ROUNDS := 6
const RADIUS := 46.0
## Most points per pattern, per level.
const MAX_POINTS := [5, 6, 8]
const LOOK_TIME := 4.0
## One finger can break the infrared beams twice.
const SAME_TOUCH_TIME := 0.25
const INK := Color("2b4a5a")
const LINE := Color("e07a3a")
const DONE := Color("2f8f6a")

## Big canvas for Connect; a guide panel and a canvas for Copy and Memory.
const FULL := Rect2(260, 150, 1400, 800)
const GUIDE := Rect2(70, 170, 560, 560)
const CANVAS := Rect2(700, 150, 1150, 800)

var shell: Control
var level := 0
var playing := false
var paused := false
var round_index := 0
var mistakes := 0
var score := 0
var pattern: Dictionary = {}
var targets: Array[Vector2] = []
var drawn: Array[Vector2] = []
var reached := 0
var solved := false
var _wait := 0.0
var _clear_in := 0.0
var _look := 0.0
var _shake := 0.0
var _clock := 0.0
var _last_touch := -1.0
var _order: Array = []


func _ready() -> void:
	size = Vector2(1920, 1080)
	shell = Shell.new()
	shell.title = "Connect & Draw"
	shell.levels = ["Connect", "Copy", "From memory"]
	shell.notes = ["Tap the dots in order", "Draw it beside the guide", "Look, then draw"]
	shell.accent = Color("d0682a")
	add_child(shell)
	shell.start_pressed.connect(start)
	shell.pause_changed.connect(func(value: bool): paused = value)
	shell.stop_pressed.connect(func():
		playing = false
		queue_redraw())


func start(chosen: int) -> void:
	level = chosen
	round_index = 0
	mistakes = 0
	score = 0
	paused = false
	playing = true
	_wait = 0.0
	_clear_in = 0.0
	_shake = 0.0
	# Smaller patterns first, never the same one twice in a session.
	_order = range(Catalog.DESIGNS.size()).filter(func(i): return Catalog.DESIGNS[i][2].size() <= MAX_POINTS[level])
	_order.shuffle()
	_order = _order.slice(0, ROUNDS)
	_order.sort_custom(func(a, b): return Catalog.DESIGNS[a][2].size() < Catalog.DESIGNS[b][2].size())
	new_round()


func new_round() -> void:
	var entry: Array = Catalog.DESIGNS[_order[round_index]]
	pattern = {name = entry[0], grid = entry[2], closed = entry[0] in CLOSED}
	targets = _place(pattern.grid, FULL if level == 0 else CANVAS)
	drawn.clear()
	reached = 0
	solved = false
	_look = LOOK_TIME if level == 2 else 0.0
	shell.set_status("Pattern %d of %d" % [round_index + 1, ROUNDS])
	queue_redraw()


const CLOSED := ["Triangle", "Square", "Diamond", "House", "Sailboat", "Crown", "Hexagon", "Arrow", "Butterfly", "Fish", "Ribbon", "Octagon"]


## Grid points 0..4 inside an area, with room for the dots.
func _place(grid: Array, area: Rect2) -> Array[Vector2]:
	var inner := area.grow(-90)
	var side := minf(inner.size.x, inner.size.y)
	var origin := inner.get_center() - Vector2(side, side) * 0.5
	var points: Array[Vector2] = []
	for pair in grid:
		var point := origin + Vector2(pair[0], pair[1]) / 4.0 * side
		if point not in points: points.append(point)
	return points


func _input(event: InputEvent) -> void:
	if not playing or paused or solved or _clear_in > 0.0: return
	if not (event is InputEventScreenTouch and event.pressed): return
	if _clock - _last_touch < SAME_TOUCH_TIME: return
	_last_touch = _clock
	if level == 0: _tap_dot(event.position)
	else: _place_dot(event.position)


func _tap_dot(point: Vector2) -> void:
	if not FULL.has_point(point): return
	get_viewport().set_input_as_handled()
	if point.distance_to(targets[reached]) <= RADIUS * 1.4:
		reached += 1
		if reached == targets.size(): _solve()
	else:
		for index in targets.size():
			if index != reached and point.distance_to(targets[index]) <= RADIUS * 1.4:
				mistakes += 1
				_shake = 0.4
				shell.toast("Find number %d" % (reached + 1), false)
				break
	queue_redraw()


func _place_dot(point: Vector2) -> void:
	# While the pattern is still showing in memory mode, the canvas waits.
	if _look > 0.0 or solved or not CANVAS.grow(-30).has_point(point): return
	get_viewport().set_input_as_handled()
	for other in drawn:
		if other.distance_to(point) < 40: return
	drawn.append(point)
	if drawn.size() == targets.size():
		if Matcher.matches(targets, drawn, pattern.closed): _solve()
		else:
			mistakes += 1
			_shake = 0.5
			_clear_in = 0.9
			shell.toast("Not quite — try again", false)
	queue_redraw()


func _solve() -> void:
	solved = true
	score += 100
	shell.toast(["Well drawn!", "Lovely!", "Perfect!"][round_index % 3])
	_wait = 1.4


func _process(delta: float) -> void:
	_clock += delta
	if not playing or paused: return
	_shake = maxf(0.0, _shake - delta)
	if _look > 0.0: _look = maxf(0.0, _look - delta)
	if _clear_in > 0.0:
		_clear_in -= delta
		if _clear_in <= 0.0: drawn.clear()
	if _wait > 0.0:
		_wait -= delta
		if _wait <= 0.0:
			round_index += 1
			if round_index >= ROUNDS: _finish()
			else: new_round()
	queue_redraw()


func _finish() -> void:
	playing = false
	var config := ConfigFile.new()
	config.load(SAVE)
	var best := maxi(score, int(config.get_value("pattern_levels", str(level), 0)))
	config.set_value("pattern_levels", str(level), best)
	config.save(SAVE)
	var stars := 3 if mistakes <= 1 else (2 if mistakes <= 3 else 1)
	shell.finish(stars, "Level %d complete!" % (level + 1), "%d patterns  •  best %d" % [ROUNDS, best])
	queue_redraw()


# ------------------------------------------------------------------ art

func _draw() -> void:
	# Drawing paper on a desk.
	draw_rect(Rect2(0, 0, 1920, 1080), Color("d9cbb2"))
	if not playing:
		_paper(Rect2(160, 140, 1600, 840))
		return
	var shake := Vector2(sin(_clock * 60.0) * 10.0 * _shake / 0.5, 0)
	if level == 0:
		_paper(FULL)
		_path(targets, reached, pattern.closed and solved, shake)
		for index in targets.size():
			var done := index < reached
			var next := index == reached and not solved
			var glow := 6.0 * sin(_clock * 4.0) if next else 0.0
			if next: draw_circle(targets[index] + shake, RADIUS + 16 + glow, Color(LINE, 0.18))
			draw_circle(targets[index] + shake, RADIUS, DONE if done or solved else (LINE if next else INK))
			draw_string(FONT, targets[index] + shake + Vector2(-RADIUS, 15), str(index + 1), HORIZONTAL_ALIGNMENT_CENTER, RADIUS * 2, 44, Color.WHITE)
		return
	_paper(GUIDE, Color("fbf6ea"))
	_paper(CANVAS)
	var guide := _place(pattern.grid, GUIDE)
	if level == 1 or _look > 0.0 or solved:
		_path(guide, guide.size(), pattern.closed, Vector2.ZERO, 8.0, INK)
		for index in guide.size():
			draw_circle(guide[index], 22, INK)
			draw_string(FONT, guide[index] + Vector2(-22, 9), str(index + 1), HORIZONTAL_ALIGNMENT_CENTER, 44, 24, Color.WHITE)
		if _look > 0.0:
			draw_arc(GUIDE.position + Vector2(GUIDE.size.x - 50, 50), 30, -PI / 2, -PI / 2 + TAU * _look / LOOK_TIME, 40, LINE, 8.0, true)
	else:
		draw_string(FONT, Vector2(GUIDE.position.x, GUIDE.get_center().y + 30), "?", HORIZONTAL_ALIGNMENT_CENTER, GUIDE.size.x, 200, Color(INK, 0.25))
	# The player's dots on a dotted grid.
	for x in range(int(CANVAS.position.x) + 50, int(CANVAS.end.x) - 20, 60):
		for y in range(int(CANVAS.position.y) + 50, int(CANVAS.end.y) - 20, 60):
			draw_circle(Vector2(x, y), 3, Color(INK, 0.15))
	var colour := DONE if solved else (Color("c0503a") if _clear_in > 0.0 else LINE)
	_path(drawn, drawn.size(), pattern.closed and drawn.size() == targets.size(), shake, 10.0, colour)
	for index in drawn.size():
		draw_circle(drawn[index] + shake, 34, colour)
		draw_string(FONT, drawn[index] + shake + Vector2(-34, 12), str(index + 1), HORIZONTAL_ALIGNMENT_CENTER, 68, 34, Color.WHITE)
	if drawn.is_empty() and _look <= 0.0 and not solved:
		draw_string(FONT, Vector2(CANVAS.position.x, CANVAS.end.y - 40), "%d dots" % targets.size(), HORIZONTAL_ALIGNMENT_CENTER, CANVAS.size.x, 38, Color(INK, 0.45))


func _paper(area: Rect2, colour := Color("fffdf7")) -> void:
	var box := StyleBoxFlat.new()
	box.bg_color = colour
	box.set_corner_radius_all(24)
	box.shadow_color = Color(0, 0, 0, 0.18)
	box.shadow_size = 16
	box.shadow_offset = Vector2(0, 6)
	draw_style_box(box, area)


func _path(points: Array[Vector2], count: int, close: bool, shift: Vector2, width := 12.0, colour := LINE) -> void:
	var line := PackedVector2Array()
	for index in mini(count, points.size()): line.append(points[index] + shift)
	if close and line.size() > 2: line.append(line[0])
	if line.size() > 1: draw_polyline(line, DONE if solved else colour, width, true)
