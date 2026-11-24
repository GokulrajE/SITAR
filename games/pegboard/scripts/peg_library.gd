extends RefCounted
## What the pegboard games know about the physical boards:
##   * the leg triangle of every board (from pegboard/build_pegboards_freecad.py)
##   * which object the caregiver screwed onto each board
##   * the real width of the screen, which turns pixels into millimetres
##
## Saved in user://peg_objects.json. The touch tester's own recordings
## (user://peg_patterns.json) are never touched.

const SAVE_PATH := "user://peg_objects.json"
const LOG_PATH := "user://peg_match_log.jsonl"
const TOLERANCE_MM := 5.0          # boards differ by >= 10.9 mm
const MARGIN_MM := 1.0             # the best board must beat the second best by this
const DEFAULT_WIDTH_MM := 920.0

## Leg centres in mm, seen from above, Y up (same numbers as the FreeCAD file).
const DESIGN := {
	"A": [Vector2(-18.5, -19.5), Vector2(-2.5, 22.5), Vector2(15.0, -2.5)],
	"B": [Vector2(22.5, 20.0), Vector2(-30.0, -3.0), Vector2(16.5, -22.5)],
	"C": [Vector2(4.0, -30.0), Vector2(-14.5, 10.0), Vector2(13.5, 25.5)],
}

## The objects that screw onto the boards. "clue" is used by the Clues level.
const OBJECTS := {
	"cup": {"name": "Cup", "clue": "You can drink from it.", "color": Color("ff8a65")},
	"cone": {"name": "Cone", "clue": "It is wide at the bottom and narrow at the top.", "color": Color("ffca28")},
	"cylinder": {"name": "Cylinder", "clue": "It is tall and round, like a small pillar.", "color": Color("4fc3f7")},
	"square": {"name": "Square block", "clue": "It has four flat sides and corners.", "color": Color("81c784")},
	"ball_holder": {"name": "Ball holder", "clue": "A ball can rest on top of it.", "color": Color("ba68c8")},
	"bottle_holder": {"name": "Bottle holder", "clue": "It keeps a bottle standing upright.", "color": Color("f06292")},
}

## Automated tests set this false so real settings are never overwritten.
static var persist := true

var width_mm := DEFAULT_WIDTH_MM
var assigned: Dictionary = {"A": "", "B": "", "C": ""}   # board -> object id ("" = none)
var _shapes: Dictionary = {}                             # board -> {"sig", "angle", "turn"}


func _init() -> void:
	for b in DESIGN:
		var legs: Array[Vector2] = []
		for p: Vector2 in DESIGN[b]:
			legs.append(Vector2(p.x, -p.y))              # screen Y points down
		_shapes[b] = describe(legs)
	if persist:
		_load()


## Rotation-invariant description of a 3-leg triangle: sorted sides, winding
## (a board cannot be flipped over, so a mirrored triangle is not the board)
## and the heading used to read the rotation.
static func describe(p: Array[Vector2]) -> Dictionary:
	var opp: Array = []                                   # [side length, opposite leg]
	for i in 3:
		opp.append([p[(i + 1) % 3].distance_to(p[(i + 2) % 3]), p[i]])
	opp.sort_custom(func(a, b): return a[0] < b[0])
	var s: Vector2 = opp[0][1]
	var m: Vector2 = opp[1][1]
	var l: Vector2 = opp[2][1]
	return {
		"sig": [opp[0][0], opp[1][0], opp[2][0]],
		"turn": signf((m - s).cross(l - s)),
		"angle": (l - s).angle(),
	}


## Compares a triangle in PIXELS with board b. Returns the worst side error in mm.
func error_mm(d: Dictionary, b: String, mm_per_px: float) -> float:
	var r: Dictionary = _shapes[b]
	if d.turn != r.turn:
		return INF
	var e := 0.0
	for i in 3:
		e = maxf(e, absf(float(d.sig[i]) * mm_per_px - float(r.sig[i])))
	return e


## Returns ["A", error, rotation] or [] when no board fits clearly.
func identify(p: Array[Vector2], mm_per_px: float) -> Array:
	var d := describe(p)
	var best := ""
	var e1 := INF
	var e2 := INF
	for b in _shapes:
		var e := error_mm(d, b, mm_per_px)
		if e < e1:
			e2 = e1
			e1 = e
			best = b
		elif e < e2:
			e2 = e
	if e1 > TOLERANCE_MM or e2 - e1 < MARGIN_MM:
		return []
	return [best, e1, wrapf(float(d.angle) - float(_shapes[best].angle), -PI, PI)]


## With boards A, B and C all standing on the glass, finds the screen width that
## makes their sides come out right. Returns {} or {"width", "error"}.
func measure_screen(points: Array[Vector2], view_width_px: float) -> Dictionary:
	if points.size() != 9:
		return {}
	var best := {"cost": INF}
	var all: Array[int] = []
	all.assign(range(9))
	for i in range(1, 8):
		for j in range(i + 1, 9):
			var rest := all.filter(func(n): return n != 0 and n != i and n != j)
			for k in range(1, 5):
				for m in range(k + 1, 6):
					var third := rest.filter(func(n): return n != rest[0] and n != rest[k] and n != rest[m])
					_try_scale(points, [[0, i, j], [rest[0], rest[k], rest[m]], third], best)
	if best.cost > 2.5:
		return {}
	return {"width": best.scale * view_width_px, "error": best.cost}


func _try_scale(points: Array[Vector2], groups: Array, best: Dictionary) -> void:
	var ds: Array = []
	for g in groups:
		var t: Array[Vector2] = [points[g[0]], points[g[1]], points[g[2]]]
		ds.append(describe(t))
	for order in [["A", "B", "C"], ["A", "C", "B"], ["B", "A", "C"], ["B", "C", "A"], ["C", "A", "B"], ["C", "B", "A"]]:
		var dot := 0.0
		var sq := 0.0
		var ok := true
		for n in 3:
			var r: Dictionary = _shapes[order[n]]
			if ds[n].turn != r.turn:
				ok = false
				break
			for s in 3:
				dot += float(ds[n].sig[s]) * float(r.sig[s])
				sq += float(ds[n].sig[s]) * float(ds[n].sig[s])
		if not ok or sq <= 0.0:
			continue
		var scale := dot / sq                              # mm per px
		var sum := 0.0
		for n in 3:
			for s in 3:
				sum += pow(float(ds[n].sig[s]) * scale - float(_shapes[order[n]].sig[s]), 2)
		var cost := sqrt(sum / 9.0)
		if cost < best.cost:
			best.cost = cost
			best.scale = scale


# ---------------------------------------------------------- objects -------

func object_of(board: String) -> String:
	return assigned.get(board, "")

func board_of(object: String) -> String:
	for b in assigned:
		if assigned[b] == object:
			return b
	return ""

func objects() -> Array[String]:
	var out: Array[String] = []
	for b in assigned:
		if assigned[b] != "":
			out.append(assigned[b])
	return out

## Puts an object on a board. Returns the board it was taken from, or "".
func assign(board: String, object: String) -> String:
	var from := board_of(object)
	if from == board:
		from = ""
	elif from != "":
		assigned[from] = ""
	assigned[board] = object
	save()
	return from

static func name_of(object: String) -> String:
	return OBJECTS[object].name if OBJECTS.has(object) else ""

static func color_of(object: String) -> Color:
	return OBJECTS[object].color if OBJECTS.has(object) else Color.GRAY


# ------------------------------------------------------------- disk -------

func save() -> void:
	if not persist:
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"width_mm": width_mm, "objects": assigned}, "\t"))

func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var d: Variant = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if not d is Dictionary:
		return
	width_mm = clampf(float(d.get("width_mm", width_mm)), 200.0, 3000.0)
	var o: Variant = d.get("objects", {})
	if o is Dictionary:
		for b in assigned:
			var id := str(o.get(b, ""))
			assigned[b] = id if OBJECTS.has(id) else ""

## Appends one finished session (one JSON object per line).
static func log_session(entry: Dictionary) -> void:
	if not persist:
		return
	var f := FileAccess.open(LOG_PATH, FileAccess.READ_WRITE if FileAccess.file_exists(LOG_PATH) else FileAccess.WRITE)
	if f:
		f.seek_end()
		f.store_line(JSON.stringify(entry))
