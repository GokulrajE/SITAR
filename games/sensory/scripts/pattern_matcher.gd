extends RefCounted
static func outline(points: Array[Vector2]) -> Array[Vector2]:
	var result: Array[Vector2] = []
	if points.size() < 3:
		result.assign(points)
		return result
	var hull := Geometry2D.convex_hull(PackedVector2Array(points))
	if hull.size() > 1: hull.remove_at(hull.size()-1)
	result.assign(hull)
	return result

static func matches_contacts(reference: Array[Vector2], contacts: Array[Vector2]) -> bool:
	if contacts.size() != reference.size(): return false
	var a := outline(reference)
	var b := outline(contacts)
	if a.size() != reference.size() or b.size() != contacts.size(): return false
	return matches(a,b,true)
## Position and uniform size do not matter; proportions and orientation do.
static func matches(reference: Array[Vector2], drawn: Array[Vector2], closed: bool) -> bool:
	if reference.size() != drawn.size() or drawn.size() < 3: return false
	for i in drawn.size():
		for j in range(i+1,drawn.size()):
			if drawn[i].distance_to(drawn[j]) < 24.0: return false
	var a := normalize(reference)
	var b := normalize(drawn)
	if a.is_empty() or b.is_empty(): return false
	for direction in [1,-1]:
		for shift in (drawn.size() if closed else 1):
			var sum := 0.0
			var worst := 0.0
			for i in a.size():
				var index: int = posmod(shift + direction*i, b.size()) if closed else (i if direction == 1 else b.size()-1-i)
				var error := a[i].distance_to(b[index])
				sum += error*error
				worst = maxf(worst,error)
			if sqrt(sum/a.size()) <= 0.18 and worst <= 0.30: return true
	return false

static func normalize(points: Array[Vector2]) -> Array[Vector2]:
	var center := Vector2.ZERO
	for point in points: center += point
	center /= points.size()
	var radius := 0.0
	for point in points: radius += point.distance_squared_to(center)
	radius = sqrt(radius/points.size())
	var result: Array[Vector2] = []
	if radius < 50.0: return result
	for point in points: result.append((point-center)/radius)
	return result
