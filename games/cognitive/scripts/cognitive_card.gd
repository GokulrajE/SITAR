extends Button
## Menu card: a window into the game's world with its host, title and one line.
const Art = preload("res://games/cognitive/scripts/cognitive_art.gd")

@export var mode := 0
@export var heading := ""
@export_multiline var line := ""
var chosen := false
@onready var host: Node2D = $Host


func _ready() -> void:
	host.setup(Art.GAMES[mode], 470.0 if mode == 1 else 430.0)
	$Heading.text = heading
	$Line.text = line
	pivot_offset = size * 0.5


func choose(value: bool) -> void:
	chosen = value
	queue_redraw()


func advance(delta: float) -> void:
	host.advance(delta)
	var goal := 1.0 if chosen else 0.93
	scale = scale.lerp(Vector2.ONE * goal, 1.0 - exp(-10.0 * delta))
	modulate = modulate.lerp(Color.WHITE if chosen else Color(0.86, 0.86, 0.84), 1.0 - exp(-10.0 * delta))


func _draw() -> void:
	if chosen:
		draw_style_box(preload("res://assets/themes/card_chosen.tres"), Rect2(Vector2(6, 8), size - Vector2(12, 14)))
	var window: Rect2 = Rect2($Window.position, $Window.size)
	draw_texture_rect_region(Art.texture("%s/%s_1" % [Art.GAMES[mode].dir, Art.GAMES[mode].bg]),
		window, Rect2(120, 100, 1000 * window.size.x / window.size.y * 0.9, 900))
