extends Node2D
## Row of stars: one for each step of the melody, filled as steps are heard or played.
const Art = preload("res://games/cognitive/scripts/cognitive_art.gd")

const SIDE := 58.0
const GAP := 70.0
var total := 0
var filled := 0


func show_steps(count: int, done: int) -> void:
	if count == total and done == filled: return
	total = count
	filled = done
	queue_redraw()


func _draw() -> void:
	if total == 0: return
	var sheet := Art.texture("shared/ui_icons_4x4")
	var width := (total - 1) * GAP + 100.0
	draw_style_box(preload("res://assets/themes/steps_back.tres"), Rect2(-width * 0.5, -40, width, 80))
	for i in total:
		var at := Vector2((i - (total - 1) * 0.5) * GAP, 0)
		draw_texture_rect_region(sheet, Rect2(at - Vector2.ONE * SIDE * 0.5, Vector2.ONE * SIDE),
			Art.cell(7 if i < filled else 8, 256.0))
