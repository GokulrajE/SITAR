extends RefCounted
## What the pegboard games know about the physical boards. Nothing is fixed:
## each board's leg triangle is RECORDED on this screen during set-up, together
## with the object the caregiver screwed onto it. Record again whenever the
## boards or objects change ("Start fresh" in set-up forgets everything).
##
##   * up to three recorded boards, kept in the slots "A", "B", "C"
##   * per slot: the object and the recorded leg positions in screen pixels
##   * the screen width, which turns pixels into millimetres for the tolerances
##
## Saved in user://peg_objects.json. The touch tester's own recordings
## (user://peg_patterns.json) are never touched.

const SAVE_PATH := "user://peg_objects.json"
const LOG_PATH := "user://peg_match_log.jsonl"
const TOLERANCE_MM := 5.0          # a placement may differ this much from its recording
const MARGIN_MM := 1.0             # the best board must beat the second best by this
const CLASH_MM := 2.0 * TOLERANCE_MM + MARGIN_MM   # two recordings must differ this much
const MIN_SIDE_MM := 12.0
const MAX_SIDE_MM := 70.0
const DEFAULT_WIDTH_MM := 920.0
const SLOTS := ["A", "B", "C"]

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
var assigned: Dictionary = {"A": "", "B": "", "C": ""}   # slot -> object id ("" = empty)
var legs: Dictionary = {}                                # slot -> recorded legs (pixels)
var _shapes: Dictionary = {}                             # slot -> {"sig", "angle", "turn"}


func _init() -> void:
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


## Compares a triangle with the recording in slot b (both in pixels). Worst side error in mm.
func error_mm(d: Dictionary, b: String, mm_per_px: float) -> float:
	var r: Dictionary = _shapes[b]
	if d.turn != r.turn:
		return INF
	var e := 0.0
	for i in 3:
		e = maxf(e, absf(float(d.sig[i]) - float(r.sig[i])) * mm_per_px)
	return e


## Returns ["A", error, rotation] or [] when no recorded board fits clearly.
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
	if best == "" or e1 > TOLERANCE_MM or e2 - e1 < MARGIN_MM:
		return []
	return [best, e1, wrapf(float(d.angle) - float(_shapes[best].angle), -PI, PI)]


# --------------------------------------------------------- recording ------

## Records the legs of the board that carries `object`.
## Returns {"slot": "A"} on success, or {"error": "...", ...} explaining why not:
##   "size"  - the legs are too close together or too far apart to be one board
##   "clash" - too much like the recorded board of {"object"}; it would be confused
##   "full"  - three boards are already recorded; forget one first
func record(object: String, p: Array[Vector2], mm_per_px: float) -> Dictionary:
	if not OBJECTS.has(object) or p.size() != 3:
		return {"error": "size"}
	var d := describe(p)
	for side in d.sig:
		var mm := float(side) * mm_per_px
		if mm < MIN_SIDE_MM or mm > MAX_SIDE_MM:
			return {"error": "size"}
	# The same object or the same physical board recorded again replaces that slot.
	var slot := board_of(object)
	var same: Array = identify(p, mm_per_px)
	if slot == "" and not same.is_empty():
		slot = same[0]
	for b in _shapes:
		if b != slot and error_mm(d, b, mm_per_px) < CLASH_MM:
			return {"error": "clash", "object": assigned[b]}
	if slot == "":
		for b in SLOTS:
			if not _shapes.has(b):
				slot = b
				break
	if slot == "":
		return {"error": "full"}
	var from := board_of(object)
	if from != "" and from != slot:
		forget(from)
	assigned[slot] = object
	legs[slot] = p.duplicate()
	_shapes[slot] = d
	save()
	return {"slot": slot}


func forget(slot: String) -> void:
	assigned[slot] = ""
	legs.erase(slot)
	_shapes.erase(slot)
	save()


## Forgets every recording, so all boards are recorded fresh.
func clear() -> void:
	for b in SLOTS:
		assigned[b] = ""
	legs.clear()
	_shapes.clear()
	save()


# ---------------------------------------------------------- objects -------

func object_of(board: String) -> String:
	return assigned.get(board, "")

func board_of(object: String) -> String:
	if object == "":
		return ""
	for b in assigned:
		if assigned[b] == object:
			return b
	return ""

func objects() -> Array[String]:
	var out: Array[String] = []
	for b in SLOTS:
		if assigned[b] != "" and _shapes.has(b):
			out.append(assigned[b])
	return out

static func name_of(object: String) -> String:
	return OBJECTS[object].name if OBJECTS.has(object) else ""

static func color_of(object: String) -> Color:
	return OBJECTS[object].color if OBJECTS.has(object) else Color.GRAY


# ------------------------------------------------------------- disk -------

func save() -> void:
	if not persist:
		return
	var boards := {}
	for b in legs:
		var pts := []
		for p: Vector2 in legs[b]:
			pts.append([snappedf(p.x, 0.01), snappedf(p.y, 0.01)])
		boards[b] = {"object": assigned[b], "legs": pts}
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"width_mm": width_mm, "boards": boards}, "\t"))

## Older files (fixed board designs, "objects" only) hold no recordings and are ignored.
func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var d: Variant = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if not d is Dictionary:
		return
	width_mm = clampf(float(d.get("width_mm", width_mm)), 200.0, 3000.0)
	var boards: Variant = d.get("boards", {})
	if not boards is Dictionary:
		return
	for b in SLOTS:
		var e: Variant = boards.get(b)
		if not e is Dictionary or not OBJECTS.has(str(e.get("object", ""))):
			continue
		var raw: Variant = e.get("legs", [])
		if not raw is Array or raw.size() != 3:
			continue
		var pts: Array[Vector2] = []
		for q in raw:
			pts.append(Vector2(float(q[0]), float(q[1])))
		assigned[b] = str(e.object)
		legs[b] = pts
		_shapes[b] = describe(pts)

## Appends one finished session (one JSON object per line).
static func log_session(entry: Dictionary) -> void:
	if not persist:
		return
	var f := FileAccess.open(LOG_PATH, FileAccess.READ_WRITE if FileAccess.file_exists(LOG_PATH) else FileAccess.WRITE)
	if f:
		f.seek_end()
		f.store_line(JSON.stringify(entry))
