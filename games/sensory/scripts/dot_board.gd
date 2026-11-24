extends Control
signal matched
signal drawing_changed
signal live_status(message: String)
var live_contacts := false
var free_copy := false
var drawn: Array[Vector2] = []
var touch_vertices: Dictionary = {}
var targets: Array[Vector2] = []
var touches: Dictionary = {}
var selected: Array[int] = []
var simultaneous := false
var enabled := true
var solved := false
var hold := 0.0
var picture: Texture2D
var motion := true
var phase := 0.0
var closed := false
const RADIUS := 48.0

func configure(points: Array, texture: Texture2D, multi: bool, close_path: bool = false, blank: bool = false, live: bool = false) -> void:
	targets.assign(points)
	picture = texture
	simultaneous = multi
	closed = close_path
	free_copy = blank
	live_contacts = live
	clear()

func clear() -> void:
	touches.clear()
	selected.clear()
	drawn.clear()
	touch_vertices.clear()
	hold = 0.0
	solved = false
	queue_redraw()

func occupied() -> Array[int]:
	var result: Array[int] = []
	for pos: Vector2 in touches.values():
		var closest := -1
		var distance := RADIUS
		for i in targets.size():
			var d := pos.distance_to(targets[i])
			if d < distance:
				distance = d
				closest = i
		if closest >= 0 and not result.has(closest):
			result.append(closest)
	return result

func tap(pos: Vector2) -> void:
	if not enabled or solved or simultaneous:
		return
	if free_copy:
		add_vertex(pos)
		return
	var index := selected.size()
	if index < targets.size() and pos.distance_to(targets[index]) <= RADIUS:
		selected.append(index)
		if selected.size() == targets.size():
			solved = true
			matched.emit()
	queue_redraw()

func add_vertex(pos: Vector2) -> int:
	if not Rect2(660,30,1110,540).has_point(pos) or drawn.size() >= targets.size(): return -1
	for point in drawn:
		if point.distance_to(pos) < 24: return -1
	drawn.append(pos)
	drawing_changed.emit()
	queue_redraw()
	return drawn.size()-1

func undo() -> void:
	if not free_copy or not enabled or solved or drawn.is_empty(): return
	drawn.pop_back()
	touch_vertices.clear()
	drawing_changed.emit()
	queue_redraw()

func check_drawing() -> bool:
	if not free_copy or not enabled or solved: return false
	var correct := preload("res://games/sensory/scripts/pattern_matcher.gd").matches(targets,drawn,closed)
	if correct:
		solved = true
		matched.emit()
	queue_redraw()
	return correct

func _input(event: InputEvent) -> void:
	if not enabled or not visible or solved:
		return
	if live_contacts:
		if event is InputEventScreenTouch:
			if event.pressed:
				var point: Vector2 = get_global_transform_with_canvas().affine_inverse()*event.position
				if Rect2(660,30,1110,540).has_point(point): touches[event.index] = point
			else: touches.erase(event.index)
		elif event is InputEventScreenDrag and touches.has(event.index):
			touches[event.index] = get_global_transform_with_canvas().affine_inverse()*event.position
		queue_redraw()
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			var pos: Vector2 = get_global_transform_with_canvas().affine_inverse() * event.position
			if get_rect().has_point(pos + position):
				touches[event.index] = pos
				if free_copy:
					var vertex := add_vertex(pos)
					if vertex >= 0: touch_vertices[event.index] = vertex
				else: tap(pos)
		else:
			touches.erase(event.index)
			touch_vertices.erase(event.index)
	elif event is InputEventScreenDrag and touches.has(event.index):
		touches[event.index] = get_global_transform_with_canvas().affine_inverse() * event.position
		if free_copy and touch_vertices.has(event.index):
			var point: Vector2 = touches[event.index]
			if Rect2(660,30,1110,540).has_point(point):
				drawn[touch_vertices[event.index]] = point
				drawing_changed.emit()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and event.device != InputEvent.DEVICE_ID_EMULATION:
		tap(get_local_mouse_position())
	queue_redraw()

func _process(delta: float) -> void:
	if not enabled or not visible:
		return
	if motion:
		phase += delta
	if live_contacts and not solved:
		var contacts: Array[Vector2] = []
		contacts.assign(touches.values())
		drawn = preload("res://games/sensory/scripts/pattern_matcher.gd").outline(contacts)
		var in_bounds := true
		for point in contacts:
			if not Rect2(660,30,1110,540).has_point(point): in_bounds = false
		if in_bounds and preload("res://games/sensory/scripts/pattern_matcher.gd").matches_contacts(targets,contacts):
			hold += delta
			live_status.emit("Matching! Hold your fingers still for a moment.")
			if hold >= 0.65:
				solved = true
				matched.emit()
		else:
			hold = 0.0
			if contacts.size() != targets.size():
				live_status.emit("%d / %d contacts. Keep one finger down for each corner." % [contacts.size(),targets.size()])
			else: live_status.emit("Not a match yet. Move your fingers to copy the shape.")
	if simultaneous and not solved:
		if occupied().size() == targets.size() and touches.size() == targets.size():
			hold += delta
			if hold >= 0.65:
				solved = true
				matched.emit()
		else:
			hold = 0.0
	queue_redraw()

func _draw() -> void:
	var font := ThemeDB.fallback_font
	draw_style_box(_panel(Color("e4eee7")), Rect2(0,0,600,600))
	draw_style_box(_panel(Color.WHITE), Rect2(630,0,1170,600))
	if free_copy or live_contacts:
		draw_copy()
		return
	if picture:
		draw_texture_rect(picture,Rect2(90,35,420,380),false)
	elif not targets.is_empty():
		var preview := PackedVector2Array()
		for point in targets: preview.append(Vector2(85,70)+(point-Vector2(870,85))*Vector2(0.68,0.72))
		if closed: preview.append(preview[0])
		draw_polyline(preview,Color("25867d"),9,true)
		for point in preview: draw_circle(point,10,Color("db9650"))
	draw_string(font,Vector2(45,460),"LOOK AT THE PATTERN",HORIZONTAL_ALIGNMENT_LEFT,-1,25,Color("244d4a"))
	var active := occupied() if simultaneous else selected
	# Paint every edge first so it cannot cover a target's number.
	for i in targets.size():
		if i == 0 and not closed: continue
		var previous: int = (i-1+targets.size()) % targets.size()
		draw_line(targets[previous],targets[i],Color("dce8e4"),6,true)
		if (active.has(i) and active.has(previous)) or solved:
			draw_line(targets[previous],targets[i],Color("25867d"),9,true)
	for i in targets.size():
		var p := targets[i]
		var small := Vector2(170,475) + (p-Vector2(850,100))*0.27
		if i > 0:
			var previous := Vector2(170,475)+(targets[i-1]-Vector2(850,100))*0.27
			draw_line(previous,small,Color("25867d"),4,true)
		draw_circle(small,8,Color("25867d"))
		var color := Color("25867d") if active.has(i) or solved else Color("db9650")
		var pulse := 3.0*sin(phase*2.0) if motion and not solved else 0.0
		draw_circle(p,44+pulse,Color(color,0.12))
		draw_circle(p,30,color)
		draw_string(font,p+Vector2(-9,10),str(i+1),HORIZONTAL_ALIGNMENT_LEFT,-1,28,Color.WHITE)
	for pos: Vector2 in touches.values():
		draw_arc(pos,52,0,TAU,48,Color("365f9c"),3,true)
	if solved:
		draw_string(font,Vector2(850,560),"PATTERN COMPLETE",HORIZONTAL_ALIGNMENT_LEFT,-1,30,Color("25867d"))
		if motion:
			for i in 12:
				var angle := float(i)*TAU/12.0
				var center := Vector2(1200,300)
				var radius := 220.0+8.0*sin(phase*1.6+float(i))
				draw_circle(center+Vector2(cos(angle),sin(angle))*radius,5,Color("d7aa50"))
	if closed and targets.size() > 1:
		draw_line(Vector2(170,475)+(targets[-1]-Vector2(850,100))*0.27,Vector2(170,475)+(targets[0]-Vector2(850,100))*0.27,Color("25867d"),4,true)

func _panel(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(30)
	return style

func draw_copy() -> void:
	var font := ThemeDB.fallback_font
	draw_string(font,Vector2(40,55),"COPY THIS PATTERN",HORIZONTAL_ALIGNMENT_LEFT,-1,26,Color("244d4a"))
	var preview: Array[Vector2] = []
	for point in targets: preview.append(Vector2(85,160)+(point-Vector2(870,85))*0.65)
	draw_path(preview,closed,Color("25867d"))
	var hint := "Hold %d fingers. Any touch order." % targets.size() if live_contacts else "Place %d dots in the same order." % targets.size()
	draw_string(font,Vector2(40,535),hint,HORIZONTAL_ALIGNMENT_LEFT,-1,24,Color("244d4a"))
	draw_path(drawn,closed and drawn.size()==targets.size(),Color("25867d") if solved else Color("365f9c"))
	if solved:
		draw_string(font,Vector2(1000,570),"CORRECT MATCH",HORIZONTAL_ALIGNMENT_LEFT,-1,28,Color("25867d"))

func draw_path(points: Array[Vector2], close_path: bool, color: Color) -> void:
	if points.size() > 1:
		var line := PackedVector2Array(points)
		if close_path: line.append(points[0])
		draw_polyline(line,color,6,true)
	for i in points.size():
		draw_circle(points[i],25,color)
		draw_string(ThemeDB.fallback_font,points[i]+Vector2(-8,9),str(i+1),HORIZONTAL_ALIGNMENT_LEFT,-1,25,Color.WHITE)
