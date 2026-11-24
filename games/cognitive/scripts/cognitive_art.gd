extends RefCounted
## Sprite catalogue for the three 2D games. Only the open game's sheets stay in
## memory: one 2048 x 2048 sheet needs 16 MB of video memory.

const ROOT := "res://assets/images/cognitive/"
const CELL := 512.0

## Sheets in objects/, in icon-id order: icon id = theme * 16 + cell.
const THEMES := ["fruits", "home", "nature", "creatures", "music", "travel", "lookalike_a", "lookalike_b"]
const PLAIN_THEMES := 6
const FIRST_LOOKALIKE := 6
const MUSICIANS := ["robin", "frog", "owl", "duckling", "squirrel", "rabbit"]
const COVERS := ["lotus", "marigold", "hibiscus"]

const GAMES := [
	{dir = "meadow", host = "moti", bg = "bg_meadow", fg = "fg_meadow",
		anims = ["idle", "think", "happy", "dance", "encourage", "cheer", "water"]},
	{dir = "melody", host = "nila", bg = "bg_stream", fg = "fg_stream",
		anims = ["idle", "conduct", "listen", "happy", "encourage", "cheer"]},
	{dir = "focus", host = "tashi", bg = "bg_forest", fg = "fg_forest",
		anims = ["idle", "search", "found", "dance", "encourage", "cheer"]}]

static var _cache := {}
static var _pending := {}
static var _wanted := {}
static var _soft: GradientTexture2D


static func path(sheet: String) -> String:
	return ROOT + sheet + ".png"


## Starts loading in the background so that opening a game does not stutter.
static func request(sheets: Array) -> void:
	for sheet in sheets:
		_wanted[sheet] = true
		if sheet in _cache or sheet in _pending: continue
		if ResourceLoader.load_threaded_request(path(sheet)) == OK:
			_pending[sheet] = true


static func texture(sheet: String) -> Texture2D:
	if sheet not in _cache:
		if _pending.erase(sheet):
			_cache[sheet] = ResourceLoader.load_threaded_get(path(sheet))
		else:
			_cache[sheet] = load(path(sheet))
	return _cache[sheet]


## Loads these sheets and forgets all others.
static func keep_only(sheets: Array) -> void:
	_wanted.clear()
	for sheet in _cache.keys():
		if sheet not in sheets: _cache.erase(sheet)
	request(sheets)


## Collects finished background loads; those no longer wanted are let go.
static func poll() -> void:
	for sheet in _pending.keys():
		if ResourceLoader.load_threaded_get_status(path(sheet)) == ResourceLoader.THREAD_LOAD_IN_PROGRESS: continue
		var loaded := ResourceLoader.load_threaded_get(path(sheet))
		_pending.erase(sheet)
		if sheet in _wanted: _cache[sheet] = loaded


static func release_all() -> void:
	for sheet in _pending.keys():
		ResourceLoader.load_threaded_get(path(sheet))
	_pending.clear()
	_wanted.clear()
	_cache.clear()


static func cell(index: int, side := CELL) -> Rect2:
	return Rect2((index % 4) * side, floorf(index / 4.0) * side, side, side)


static func icon_sheet(icon_id: int) -> String:
	return "objects/%s_4x4" % THEMES[floori(icon_id / 16.0)]


static func draw_icon(canvas: CanvasItem, icon_id: int, centre: Vector2, side: float, tint := Color.WHITE) -> void:
	if icon_id < 0 or side <= 1.0: return
	canvas.draw_texture_rect_region(texture(icon_sheet(icon_id)),
		Rect2(centre - Vector2.ONE * side * 0.5, Vector2.ONE * side), cell(icon_id % 16), tint)


## Interface icon from shared/ui_icons_4x4.png, for buttons.
static func ui_icon(index: int) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = texture("shared/ui_icons_4x4")
	atlas.region = cell(index, 256.0)
	return atlas


## Soft round spot, used for shadows and halos.
static func soft_spot() -> Texture2D:
	if _soft == null:
		var gradient := Gradient.new()
		gradient.set_color(0, Color.WHITE)
		gradient.set_color(1, Color(1, 1, 1, 0))
		gradient.add_point(0.55, Color(1, 1, 1, 0.75))
		_soft = GradientTexture2D.new()
		_soft.gradient = gradient
		_soft.fill = GradientTexture2D.FILL_RADIAL
		_soft.fill_from = Vector2(0.5, 0.5)
		_soft.fill_to = Vector2(1.0, 0.5)
		_soft.width = 256
		_soft.height = 256
	return _soft


static func object_sheets(themes: Array) -> Array:
	return themes.map(func(item): return icon_sheet(item * 16))


static func game_sheets(mode: int, level: int) -> Array:
	var game: Dictionary = GAMES[mode]
	var sheets := []
	for anim in game.anims: sheets.append("%s/%s_%s_4x4" % [game.dir, game.host, anim])
	for part in ["%s_%d" % [game.bg, level + 1], game.fg, "ambient_4x4"]: sheets.append(game.dir + "/" + part)
	match mode:
		0: sheets.append("meadow/cover_%s_4x4" % COVERS[level])
		1:
			for animal in MUSICIANS: sheets.append("melody/%s_4x4" % animal)
			sheets.append("melody/stones")
		2: sheets.append_array(["focus/lens_frame", "focus/" + holder(level)])
	return sheets


static func holder(level: int) -> String:
	return "holder_wood" if level == 0 else "holder_leaf"


static func menu_sheets() -> Array:
	var sheets := ["shared/ui_icons_4x4", "shared/particles_4x4"]
	for game in GAMES:
		sheets.append("%s/%s_1" % [game.dir, game.bg])
		sheets.append("%s/%s_idle_4x4" % [game.dir, game.host])
	return sheets
