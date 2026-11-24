extends Node2D
## One stand-alone burner: stove + animated fire + tawa. Instanced 6× in
## dosa_game.tscn so each dosa cooks on its own station instead of sharing
## one giant shared tawa.

## Flame ring whose 32 tongues extend past the tawa's own diameter — scaled
## 1:1 with the tawa (not the stove) so they peek out around its perimeter.
const P_FIRE := "res://assets/images/dosa_wide_rim_fire_pngs/15_wide_tawa_rim_fire_4x4.png"

@onready var _fire: AnimatedSprite2D = $Fire

func _ready() -> void:
	if _fire.sprite_frames == null:
		_fire.sprite_frames = SpriteLoader.make_frames(P_FIRE, "play", 12.0, true)
	_fire.play("play")
