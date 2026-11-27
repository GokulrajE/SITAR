extends Node
## Turns raw IR-frame contacts into "board A was placed / lifted" events.
##
## Built for a noisy frame:
##   * a board counts as placed after it has been recognised for CONFIRM seconds
##   * a board stays placed while one leg flickers out (two legs still down)
##   * contacts that never got their "up" are replaced, not duplicated
##   * every board can only be on the screen once
##   * short single-finger taps are reported separately, so a caregiver can
##     press on-screen choices next to a standing board

signal placed(board: String, centre: Vector2)
signal lifted(board: String)
signal tapped(position: Vector2)
signal unsure(centre: Vector2)          # something stands there but no board fits

const CONFIRM := 0.30
const CANDIDATE_GAP := 0.25
const HOLD_TWO_LEGS := 6.0
const HOLD_ONE_LEG := 0.9
const HOLD_NO_LEGS := 0.45
const LEG_NEAR_MM := 10.0
const SAME_CONTACT_MM := 3.0
const TAP_MAX := 1.5
const TAP_ALONE_MM := 60.0
const UNSURE_AFTER := 1.5
const MAX_CONTACTS := 12

var lib                                  # PegLibrary
var present: Dictionary = {}             # board -> {"centre", "angle", "legs", "err"}
var area := Rect2(-1e6, -1e6, 2e6, 2e6)  # contacts outside are ignored
var ignore: Array[Rect2] = []            # zones inside the area that never count

var _contacts: Dictionary = {}           # touch index -> {"pos", "at", "alone", "from"}
var _candidates: Dictionary = {}         # board -> {"since", "last"}
var _t := 0.0
var _real_touch_seen := false
var _unsure_since := -1.0
var _unsure_sent := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		reset()                          # Windows sends no "up" after a focus loss


func reset() -> void:
	_contacts.clear()
	_candidates.clear()
	for b in present.keys():
		present.erase(b)
		lifted.emit(b)


func mm_per_px() -> float:
	return lib.width_mm / get_viewport().get_visible_rect().size.x

func px(mm: float) -> float:
	return mm / mm_per_px()

func points() -> Array[Vector2]:
	var out: Array[Vector2] = []
	for c in _contacts.values():
		out.append(c.pos)
	return out


# ------------------------------------------------------------ input -------

func _input(e: InputEvent) -> void:
	if e is InputEventScreenTouch:
		# Windows also sends every first touch as a mouse click, which Godot turns
		# back into a touch. Once a real touch frame is seen, ignore those copies.
		if e.device == InputEvent.DEVICE_ID_EMULATION:
			if _real_touch_seen:
				return
		else:
			_real_touch_seen = true
		if e.pressed:
			_down(e.index, e.position)
		else:
			_up(e.index)
	elif e is InputEventScreenDrag:
		if e.device == InputEvent.DEVICE_ID_EMULATION and _real_touch_seen:
			return
		if _contacts.has(e.index):
			_contacts[e.index].pos = e.position


func _down(id: int, pos: Vector2) -> void:
	_contacts.erase(id)
	if not counts(pos):
		return
	var k := mm_per_px()
	var alone := true
	for other in _contacts.keys():
		var d: float = _contacts[other].pos.distance_to(pos) * k
		if d < SAME_CONTACT_MM:
			_contacts.erase(other)       # a stuck contact under the new one
		elif d < TAP_ALONE_MM:
			alone = false
			_contacts[other].alone = false
	if _contacts.size() >= MAX_CONTACTS:
		_contacts.erase(_contacts.keys()[0])
	_contacts[id] = {"pos": pos, "from": pos, "at": _t, "alone": alone}


## True when a contact at pos is inside the area and not in an ignored zone.
func counts(pos: Vector2) -> bool:
	if not area.has_point(pos):
		return false
	for r in ignore:
		if r.has_point(pos):
			return false
	return true


func _up(id: int) -> void:
	if not _contacts.has(id):
		return
	var c: Dictionary = _contacts[id]
	_contacts.erase(id)
	if c.alone and _t - float(c.at) < TAP_MAX and c.from.distance_to(c.pos) < 40.0:
		tapped.emit(c.pos)


# ------------------------------------------------------ recognition -------

func _process(delta: float) -> void:
	update(delta)


func update(delta: float) -> void:
	_t += delta
	if lib == null:
		return
	var found := _find_boards()
	var k := mm_per_px()

	for b in found:
		var f: Dictionary = found[b]
		if present.has(b):
			present[b] = f
			present[b]["seen"] = _t
			continue
		var c: Dictionary = _candidates.get(b, {"since": _t, "last": _t})
		if _t - float(c.last) > CANDIDATE_GAP:
			c.since = _t
		c.last = _t
		_candidates[b] = c
		if _t - float(c.since) >= CONFIRM:
			_candidates.erase(b)
			f["seen"] = _t
			present[b] = f
			placed.emit(b, f.centre)

	for b in present.keys():
		if found.has(b) or not present.has(b):
			continue
		var legs_down := 0
		for leg: Vector2 in present[b].legs:
			for c in _contacts.values():
				if c.pos.distance_to(leg) * k < LEG_NEAR_MM:
					legs_down += 1
					break
		var hold: float = [HOLD_NO_LEGS, HOLD_ONE_LEG, HOLD_TWO_LEGS, HOLD_TWO_LEGS][legs_down]
		if _t - float(present[b].seen) > hold:
			present.erase(b)
			lifted.emit(b)

	_check_unsure(found, k)


## Best set of boards, each used at most once and sharing no contact.
func _find_boards() -> Dictionary:
	var ids: Array = _contacts.keys()
	var k := mm_per_px()
	var options: Dictionary = {}         # board -> Array of candidates
	for i in ids.size():
		for j in range(i + 1, ids.size()):
			if _contacts[ids[i]].pos.distance_to(_contacts[ids[j]].pos) * k > 70.0:
				continue
			for m in range(j + 1, ids.size()):
				var legs: Array[Vector2] = [_contacts[ids[i]].pos, _contacts[ids[j]].pos, _contacts[ids[m]].pos]
				var r: Array = lib.identify(legs, k)
				if r.is_empty():
					continue
				if not options.has(r[0]):
					options[r[0]] = []
				options[r[0]].append({"ids": [ids[i], ids[j], ids[m]], "err": r[1], "angle": r[2],
					"legs": legs, "centre": (legs[0] + legs[1] + legs[2]) / 3.0})
	var best := {"count": 0, "cost": INF, "pick": {}}
	_choose(options, options.keys(), 0, {}, {}, 0.0, best)
	return best.pick


func _choose(options: Dictionary, names: Array, n: int, pick: Dictionary, used: Dictionary, cost: float, best: Dictionary) -> void:
	if n == names.size():
		if pick.size() > best.count or (pick.size() == best.count and cost < best.cost):
			best.count = pick.size()
			best.cost = cost
			best.pick = pick.duplicate()
		return
	_choose(options, names, n + 1, pick, used, cost, best)
	for o in options[names[n]]:
		if o.ids.any(func(id): return used.has(id)):
			continue
		for id in o.ids:
			used[id] = true
		pick[names[n]] = o
		_choose(options, names, n + 1, pick, used, cost + float(o.err), best)
		pick.erase(names[n])
		for id in o.ids:
			used.erase(id)


func _check_unsure(found: Dictionary, k: float) -> void:
	var left: Array[Vector2] = []
	for c in _contacts.values():
		var near := false
		for b in present:
			if c.pos.distance_to(present[b].centre) * k < 45.0:
				near = true
		for b in found:
			if c.pos.distance_to(found[b].centre) * k < 45.0:
				near = true
		if not near:
			left.append(c.pos)
	var pair := false
	for i in left.size():
		for j in range(i + 1, left.size()):
			if left[i].distance_to(left[j]) * k < 70.0:
				pair = true
	if not pair:
		_unsure_since = -1.0
		_unsure_sent = false
		return
	if _unsure_since < 0.0:
		_unsure_since = _t
	elif not _unsure_sent and _t - _unsure_since > UNSURE_AFTER:
		_unsure_sent = true
		var c := Vector2.ZERO
		for p in left:
			c += p
		unsure.emit(c / left.size())
