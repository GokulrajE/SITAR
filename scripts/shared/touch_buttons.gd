extends RefCounted
## With emulate_mouse_from_touch off, a real finger does not press buttons.
## Scenes call this from _input.


static func is_finger_down(event: InputEvent) -> bool:
	return event is InputEventScreenTouch and event.pressed and event.device != InputEvent.DEVICE_ID_EMULATION


## The visible, enabled button under a point, topmost first.
static func button_at(node: Node, point: Vector2) -> BaseButton:
	var children := node.get_children()
	children.reverse()
	for child in children:
		if child is CanvasItem and not child.visible: continue
		var found := button_at(child, point)
		if found: return found
		if child is BaseButton and not child.disabled and child.get_global_rect().has_point(point): return child
	return null


static func press(button: BaseButton) -> void:
	if button.toggle_mode: button.button_pressed = not button.button_pressed
	else: button.pressed.emit()
