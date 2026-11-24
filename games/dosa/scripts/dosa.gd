class_name DosaEntity
extends Area2D

## Simplified, full-sheet state machine:
##   POURING  → batter_pouring,     frames 0-15 once (empty pan → spread)
##   COOKING  → raw_to_cooked,      frames 0-15 continuously (pale → crispy golden-brown)
##   READY    → raw_to_cooked,      HELD at frame 15 (the perfect pickup window)
##   BURNING  → overcooking_burning,frames 0-15 continuously (golden → charred black)
##   DESTROYING → burnt_destruction,frames 0-15 once (crumbles away)
##   PICKED   → dosa_pickup,        frames 0-15 once (spatula lifts it off)
enum DosaState { POURING, COOKING, READY, BURNING, DESTROYING, PICKED }

signal picked(dosa: DosaEntity, timing: String, reaction_time: float)
signal burnt(dosa: DosaEntity)
signal removed(dosa: DosaEntity)
signal burning_started(dosa: DosaEntity)  ## fired partway through BURNING, for stove-shake feedback
signal warning_started(dosa: DosaEntity)  ## fired the instant BURNING begins, for the chef's panic reaction

# Injected by spawner
var cooking_duration: float = 6.0  ## total seconds COOKING→end of READY
var ready_window: float = 1.8
var slot_index: int = 0

var state: DosaState = DosaState.POURING
var is_selected: bool = false
var _pick_timing: String = "perfect"  ## set just before entering PICKED, picks the burst VFX

var stage_elapsed: float = 0.0
var ready_started_at: float = 0.0

var _dur: Dictionary = {}
const _BURNING_DUR := 2.5  ## base seconds for the full overcooking_burning sweep
const _warning_cleared := 0.45  ## fraction into BURNING when the warning ring gives way to real char

## Verified frame-by-frame (grid-labeled contact sheets): the filenames are
## actually correct. "02_batter_pouring" frame 0 is an EMPTY pan, 1-3 show
## the stream falling and splashing, 4-15 settle into a pale raw dosa.
## "03_raw_to_cooked" goes white → golden-brown → crispy well-browned by
## frame 15 (never pure black) — played in full across COOKING, held at the
## last frame for READY. "04_overcooking_burning" goes golden → fully
## charred black by frame 15 — played in full across BURNING.
const P_POURING  := "res://assets/images/dosa_cooking_game_transparent_pngs/02_batter_pouring_4x4.png"
const P_COOKING  := "res://assets/images/dosa_cooking_game_transparent_pngs/03_raw_to_cooked_4x4.png"
const P_BURNING  := "res://assets/images/dosa_cooking_game_transparent_pngs/04_overcooking_burning_4x4.png"
const P_DESTROY  := "res://assets/images/dosa_cooking_game_transparent_pngs/05_burnt_destruction_4x4.png"
const P_STEAM    := "res://assets/images/dosa_cooking_game_transparent_pngs/06_steam_evaporation_4x4.png"
const P_SMOKE    := "res://assets/images/dosa_cooking_game_transparent_pngs/07_burning_smoke_4x4.png"
const P_PICKUP   := "res://assets/images/dosa_cooking_game_transparent_pngs/08_dosa_pickup_4x4.png"

const P_READY_PULSE := "res://assets/images/dosa_game_feedback_vfx_pngs/12_ready_pulse_ring_4x4.png"
const P_PICKUP_BURST := "res://assets/images/dosa_game_feedback_vfx_pngs/13_perfect_pickup_burst_4x4.png"
const P_BURNT_WARNING := "res://assets/images/dosa_game_feedback_vfx_pngs/14_burnt_warning_pulse_4x4.png"
const P_EARLY_VFX := "res://assets/images/dosa_early_late_vfx_and_sounds/sprites/15_early_pick_vfx_4x4.png"
const P_LATE_VFX := "res://assets/images/dosa_early_late_vfx_and_sounds/sprites/16_late_pick_vfx_4x4.png"

const _SND_DIR := "res://assets/images/dosa_early_late_vfx_and_sounds/sounds/"
const SND_POUR    := _SND_DIR + "01_batter_pour_sizzle.wav"
const SND_READY   := _SND_DIR + "02_dosa_ready_ding.wav"
const SND_WARNING := _SND_DIR + "06_burn_warning_beep.wav"

@onready var _pouring: AnimatedSprite2D  = $PouringSprite
@onready var _cooking: AnimatedSprite2D  = $CookingSprite
@onready var _burning: AnimatedSprite2D  = $BurningSprite
@onready var _destroy: AnimatedSprite2D  = $DestroySprite
@onready var _pickup:  AnimatedSprite2D  = $PickupSprite
@onready var _steam:   AnimatedSprite2D  = $SteamSprite
@onready var _smoke:   AnimatedSprite2D  = $SmokeSprite
@onready var _ready_pulse:   AnimatedSprite2D = $ReadyPulse
@onready var _pickup_burst:  AnimatedSprite2D = $PickupBurst
@onready var _early_vfx:     AnimatedSprite2D = $EarlyPickVfx
@onready var _late_vfx:      AnimatedSprite2D = $LatePickVfx
@onready var _burnt_warning: AnimatedSprite2D = $BurntWarning
@onready var _col:     CollisionShape2D  = $CollisionShape2D

func _ready() -> void:
	_build_durations()
	_load_sprites()
	var shape := CircleShape2D.new()
	shape.radius = 108.0
	_col.shape = shape
	input_pickable = true
	input_event.connect(_on_input_event)
	_enter(DosaState.POURING)

func _build_durations() -> void:
	_dur[DosaState.COOKING] = maxf(0.5, cooking_duration - ready_window)
	_dur[DosaState.READY] = ready_window
	_dur[DosaState.BURNING] = _BURNING_DUR

## Source frames are 256×256px (1024px sheet / 4). Scaled to read clearly
## on the bigger stoves while still leaving margin inside the tawa (~307px).
const SPRITE_SCALE := 0.85

var _idle_tween: Tween  ## continuous "breathing" life while cooking
var _warning_active := false

func _load_sprites() -> void:
	_pouring.sprite_frames = SpriteLoader.make_frames(P_POURING, "play", 10.0)
	_cooking.sprite_frames = SpriteLoader.make_frames(P_COOKING, "play", 1.0)
	_burning.sprite_frames = SpriteLoader.make_frames(P_BURNING, "play", 1.0)
	_destroy.sprite_frames = SpriteLoader.make_frames(P_DESTROY, "play", 20.0)
	_pickup.sprite_frames  = SpriteLoader.make_frames(P_PICKUP,  "play", 20.0)
	_steam.sprite_frames   = SpriteLoader.make_frames(P_STEAM,   "play", 10.0, true)
	_smoke.sprite_frames   = SpriteLoader.make_frames(P_SMOKE,   "play", 10.0, true)

	_ready_pulse.sprite_frames   = SpriteLoader.make_frames(P_READY_PULSE,   "play", 10.0, true)
	_pickup_burst.sprite_frames  = SpriteLoader.make_frames(P_PICKUP_BURST,  "play", 24.0, false)
	_early_vfx.sprite_frames     = SpriteLoader.make_frames(P_EARLY_VFX,     "play", 22.0, false)
	_late_vfx.sprite_frames      = SpriteLoader.make_frames(P_LATE_VFX,      "play", 22.0, false)
	_burnt_warning.sprite_frames = SpriteLoader.make_frames(P_BURNT_WARNING, "play", 14.0, true)

	for spr: AnimatedSprite2D in [_pouring, _cooking, _burning, _destroy, _pickup, _steam, _smoke]:
		spr.scale = Vector2(SPRITE_SCALE, SPRITE_SCALE)
	# Glow rings read as a halo around the dosa rather than the dosa's own
	# edge, so they're sized a bit past the dosa's own scale.
	_ready_pulse.scale   = Vector2(SPRITE_SCALE, SPRITE_SCALE) * 1.2
	_burnt_warning.scale = Vector2(SPRITE_SCALE, SPRITE_SCALE) * 1.2
	_pickup_burst.scale  = Vector2(SPRITE_SCALE, SPRITE_SCALE) * 1.45  # reads as an outward burst beyond the dosa rim
	_early_vfx.scale     = Vector2(SPRITE_SCALE, SPRITE_SCALE) * 1.45
	_late_vfx.scale      = Vector2(SPRITE_SCALE, SPRITE_SCALE) * 1.45

func _hide_all() -> void:
	for s: AnimatedSprite2D in [_pouring, _cooking, _burning, _destroy, _pickup, _steam, _smoke, _ready_pulse, _pickup_burst, _early_vfx, _late_vfx, _burnt_warning]:
		s.visible = false

func _enter(s: DosaState) -> void:
	state = s
	stage_elapsed = 0.0
	_hide_all()

	match s:
		DosaState.POURING:
			_pouring.visible = true
			_pouring.play("play")
			_pouring.animation_finished.connect(
				func(): _enter(DosaState.COOKING), CONNECT_ONE_SHOT)
			# Little "plop" bounce as the batter lands.
			scale = Vector2(0.95, 0.95)
			var pour_tween := create_tween()
			pour_tween.tween_property(self, "scale", Vector2.ONE, 0.12) \
				.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			Sfx.play(get_tree(), SND_POUR)

		DosaState.COOKING:
			_cooking.visible = true
			_cooking.frame = 0
			_steam.visible = true
			_steam.modulate.a = 0.0
			_steam.play("play")
			_start_idle_breathing()

		DosaState.READY:
			_cooking.visible = true
			_cooking.frame = 15  # hold the final, best-looking cook frame
			_steam.visible = true
			_steam.modulate.a = 1.0
			_ready_pulse.visible = true
			_ready_pulse.play("play")
			ready_started_at = Time.get_ticks_msec() / 1000.0
			# Subtle wiggle to catch the eye the moment it's perfect.
			rotation_degrees = 0.0
			var wiggle := create_tween()
			wiggle.tween_property(self, "rotation_degrees", -2.0, 0.08)
			wiggle.tween_property(self, "rotation_degrees", 2.0, 0.16)
			wiggle.tween_property(self, "rotation_degrees", 0.0, 0.08)
			Sfx.play(get_tree(), SND_READY)

		DosaState.BURNING:
			_stop_idle_breathing()
			_warning_active = true
			_burning.visible = true
			_burning.frame = 0
			_smoke.visible = true
			_smoke.modulate.a = 0.2
			_smoke.play("play")
			_burnt_warning.visible = true
			_burnt_warning.play("play")
			Sfx.play(get_tree(), SND_WARNING)
			warning_started.emit(self)

		DosaState.DESTROYING:
			_col.disabled = true
			_destroy.visible = true
			_destroy.play("play")
			_destroy.animation_finished.connect(func():
				burnt.emit(self)
				removed.emit(self)
				queue_free(), CONNECT_ONE_SHOT)

		DosaState.PICKED:
			_stop_idle_breathing()
			_col.disabled = true
			_steam.visible = false
			_smoke.visible = false
			_pickup.visible = true
			_pickup.play("play")
			var burst := _pickup_burst
			match _pick_timing:
				"early": burst = _early_vfx
				"late": burst = _late_vfx
			burst.visible = true
			burst.play("play")
			_pickup.animation_finished.connect(func():
				removed.emit(self)
				queue_free(), CONNECT_ONE_SHOT)

func _process(delta: float) -> void:
	if is_selected:
		return
	stage_elapsed += delta

	match state:
		DosaState.COOKING:
			var p: float = clamp(stage_elapsed / (_dur[DosaState.COOKING] as float), 0.0, 1.0)
			_cooking.frame = mini(int(p * 16), 15)
			_steam.modulate.a = clamp((p - 0.5) / 0.5, 0.0, 1.0)  # fades in over the back half
			if stage_elapsed >= _dur[DosaState.COOKING]:
				_enter(DosaState.READY)

		DosaState.READY:
			_steam.modulate.a = maxf(0.0, 1.0 - stage_elapsed / ready_window)
			if stage_elapsed >= ready_window:
				_enter(DosaState.BURNING)

		DosaState.BURNING:
			var p: float = clamp(stage_elapsed / (_dur[DosaState.BURNING] as float), 0.0, 1.0)
			_burning.frame = mini(int(p * 16), 15)
			_smoke.modulate.a = clamp(0.2 + p * 0.7, 0.0, 1.0)
			if _warning_active and p >= _warning_cleared:
				_warning_active = false
				_burnt_warning.visible = false
				burning_started.emit(self)
			if stage_elapsed >= _dur[DosaState.BURNING]:
				_enter(DosaState.DESTROYING)

func _start_idle_breathing() -> void:
	_idle_tween = create_tween().set_loops()
	_idle_tween.tween_property(self, "scale", Vector2(1.035, 1.035), 0.7) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_idle_tween.tween_property(self, "scale", Vector2.ONE, 0.7) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _stop_idle_breathing() -> void:
	if _idle_tween and _idle_tween.is_valid():
		_idle_tween.kill()
	scale = Vector2.ONE

func _on_input_event(_vp: Node, event: InputEvent, _shape: int) -> void:
	if is_selected:
		return
	if state in [DosaState.POURING, DosaState.DESTROYING, DosaState.PICKED]:
		return
	var tapped: bool = (event is InputEventMouseButton and event.pressed
			and event.button_index == MOUSE_BUTTON_LEFT) \
		or (event is InputEventScreenTouch and event.pressed)
	if not tapped:
		return
	get_viewport().set_input_as_handled()
	is_selected = true

	var timing: String
	var reaction := -1.0
	match state:
		DosaState.COOKING:
			timing = "early"
		DosaState.READY:
			timing = "perfect"
			reaction = Time.get_ticks_msec() / 1000.0 - ready_started_at
		DosaState.BURNING:
			timing = "late"
		_:
			is_selected = false
			return

	_pick_timing = timing
	picked.emit(self, timing, reaction)
	_enter(DosaState.PICKED)
