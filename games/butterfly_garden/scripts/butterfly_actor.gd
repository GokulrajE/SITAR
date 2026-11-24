extends Node2D
signal chosen(actor: Node2D)
var kind := 0
var origin := Vector2.ZERO
var flower := Vector2.ZERO
var landing_start := Vector2.ZERO
var landing_time := 0.0
var landing := false
var landed := false
var sprite: AnimatedSprite2D
var button: Button

func setup(index: int, frames: SpriteFrames, point: Vector2, destination: Vector2) -> void:
	kind = index
	origin = point
	position = point
	flower = destination
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = frames
	sprite.animation = "fly_"+str(kind)
	sprite.scale = Vector2.ONE*0.66
	sprite.play()
	add_child(sprite)
	button = Button.new()
	button.position = Vector2(-120,-105)
	button.size = Vector2(240,210)
	button.flat = true
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.tooltip_text = ["Orange monarch","Blue spotted","Violet swallowtail","Yellow scalloped"][kind]
	button.pressed.connect(func(): chosen.emit(self))
	add_child(button)

func step(delta: float, elapsed: float, level: int, reduced: bool) -> void:
	if landing:
		landing_time = minf(landing_time+delta,1.1)
		var progress := landing_time/1.1
		position = landing_start.lerp(flower,smoothstep(0.0,1.0,progress))
		if reduced: position = flower
		if progress >= 1.0:
			landing = false
			landed = true
			sprite.stop()
			sprite.frame = 0
	elif not landed:
		var amplitude := 0.0 if reduced or level==0 else (28.0 if level==1 else 48.0)
		position = origin+Vector2(sin(elapsed*0.65+kind)*amplitude,cos(elapsed*0.5+kind)*amplitude*0.6)
	if not landed:
		sprite.speed_scale = 0.0 if reduced else 1.0
		if reduced: sprite.frame = 0

func settle_on_flower() -> void:
	landing = true
	landing_start = position
	landing_time = 0.0
	button.disabled = true
