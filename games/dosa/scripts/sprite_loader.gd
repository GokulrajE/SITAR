class_name SpriteLoader

## Slices a 4×4 PNG sprite sheet into 16 AtlasTexture frames
## and returns a SpriteFrames resource with one named animation.

static func make_frames(tex_path: String, anim_name: String,
		fps: float = 8.0, looping: bool = false) -> SpriteFrames:
	var sf := SpriteFrames.new()
	sf.remove_animation("default")
	sf.add_animation(anim_name)
	sf.set_animation_speed(anim_name, fps)
	sf.set_animation_loop(anim_name, looping)

	if not ResourceLoader.exists(tex_path):
		push_warning("SpriteLoader: missing asset – " + tex_path)
		return sf

	var tex: Texture2D = load(tex_path)
	var fw := tex.get_width() / 4
	var fh := tex.get_height() / 4

	for row in 4:
		for col in 4:
			var at := AtlasTexture.new()
			at.atlas = tex
			at.region = Rect2(col * fw, row * fh, fw, fh)
			sf.add_frame(anim_name, at)

	return sf
