extends Node2D
## Dosa Master: customers are waiting. Watch every pan and lift each dosa
## while its ring glows green. The round ends when every order is served.
## A ring around each pan shows cooking (filling), ready (green) and burning (red).
const Shell = preload("res://scripts/shared/game_shell.gd")

enum GameState { SETUP, PLAYING, FINISHING, OVER }

const LEVELS := [
	{orders = 6, max_dosas = 2, spawn_min = 3.0, spawn_max = 5.0, cooking_duration = 7.0, ready_window = 2.5, seconds = 150.0},
	{orders = 10, max_dosas = 4, spawn_min = 2.0, spawn_max = 3.0, cooking_duration = 6.0, ready_window = 1.8, seconds = 150.0},
	{orders = 14, max_dosas = 6, spawn_min = 1.0, spawn_max = 2.0, cooking_duration = 5.0, ready_window = 1.2, seconds = 150.0},
]

const _SND_DIR := "res://assets/images/dosa_early_late_vfx_and_sounds/sounds/"
const SND_PERFECT  := _SND_DIR + "03_perfect_pick_chime.wav"
const SND_EARLY    := _SND_DIR + "04_early_pick_pop.wav"
const SND_LATE     := _SND_DIR + "05_late_pick_swoosh.wav"
const SND_BURNT    := _SND_DIR + "07_burnt_crumble_buzz.wav"
const SND_GAMEOVER := _SND_DIR + "08_game_over_jingle.wav"
const SND_BGM      := _SND_DIR + "01_bgm_south_indian_kitchen_loop.wav"
const SND_AMBIENCE := _SND_DIR + "02_ambience_tawa_sizzle_loop.wav"

const _CHEF_DIR := "res://assets/images/dosa_game_chef_sprites_pngs/"
const CHEF_IDLE    := _CHEF_DIR + "chef_01_idle.png"
const CHEF_HAPPY   := _CHEF_DIR + "chef_02_happy_perfect.png"
const CHEF_WARNING := _CHEF_DIR + "chef_03_warning_panic.png"
const CHEF_BURNT   := _CHEF_DIR + "chef_04_burnt_dismayed.png"
const BADGE_PANEL  := "res://assets/images/dosa_game_ui_sprites_pngs/ui_hud_badge_panel.png"

const POINTS_PERFECT := 100
const POINTS_LATE := 50

var shell: Control
var _state: GameState = GameState.SETUP
var _level := 0
var _elapsed := 0.0
var _paused := false
var _score := 0
var _served := 0
var _perfect := 0
var _late := 0
var _early := 0
var _missed := 0
var _chef_tween: Tween

@onready var _dosa_root: Node2D = $DosaContainer
@onready var _spawner: Node = $DosaSpawner
@onready var _ui: CanvasLayer = $UI
@onready var _chef: TextureRect = %ChefIcon
@onready var _bgm: AudioStreamPlayer = $BgmPlayer
@onready var _ambience: AudioStreamPlayer = $AmbiencePlayer


func _ready() -> void:
	_bgm.stream = load(SND_BGM)
	_bgm.finished.connect(func(): _bgm.play())
	_bgm.play()
	_ambience.stream = load(SND_AMBIENCE)
	_ambience.finished.connect(func(): _ambience.play())
	_ambience.play()
	_spawner.container = _dosa_root
	_spawner.dosa_spawned.connect(_on_dosa_spawned)
	shell = Shell.new()
	shell.title = "Dosa Master"
	shell.levels = ["Easy", "Medium", "Hard"]
	shell.notes = ["6 orders, 2 pans", "10 orders, 4 pans", "14 orders, 6 pans"]
	shell.accent = Color("b8642a")
	shell.dim = 0.35
	_ui.add_child(shell)
	shell.start_pressed.connect(start)
	shell.pause_changed.connect(_set_paused)
	shell.stop_pressed.connect(func():
		_stop()
		_state = GameState.SETUP)


func start(level: int) -> void:
	_stop()
	_level = level
	_score = 0
	_served = 0
	_perfect = 0
	_late = 0
	_early = 0
	_missed = 0
	_elapsed = 0.0
	_state = GameState.PLAYING
	_set_paused(false)
	_set_chef(CHEF_IDLE, 0.0)
	if not _bgm.playing: _bgm.play()
	if not _ambience.playing: _ambience.play()
	_spawner.start(LEVELS[level].duplicate())
	_update_status()


func _process(delta: float) -> void:
	if _state != GameState.PLAYING or _paused: return
	_elapsed += delta
	if _elapsed >= LEVELS[_level].seconds: _end(false)
	_update_status()


func _update_status() -> void:
	var left := maxf(0.0, LEVELS[_level].seconds - _elapsed)
	shell.set_status("Served %d of %d   •   %d:%02d" % [_served, LEVELS[_level].orders, int(left / 60.0), int(left) % 60])


func _set_paused(value: bool) -> void:
	_paused = value
	var mode := PROCESS_MODE_DISABLED if value else PROCESS_MODE_INHERIT
	_dosa_root.process_mode = mode
	_spawner.process_mode = mode


func _stop() -> void:
	_spawner.stop()
	_set_paused(false)
	for child in _dosa_root.get_children(): child.queue_free()


func _on_dosa_spawned(dosa: DosaEntity) -> void:
	dosa.picked.connect(_on_picked)
	dosa.burnt.connect(_on_burnt)
	dosa.warning_started.connect(func(_d):
		if _state == GameState.PLAYING: _set_chef(CHEF_WARNING))
	dosa.burning_started.connect(_shake_stove)


func _on_picked(dosa: DosaEntity, timing: String, _reaction: float) -> void:
	if _state != GameState.PLAYING: return
	match timing:
		"perfect":
			_perfect += 1
			_serve(POINTS_PERFECT, dosa.global_position, "Perfect!", Color(1.0, 0.85, 0.1))
			Sfx.play(get_tree(), SND_PERFECT)
			_set_chef(CHEF_HAPPY)
		"late":
			_late += 1
			_serve(POINTS_LATE, dosa.global_position, "Crispy", Color(0.95, 0.65, 0.2))
			Sfx.play(get_tree(), SND_LATE)
		"early":
			# Too soft to serve: the order still waits.
			_early += 1
			_popup("Too soft", Color(1.0, 0.55, 0.15), dosa.global_position)
			shell.toast("Wait for the green ring", false)
			Sfx.play(get_tree(), SND_EARLY)


func _serve(points: int, at: Vector2, word: String, colour: Color) -> void:
	_served += 1
	_score += points
	_popup(word, colour, at)
	_update_status()
	if _served >= LEVELS[_level].orders: _end(true)


func _on_burnt(dosa: DosaEntity) -> void:
	if _state != GameState.PLAYING: return
	_missed += 1
	_popup("Burnt", Color(0.85, 0.25, 0.2), dosa.global_position)
	Sfx.play(get_tree(), SND_BURNT)
	_set_chef(CHEF_BURNT)


func _end(served_all: bool) -> void:
	_state = GameState.OVER
	_spawner.stop()
	for child in _dosa_root.get_children(): child.queue_free()
	Sfx.play(get_tree(), SND_GAMEOVER)
	var orders: int = LEVELS[_level].orders
	if served_all:
		var share := float(_perfect) / maxf(1.0, float(_served + _missed + _early))
		var stars := 3 if share >= 0.8 else (2 if share >= 0.5 else 1)
		_set_chef(CHEF_HAPPY, 0.0)
		shell.finish(stars, "All %d orders served!" % orders, "%d perfect  •  %d crispy  •  %d burnt" % [_perfect, _late, _missed])
	else:
		shell.finish(0, "Time is up", "%d of %d orders served. Try again!" % [_served, orders])


func _shake_stove(dosa: DosaEntity) -> void:
	var stove := get_node_or_null("Stove%d" % (dosa.slot_index + 1))
	if stove == null: return
	var base_x: float = stove.position.x
	var shake := create_tween()
	for offset in [-4.0, 4.0, -4.0, 0.0]:
		shake.tween_property(stove, "position:x", base_x + offset, 0.04)


## A word rises and fades over the pan where it happened.
func _popup(text: String, colour: Color, at: Vector2) -> void:
	var badge := TextureRect.new()
	badge.texture = load(BADGE_PANEL)
	badge.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	badge.stretch_mode = TextureRect.STRETCH_SCALE
	badge.size = Vector2(220, 80)
	badge.position = at + Vector2(-110, -190)
	badge.position.y = maxf(badge.position.y, 120.0)
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ui.add_child(badge)
	_ui.move_child(badge, 0)
	var label := Label.new()
	label.text = text
	label.modulate = colour
	label.add_theme_font_size_override("font_size", 40)
	label.add_theme_constant_override("outline_size", 8)
	label.add_theme_color_override("font_outline_color", Color(0.2, 0.1, 0.02))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	badge.add_child(label)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(badge, "position:y", badge.position.y - 60, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(badge, "modulate:a", 0.0, 0.5).set_delay(0.4)
	tween.chain().tween_callback(badge.queue_free)


## Changes the chef's face for a moment, then back to calm.
func _set_chef(path: String, hold := 1.4) -> void:
	_chef.texture = load(path)
	_chef.pivot_offset = _chef.size * Vector2(0.5, 1.0)
	_chef.scale = Vector2(1.08, 0.94)
	create_tween().tween_property(_chef, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if _chef_tween and _chef_tween.is_valid(): _chef_tween.kill()
	if hold <= 0.0: return
	_chef_tween = create_tween()
	_chef_tween.tween_interval(hold)
	_chef_tween.tween_callback(func(): _chef.texture = load(CHEF_IDLE))
