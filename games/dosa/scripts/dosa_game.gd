extends Node2D

## Main controller for Dosa Master – Attention Training Game.

enum GameState { SETUP, PLAYING, PAUSED, FINISHING, OVER }
enum Difficulty { EASY, MEDIUM, HARD }

const DIFFICULTY_CFG := {
	Difficulty.EASY:   {max_dosas=2, spawn_min=3.0, spawn_max=5.0, cooking_duration=7.0, ready_window=2.5},
	Difficulty.MEDIUM: {max_dosas=4, spawn_min=2.0, spawn_max=3.0, cooking_duration=6.0, ready_window=1.8},
	Difficulty.HARD:   {max_dosas=6, spawn_min=1.0, spawn_max=2.0, cooking_duration=5.0, ready_window=1.2},
}

const SESSION_DURATION := 120.0

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

const _UI_DIR := "res://assets/images/dosa_game_ui_sprites_pngs/"
const BADGE_PANEL  := _UI_DIR + "ui_hud_badge_panel.png"
const STAR_FILLED  := _UI_DIR + "ui_star_filled.png"
const STAR_EMPTY   := _UI_DIR + "ui_star_empty.png"

const POINTS_PERFECT := 100
const POINTS_LATE     := 50
const POINTS_EARLY    := 25
const POINTS_BURNT    := -50

var _state: GameState = GameState.SETUP
var _difficulty: Difficulty = Difficulty.EASY
var _session_elapsed: float = 0.0
var _finishing_timer: float = 0.0

# Metrics
var _score: int = 0
var _spawned: int = 0
var _perfect: int = 0
var _early: int = 0
var _late: int = 0
var _missed: int = 0
var _reaction_times: Array[float] = []

# --- nodes ---
@onready var _dosa_root: Node2D        = $DosaContainer
@onready var _spawner: Node            = $DosaSpawner
@onready var _ui: CanvasLayer          = $UI

@onready var _setup_panel: Control     = %SetupPanel
@onready var _hud: Control             = %HUD
@onready var _score_label: Label       = %ScoreLabel
@onready var _timer_label: Label       = %TimerLabel
@onready var _feedback_label: Label    = %FeedbackLabel
@onready var _pause_panel: Control     = %PausePanel
@onready var _over_panel: Control      = %GameOverPanel
@onready var _results_label: Label     = %ResultsLabel
@onready var _stars: Array[TextureRect] = [%Star1, %Star2, %Star3]

@onready var _easy_btn:   Button = %EasyBtn
@onready var _medium_btn: Button = %MediumBtn
@onready var _hard_btn:   Button = %HardBtn
@onready var _start_btn:  Button = %StartBtn
@onready var _pause_btn:  Button = %PauseBtn
@onready var _resume_btn: Button = %ResumeBtn
@onready var _again_btn:  Button = %PlayAgainBtn
@onready var _quit_btn:   Button = %QuitBtn

@onready var _chef: TextureRect = %ChefIcon
@onready var _bgm: AudioStreamPlayer      = $BgmPlayer
@onready var _ambience: AudioStreamPlayer = $AmbiencePlayer

var _chef_tween: Tween
var _displayed_score: int = 0  ## what's currently shown; tweens toward _score
var _score_tween: Tween

func _ready() -> void:
	_bgm.stream = load(SND_BGM)
	_bgm.finished.connect(func(): _bgm.play())  # manual loop
	_bgm.play()
	_ambience.stream = load(SND_AMBIENCE)
	_ambience.finished.connect(func(): _ambience.play())  # manual loop
	_ambience.play()
	_easy_btn.pressed.connect(func(): _set_difficulty(Difficulty.EASY))
	_medium_btn.pressed.connect(func(): _set_difficulty(Difficulty.MEDIUM))
	_hard_btn.pressed.connect(func(): _set_difficulty(Difficulty.HARD))
	_start_btn.pressed.connect(_start_game)
	_pause_btn.pressed.connect(_pause_game)
	_resume_btn.pressed.connect(_resume_game)
	_again_btn.pressed.connect(_restart)
	_quit_btn.pressed.connect(_go_to_launcher)
	%BackBtn.pressed.connect(_go_to_launcher)

	_spawner.container = _dosa_root
	_spawner.dosa_spawned.connect(_on_dosa_spawned)

	_show_setup()

func _set_difficulty(d: Difficulty) -> void:
	_difficulty = d
	_easy_btn.button_pressed   = (d == Difficulty.EASY)
	_medium_btn.button_pressed = (d == Difficulty.MEDIUM)
	_hard_btn.button_pressed   = (d == Difficulty.HARD)

func _show_setup() -> void:
	_state = GameState.SETUP
	_setup_panel.visible = true
	_hud.visible         = false
	_pause_panel.visible = false
	_over_panel.visible  = false
	_feedback_label.visible = false
	_set_difficulty(Difficulty.EASY)

func _start_game() -> void:
	_score = 0
	_displayed_score = 0
	_spawned = 0
	_perfect = 0
	_early   = 0
	_late    = 0
	_missed  = 0
	_reaction_times.clear()
	_session_elapsed = 0.0
	_finishing_timer = 0.0
	_state = GameState.PLAYING

	_setup_panel.visible = false
	_hud.visible         = true
	_over_panel.visible  = false
	_pause_panel.visible = false
	_feedback_label.visible = false
	_update_hud()

	_spawner.start(DIFFICULTY_CFG[_difficulty].duplicate())

func _process(delta: float) -> void:
	match _state:
		GameState.PLAYING:
			_session_elapsed += delta
			_update_hud()
			var remaining := SESSION_DURATION - _session_elapsed
			if remaining <= 0.0:
				_begin_finish()

		GameState.FINISHING:
			_finishing_timer += delta
			_update_hud()
			if _finishing_timer >= 5.0:
				_end_game()

func _begin_finish() -> void:
	_state = GameState.FINISHING
	_spawner.stop()

func _end_game() -> void:
	_state = GameState.OVER
	_hud.visible = false
	_feedback_label.visible = false
	_over_panel.visible = true
	_results_label.text = _build_results()
	_update_stars()
	_bgm.stop()
	_ambience.stop()
	Sfx.play(get_tree(), SND_GAMEOVER)
	if _stars_earned() == 3:
		_set_chef(CHEF_HAPPY)

## Accuracy-based rating: 3 stars for a strong perfect-pickup rate, down to
## 0 if the session resolved no dosas or almost nothing was caught in time.
func _stars_earned() -> int:
	var resolved := _perfect + _early + _late + _missed
	if resolved == 0:
		return 0
	var accuracy := float(_perfect) / float(resolved) * 100.0
	if accuracy >= 75.0:
		return 3
	if accuracy >= 45.0:
		return 2
	if accuracy >= 15.0:
		return 1
	return 0

func _update_stars() -> void:
	var earned := _stars_earned()
	for i in _stars.size():
		_stars[i].texture = load(STAR_FILLED if i < earned else STAR_EMPTY)

func _update_hud() -> void:
	var remaining := maxf(0.0, SESSION_DURATION - _session_elapsed)
	_timer_label.text = "%d s" % ceili(remaining)

## Tweens the on-screen score from its current displayed value to the new
## total over 0.25s, with a quick scale-pulse on the label for extra juice.
func _add_score(delta: int) -> void:
	_score = maxi(0, _score + delta)
	if _score_tween and _score_tween.is_valid():
		_score_tween.kill()
	_score_tween = create_tween()
	_score_tween.tween_method(_update_displayed_score, _displayed_score, _score, 0.25)

	_score_label.pivot_offset = _score_label.size * 0.5
	var pulse := create_tween()
	pulse.tween_property(_score_label, "scale", Vector2(1.18, 1.18), 0.1) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pulse.tween_property(_score_label, "scale", Vector2.ONE, 0.15) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _update_displayed_score(v: int) -> void:
	_displayed_score = v
	_score_label.text = "Score: %d" % v

func _on_dosa_spawned(dosa: DosaEntity) -> void:
	_spawned += 1
	dosa.picked.connect(_on_picked)
	dosa.burnt.connect(_on_burnt)
	dosa.burning_started.connect(_on_burning_started)
	dosa.warning_started.connect(_on_warning_started)

func _on_picked(dosa: DosaEntity, timing: String, reaction: float) -> void:
	if _state not in [GameState.PLAYING, GameState.FINISHING]:
		return
	var pos: Vector2 = dosa.global_position
	match timing:
		"perfect":
			_perfect += 1
			_add_score(POINTS_PERFECT)
			if reaction >= 0.0:
				_reaction_times.append(reaction)
			_show_feedback("Perfect! +%d" % POINTS_PERFECT, Color(1.0, 0.85, 0.1))
			_spawn_popup("+%d" % POINTS_PERFECT, Color(1.0, 0.85, 0.1), pos)
			Sfx.play(get_tree(), SND_PERFECT)
			_set_chef(CHEF_HAPPY)
		"early":
			_early += 1
			_add_score(POINTS_EARLY)
			_show_feedback("A Bit Early  +%d" % POINTS_EARLY, Color(1.0, 0.55, 0.15))
			_spawn_popup("+%d" % POINTS_EARLY, Color(1.0, 0.55, 0.15), pos)
			Sfx.play(get_tree(), SND_EARLY)
		"late":
			_late += 1
			_add_score(POINTS_LATE)
			_show_feedback("Close Call!  +%d" % POINTS_LATE, Color(0.95, 0.65, 0.2))
			_spawn_popup("+%d" % POINTS_LATE, Color(0.95, 0.65, 0.2), pos)
			Sfx.play(get_tree(), SND_LATE)
	_update_hud()

## Small badge (text over the HUD badge-panel art) that rises and fades at
## the stove where the event happened — extra juice alongside the central
## feedback label.
func _spawn_popup(text: String, color: Color, pos: Vector2) -> void:
	var badge := TextureRect.new()
	badge.texture = load(BADGE_PANEL)
	badge.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	badge.stretch_mode = TextureRect.STRETCH_SCALE
	badge.custom_minimum_size = Vector2(100, 40)
	badge.size = Vector2(100, 40)
	badge.position = pos + Vector2(-50, -130)
	badge.position.y = maxf(badge.position.y, 80.0)  # never overlap the top HUD bar
	badge.z_index = 100
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ui.add_child(badge)

	var lbl := Label.new()
	lbl.text = text
	lbl.modulate = color
	lbl.add_theme_font_size_override("font_size", 24)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.add_child(lbl)

	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(badge, "position:y", badge.position.y - 45, 0.6) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(badge, "modulate:a", 0.0, 0.4).set_delay(0.2)
	tw.chain().tween_callback(badge.queue_free)

func _on_burnt(dosa: DosaEntity) -> void:
	if _state not in [GameState.PLAYING, GameState.FINISHING]:
		return
	_missed += 1
	_add_score(POINTS_BURNT)
	_show_feedback("Burnt!  %d" % POINTS_BURNT, Color(0.85, 0.25, 0.2))
	_spawn_popup("%d" % POINTS_BURNT, Color(0.85, 0.25, 0.2), dosa.global_position)
	Sfx.play(get_tree(), SND_BURNT)
	_set_chef(CHEF_BURNT)

func _on_warning_started(_dosa: DosaEntity) -> void:
	if _state not in [GameState.PLAYING, GameState.FINISHING]:
		return
	_set_chef(CHEF_WARNING)

func _on_burning_started(dosa: DosaEntity) -> void:
	var stove := get_node_or_null("Stove%d" % (dosa.slot_index + 1))
	if stove == null:
		return
	var base_x: float = stove.position.x
	var shake := create_tween()
	shake.tween_property(stove, "position:x", base_x - 4.0, 0.04)
	shake.tween_property(stove, "position:x", base_x + 4.0, 0.04)
	shake.tween_property(stove, "position:x", base_x - 4.0, 0.04)
	shake.tween_property(stove, "position:x", base_x, 0.04)

## Swaps the chef's expression for a couple seconds, then eases back to idle.
## Cancels any pending revert so rapid events don't fight each other.
func _set_chef(path: String) -> void:
	_chef.texture = load(path)
	if _chef_tween and _chef_tween.is_valid():
		_chef_tween.kill()
	_chef_tween = create_tween()
	_chef_tween.tween_interval(1.4)
	_chef_tween.tween_callback(func(): _chef.texture = load(CHEF_IDLE))

func _show_feedback(text: String, col: Color) -> void:
	_feedback_label.text = text
	_feedback_label.modulate = col
	_feedback_label.visible = true
	var t := get_tree().create_timer(1.0, false)
	t.timeout.connect(func(): _feedback_label.visible = false)

func _pause_game() -> void:
	if _state != GameState.PLAYING:
		return
	_state = GameState.PAUSED
	_pause_panel.visible = true
	get_tree().paused = true

func _resume_game() -> void:
	if _state != GameState.PAUSED:
		return
	_pause_panel.visible = false
	get_tree().paused = false
	_state = GameState.PLAYING

func _restart() -> void:
	get_tree().paused = false
	_spawner.stop()
	_clear_dosas()
	_show_setup()
	if not _bgm.playing:
		_bgm.play()
	if not _ambience.playing:
		_ambience.play()
	_chef.texture = load(CHEF_IDLE)

func _go_to_launcher() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/launcher.tscn")

func _clear_dosas() -> void:
	for child in _dosa_root.get_children():
		child.queue_free()

func _build_results() -> String:
	var resolved := _perfect + _early + _late + _missed
	var accuracy := 0.0
	if resolved > 0:
		accuracy = float(_perfect) / float(resolved) * 100.0
	var avg_rx := 0.0
	if not _reaction_times.is_empty():
		avg_rx = _reaction_times.reduce(func(a, b): return a + b) / _reaction_times.size()
	return (
		"Score: %d\n\nPerfect pickups: %d\nEarly: %d   Late: %d   Missed: %d\n\nAccuracy: %.0f%%\nAvg reaction: %.2f s"
		% [_score, _perfect, _early, _late, _missed, accuracy, avg_rx]
	)
