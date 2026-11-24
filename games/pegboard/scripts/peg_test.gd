extends Control
## Pegboard touch tester - several boards at once.
##
## Reads RAW touches straight from the IR frame (bypasses TouchGuard's merge).
## The frame reports at most 10 contacts, so up to 3 boards (9 legs) can be
## on the screen together. Touch points are split into separate 3-leg boards:
##   * a 3-point group is only a board if every leg is within one board span
##   * when boards are recorded, the grouping that best matches them wins
##     (this separates two boards that sit close together)
##   * points that fit no board (a hand, a ghost) are shown as stray points
##
## For each board it shows its legs, side lengths (= the board's signature),
## jitter, rotation and which recorded board it matches.
## Record each board into a slot (only ONE board on screen while recording).
## Keys: Esc = back, F11 = fullscreen, R = reset counters.

const SLOTS: Array[String] = ["Old A", "Old B", "Old C", "New A", "New B", "New C"]
const SAVE_PATH := "user://peg_patterns.json"
const RECORD_SECS := 1.5
const FLICKER_SECS := 0.6
const PANEL_W := 460.0
const LEG_D_MM := 7.0
const MIN_SIDE_MM := 8.0           # two contacts closer than this can't be two legs

const COLORS: Array[Color] = [
	Color(0.35, 0.8, 1.0), Color(1.0, 0.7, 0.3), Color(0.6, 1.0, 0.45),
	Color(1.0, 0.45, 0.75), Color(0.8, 0.6, 1.0), Color(1.0, 1.0, 0.45),
]
const STRAY := Color(0.6, 0.6, 0.6)

## Automated tests set this false so they never overwrite real recordings.
var persist := true

var _pts: Dictionary = {}          # raw touch index -> Vector2
var _patterns: Dictionary = {}     # slot name -> {"sig": [a,b,c], "angle": deg}

var _recording := ""
var _rec_samples: Array = []
var _rec_time := 0.0

## Current boards: each {"pts": Array[Vector2], "sig": Array[float], "angle": float,
## "match": String, "err": float, "color": Color}
var _boards: Array = []
var _strays: Array[Vector2] = []
var _hist: Dictionary = {}         # board key -> recent signatures (for jitter)

var _log: Array[String] = []
var _last_count := 0
var _max_count := 0
var _flickers := 0
var _stray_events := 0
var _last_strays := 0
var _drop_at := -1.0
var _drop_from := 0
var _rate := 0.0
var _rate_n := 0
var _rate_t := 0.0

var _width_mm: SpinBox
var _tol: SpinBox
var _close_mm: SpinBox
var _span_mm: SpinBox
var _max_boards: SpinBox
var _info: Label
var _mono: SystemFont

# search scratch
var _best_groups: Array = []
var _best_count := 0
var _best_cost := INF


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_mono = SystemFont.new()
	_mono.font_names = PackedStringArray(["Consolas", "Courier New", "monospace"])
	_build_panel()
	_load()
	# mm readings are only true when the canvas fills the whole screen.
	get_window().mode = Window.MODE_FULLSCREEN
	_add_log("Ready. Place up to %d boards on the left area." % int(_max_boards.value))


# ---------------------------------------------------------------- UI ------

func _build_panel() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.09, 0.12, 0.96)
	bg.position = Vector2(_vw() - PANEL_W, 0)
	bg.size = Vector2(PANEL_W, _vh())
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(bg)

	var box := VBoxContainer.new()
	box.position = Vector2(14, 10)
	box.size = Vector2(PANEL_W - 28, _vh() - 20)
	box.add_theme_constant_override("separation", 5)
	bg.add_child(box)

	var title := Label.new()
	title.text = "PEGBOARD TOUCH TESTER"
	title.add_theme_font_size_override("font_size", 22)
	box.add_child(title)

	_width_mm = _spin(box, "Screen width (mm)", 200, 2000, 1, 509)
	_tol = _spin(box, "Match tolerance (mm)", 1, 20, 0.5, 5)
	_close_mm = _spin(box, "Warn if legs closer than (mm)", 5, 80, 1, 25)
	_span_mm = _spin(box, "Max leg distance on one board (mm)", 20, 200, 1, 75)
	_max_boards = _spin(box, "Boards at once (10 contacts max)", 1, 3, 1, 3)

	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 6)
	box.add_child(grid)
	for s in SLOTS:
		var b := Button.new()
		b.text = "Rec " + s
		b.custom_minimum_size = Vector2(134, 42)
		b.pressed.connect(_start_record.bind(s))
		grid.add_child(b)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	box.add_child(row)
	_button(row, "Clear boards", _clear_patterns)
	_button(row, "Reset counters", _reset_stats)
	_button(row, "Fullscreen", _toggle_fullscreen)
	_button(row, "Back", _back)

	_info = Label.new()
	_info.add_theme_font_override("font", _mono)
	_info.add_theme_font_size_override("font_size", 14)
	_info.autowrap_mode = TextServer.AUTOWRAP_OFF
	box.add_child(_info)


func _spin(parent: Control, label: String, lo: float, hi: float, step: float, val: float) -> SpinBox:
	var row := HBoxContainer.new()
	var l := Label.new()
	l.text = label
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(l)
	var s := SpinBox.new()
	s.min_value = lo
	s.max_value = hi
	s.step = step
	s.value = val
	s.custom_minimum_size = Vector2(110, 0)
	row.add_child(s)
	parent.add_child(row)
	return s


func _button(parent: Control, text: String, cb: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0, 40)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.pressed.connect(cb)
	parent.add_child(b)


# ------------------------------------------------------------- input ------

func _input(e: InputEvent) -> void:
	if e is InputEventScreenTouch:
		var t := e as InputEventScreenTouch
		_rate_n += 1
		if t.pressed:
			_pts[t.index] = t.position
			_add_log("DOWN #%d  (%d, %d) px" % [t.index, t.position.x, t.position.y])
		else:
			_pts.erase(t.index)
			_add_log("UP   #%d" % t.index)
	elif e is InputEventScreenDrag:
		var d := e as InputEventScreenDrag
		_pts[d.index] = d.position
		_rate_n += 1
	elif e is InputEventKey and e.pressed and not e.echo:
		match (e as InputEventKey).keycode:
			KEY_ESCAPE: _back()
			KEY_F11: _toggle_fullscreen()
			KEY_R: _reset_stats()


# ----------------------------------------------------------- process ------

func _process(delta: float) -> void:
	var now := Time.get_ticks_msec() / 1000.0
	_rate_t += delta
	if _rate_t >= 1.0:
		_rate = _rate_n / _rate_t
		_rate_n = 0
		_rate_t = 0.0

	var pts := _board_points()
	var n := pts.size()
	# A leg that vanishes and comes back quickly = the frame lost a contact.
	if n < _last_count and n > 0 and _drop_at < 0.0:
		_drop_at = now
		_drop_from = _last_count
	if _drop_at > 0.0:
		if n == 0 or now - _drop_at > FLICKER_SECS:
			_drop_at = -1.0          # board lifted / stayed off - not a flicker
		elif n >= _drop_from:
			_flickers += 1
			_add_log("!! FLICKER: a leg dropped out for %d ms" % int((now - _drop_at) * 1000))
			_drop_at = -1.0
	_last_count = n
	_max_count = maxi(_max_count, n)

	_group(pts)

	if _strays.size() > _last_strays:
		_stray_events += 1
		_add_log("!! %d stray point(s) - not part of a board" % _strays.size())
	_last_strays = _strays.size()

	if _recording != "":
		if _boards.size() == 1 and n == 3:
			var b: Dictionary = _boards[0]
			var s: Array = b.sig
			_rec_samples.append([s[0], s[1], s[2], b.angle])
			_rec_time += delta
			if _rec_time >= RECORD_SECS:
				_finish_record()

	queue_redraw()
	_update_text()


func _board_points() -> Array[Vector2]:
	var out: Array[Vector2] = []
	var panel_x := _vw() - PANEL_W
	for p in _pts.values():
		var v: Vector2 = p
		if v.x < panel_x:
			out.append(v)
	return out


# ----------------------------------------------------------- grouping -----

## Splits the points into up to N disjoint 3-leg boards.
## Most boards wins; ties go to the lowest total cost (best pattern match,
## or the most compact triangles when nothing is recorded).
func _group(pts: Array[Vector2]) -> void:
	_best_groups = []
	_best_count = 0
	_best_cost = INF
	var used: Array[bool] = []
	used.resize(pts.size())
	used.fill(false)
	_search(pts, used, 0, [], 0.0)

	_boards.clear()
	var taken: Array[bool] = []
	taken.resize(pts.size())
	taken.fill(false)
	for g in _best_groups:
		var tri: Array[Vector2] = [pts[g[0]], pts[g[1]], pts[g[2]]]
		for i in g:
			taken[i] = true
		var sig := _signature(tri)
		var m := _best_match(sig)
		_boards.append({
			"pts": tri, "sig": sig, "angle": _rotation(tri),
			"match": m[0] if m.size() > 0 else "",
			"err": float(m[1]) if m.size() > 0 else INF,
		})
	# stable order (left to right) so colours don't jump between frames
	_boards.sort_custom(func(p, q): return _centroid(p.pts).x < _centroid(q.pts).x)
	for i in _boards.size():
		_boards[i]["color"] = COLORS[i % COLORS.size()]
		var key: String = _boards[i].match if _boards[i].err <= _tol.value else "board%d" % i
		var h: Array = _hist.get(key, [])
		h.append(_boards[i].sig)
		if h.size() > 60:
			h.pop_front()
		_hist[key] = h
		_boards[i]["key"] = key
	_strays.clear()
	for i in pts.size():
		if not taken[i]:
			_strays.append(pts[i])


func _search(pts: Array[Vector2], used: Array[bool], start: int, groups: Array, cost: float) -> void:
	var count := groups.size()
	if count > _best_count or (count == _best_count and cost < _best_cost):
		_best_count = count
		_best_cost = cost
		_best_groups = groups.duplicate()
	if count >= int(_max_boards.value):
		return
	var i := start
	while i < pts.size() and used[i]:
		i += 1
	if i >= pts.size():
		return
	# option 1: point i is a stray
	_search(pts, used, i + 1, groups, cost)
	# option 2: point i is a leg, together with two later points
	used[i] = true
	for j in range(i + 1, pts.size()):
		if used[j]:
			continue
		used[j] = true
		for k in range(j + 1, pts.size()):
			if used[k]:
				continue
			var c := _triple_cost(pts[i], pts[j], pts[k])
			if c < 0.0:
				continue
			used[k] = true
			groups.append([i, j, k])
			_search(pts, used, i + 1, groups, cost + c)
			groups.pop_back()
			used[k] = false
		used[j] = false
	used[i] = false


## < 0 = cannot be one board. Otherwise lower is a better fit.
func _triple_cost(a: Vector2, b: Vector2, c: Vector2) -> float:
	var t: Array[Vector2] = [a, b, c]
	var s := _signature(t)
	if s[2] > _span_mm.value or s[0] < MIN_SIDE_MM:
		return -1.0
	if _patterns.is_empty():
		return (s[0] + s[1] + s[2]) / 1000.0
	var m := _best_match(s)
	return minf(float(m[1]), 3.0 * _tol.value)


func _signature(t: Array[Vector2]) -> Array[float]:
	var k := _mm()
	var s: Array[float] = [t[0].distance_to(t[1]) * k, t[1].distance_to(t[2]) * k, t[2].distance_to(t[0]) * k]
	s.sort()
	return s


func _centroid(t: Array) -> Vector2:
	return (t[0] + t[1] + t[2]) / 3.0


## Board rotation, using leg identity (works because the triangle is scalene):
## direction from the leg opposite the shortest side to the leg opposite the longest.
func _rotation(t: Array[Vector2]) -> float:
	var opp: Array = []
	for i in 3:
		opp.append([t[(i + 1) % 3].distance_to(t[(i + 2) % 3]), i])
	opp.sort_custom(func(p, q): return p[0] < q[0])
	var a: Vector2 = t[int(opp[0][1])]
	var b: Vector2 = t[int(opp[2][1])]
	return rad_to_deg((b - a).angle())


func _err(a: Array, b: Array) -> float:
	return maxf(absf(a[0] - b[0]), maxf(absf(a[1] - b[1]), absf(a[2] - b[2])))


## Returns [slot, error] of the closest recorded board, or [] if none recorded.
func _best_match(sig: Array[float]) -> Array:
	var best := ""
	var best_err := INF
	for s in _patterns:
		var e := _err(sig, _patterns[s]["sig"])
		if e < best_err:
			best_err = e
			best = s
	return [] if best == "" else [best, best_err]


# --------------------------------------------------------- recording ------

func _start_record(slot: String) -> void:
	_recording = slot
	_rec_samples.clear()
	_rec_time = 0.0
	_add_log("Recording %s - ONE board only" % slot)


func _finish_record() -> void:
	var avg := [0.0, 0.0, 0.0]
	for s in _rec_samples:
		for i in 3:
			avg[i] += float(s[i]) / _rec_samples.size()
	var angle: float = _rec_samples[_rec_samples.size() - 1][3]
	_patterns[_recording] = {"sig": avg, "angle": angle}
	_add_log("Saved %s: %.1f / %.1f / %.1f mm" % [_recording, avg[0], avg[1], avg[2]])
	_recording = ""
	_save()


func _clear_patterns() -> void:
	_patterns.clear()
	_save()
	_add_log("Cleared all recorded boards.")


func _reset_stats() -> void:
	_flickers = 0
	_stray_events = 0
	_max_count = 0
	_hist.clear()
	_add_log("Counters reset.")


func _save() -> void:
	if not persist:
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"patterns": _patterns, "width_mm": _width_mm.value}))


func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var d: Variant = JSON.parse_string(f.get_as_text()) if f else null
	if d is Dictionary:
		_patterns = (d as Dictionary).get("patterns", {})
		_width_mm.value = float((d as Dictionary).get("width_mm", _width_mm.value))


# ----------------------------------------------------------- drawing ------

func _draw() -> void:
	var area := Vector2(_vw() - PANEL_W, _vh())
	draw_rect(Rect2(Vector2.ZERO, area), Color(0.04, 0.05, 0.07))
	var font := ThemeDB.fallback_font
	var k := _mm()

	# 50 mm grid so you can eyeball real sizes
	var step := 50.0 / k
	var x := 0.0
	while x < area.x:
		draw_line(Vector2(x, 0), Vector2(x, area.y), Color(1, 1, 1, 0.05))
		x += step
	var y := 0.0
	while y < area.y:
		draw_line(Vector2(0, y), Vector2(area.x, y), Color(1, 1, 1, 0.05))
		y += step
	draw_string(font, Vector2(10, area.y - 12), "grid = 50 mm", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(1, 1, 1, 0.35))

	for b in _boards:
		var tri: Array[Vector2] = b.pts
		var col: Color = b.color
		var ok: bool = b.err <= _tol.value
		draw_colored_polygon(PackedVector2Array(tri), Color(col, 0.16))
		# the three sides of THIS board only
		for i in 3:
			var p := tri[i]
			var q := tri[(i + 1) % 3]
			var dmm := p.distance_to(q) * k
			var lc := Color(1, 0.3, 0.3) if dmm < _close_mm.value else col
			draw_line(p, q, lc, 3, true)
			draw_string(font, (p + q) / 2.0 + Vector2(-60, -6), "%.1f mm" % dmm,
				HORIZONTAL_ALIGNMENT_CENTER, 120, 16, lc)
		for p in tri:
			draw_circle(p, LEG_D_MM / 2.0 / k, Color(col, 0.45))
			draw_arc(p, LEG_D_MM / 2.0 / k, 0, TAU, 32, col, 2, true)
			draw_circle(p, 3, Color.WHITE)
			draw_string(font, p + Vector2(16, -6), "(%d, %d) px" % [p.x, p.y], HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(col, 0.85))
		var c := _centroid(tri)
		draw_line(c - Vector2(10, 0), c + Vector2(10, 0), Color.WHITE, 2)
		draw_line(c - Vector2(0, 10), c + Vector2(0, 10), Color.WHITE, 2)
		var below := Vector2(c.x, maxf(tri[0].y, maxf(tri[1].y, tri[2].y)) + 24.0)
		var label := "board (no recordings)"
		if b.match != "":
			label = ("%s  (err %.1f mm)" % [b.match, b.err]) if ok else ("UNKNOWN  (closest %s, %.1f)" % [b.match, b.err])
		draw_string(font, below + Vector2(-200, 30), label, HORIZONTAL_ALIGNMENT_CENTER, 400, 24,
			Color(0.5, 1, 0.6) if ok else Color(1, 0.8, 0.4))
		draw_string(font, below + Vector2(-200, 56), "rotation %.0f°" % b.angle, HORIZONTAL_ALIGNMENT_CENTER, 400, 16, Color(1, 1, 1, 0.7))

	for p in _strays:
		draw_circle(p, LEG_D_MM / 2.0 / k, Color(STRAY, 0.35))
		draw_arc(p, 18, 0, TAU, 32, STRAY, 2, true)
		draw_string(font, p + Vector2(22, 6), "stray (%d, %d)" % [p.x, p.y], HORIZONTAL_ALIGNMENT_LEFT, -1, 14, STRAY)

	# recording progress
	if _recording != "":
		var w := area.x * 0.5
		var r := Rect2((area.x - w) / 2.0, 20, w, 26)
		draw_rect(r, Color(1, 1, 1, 0.15))
		draw_rect(Rect2(r.position, Vector2(w * clampf(_rec_time / RECORD_SECS, 0, 1), r.size.y)), Color(1, 0.35, 0.35))
		var msg := "RECORDING %s - keep 3 legs still" % _recording
		if _board_points().size() > 3:
			msg = "RECORDING %s - leave only ONE board on the screen" % _recording
		draw_string(font, r.position + Vector2(0, 52), msg, HORIZONTAL_ALIGNMENT_CENTER, w, 20, Color.WHITE)


func _update_text() -> void:
	var t := PackedStringArray()
	var n := _board_points().size()
	t.append("points: %d  max: %d  boards: %d  stray: %d" % [n, _max_count, _boards.size(), _strays.size()])
	t.append("flickers: %d   stray events: %d   ev/s: %d" % [_flickers, _stray_events, int(_rate)])
	t.append("mm per px: %.3f%s" % [_mm(), "" if get_window().mode == Window.MODE_FULLSCREEN else "  !! not fullscreen"])
	t.append("")
	t.append("---- boards on screen  (tol %.1f) ----" % _tol.value)
	if _boards.is_empty():
		t.append("(need 3 legs per board)")
	var names: Array[String] = []
	for i in _boards.size():
		var b: Dictionary = _boards[i]
		var s: Array = b.sig
		var ok: bool = b.err <= _tol.value
		var name: String = b.match if ok else "UNKNOWN"
		names.append(name)
		t.append("#%d %-7s %5.1f %5.1f %5.1f  err %s" % [i + 1, name, s[0], s[1], s[2],
			("%.1f" % b.err) if b.match != "" else "-"])
		var h: Array = _hist.get(b.key, [])
		if h.size() > 5:
			var sd := _jitter(h)
			t.append("   jitter %.2f %.2f %.2f   rot %.0f°" % [sd[0], sd[1], sd[2], b.angle])
	for i in names.size():
		if names[i] != "UNKNOWN" and names.count(names[i]) > 1:
			t.append("!! %s detected twice - boards too similar?" % names[i])
			break
	t.append("")
	t.append("---- recorded boards ----")
	for s in SLOTS:
		if _patterns.has(s):
			var g: Array = _patterns[s]["sig"]
			t.append("%-6s %5.1f %5.1f %5.1f" % [s, g[0], g[1], g[2]])
	t.append("")
	t.append("---- separation (want > 2 x tol) ----")
	var keys := _patterns.keys()
	for i in keys.size():
		for j in range(i + 1, keys.size()):
			var e := _err(_patterns[keys[i]]["sig"], _patterns[keys[j]]["sig"])
			t.append("%-6s vs %-6s %5.1f  %s" % [keys[i], keys[j], e, "OK" if e > 2.0 * _tol.value else "TOO CLOSE"])
	t.append("")
	t.append("---- log ----")
	for line in _log:
		t.append(line)
	_info.text = "\n".join(t)


func _jitter(hist: Array) -> Array[float]:
	var out: Array[float] = []
	for i in 3:
		var mean := 0.0
		for h in hist:
			mean += float(h[i])
		mean /= hist.size()
		var v := 0.0
		for h in hist:
			v += pow(float(h[i]) - mean, 2)
		out.append(sqrt(v / hist.size()))
	return out


# ----------------------------------------------------------- helpers ------

func _mm() -> float:
	return _width_mm.value / _vw()

func _vw() -> float:
	return get_viewport_rect().size.x

func _vh() -> float:
	return get_viewport_rect().size.y

func _add_log(s: String) -> void:
	_log.push_front("%s %s" % [Time.get_time_string_from_system(), s])
	if _log.size() > 12:
		_log.pop_back()

func _toggle_fullscreen() -> void:
	var w := get_window()
	w.mode = Window.MODE_WINDOWED if w.mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN

func _back() -> void:
	get_window().mode = Window.MODE_WINDOWED
	get_tree().change_scene_to_file("res://scenes/ui/launcher.tscn")
