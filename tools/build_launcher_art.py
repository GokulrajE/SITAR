"""Makes the small launcher pictures in assets/images/launcher/ from the games' own art.

Small copies let the launcher open quickly. Run again after a game's art changes:
    python tools/build_launcher_art.py
nova.png, seed.png and drone.png are renders of the Adventure models and are not
made here.
"""
from pathlib import Path
from PIL import Image, ImageEnhance, ImageFilter

ROOT = Path(__file__).resolve().parent.parent / "assets" / "images"
OUT = ROOT / "launcher"
SHORT = (860, 420)
TALL = (860, 720)


def fit(source, name, box, size):
    """Crops box = (left, top, width) of a picture to the aspect of size."""
    image = Image.open(ROOT / source).convert("RGB")
    left, top, width = box
    height = width * size[1] / size[0]
    image.crop((left, top, left + width, int(top + height))).resize(size, Image.LANCZOS).save(OUT / name, optimize=True)


def sheet(source, name, side):
    Image.open(ROOT / source).convert("RGBA").resize((side, side), Image.LANCZOS).save(OUT / name, optimize=True)


OUT.mkdir(exist_ok=True)
fit("cognitive/focus/bg_forest_1.png", "bg_focus.png", (0, 200, 1500), SHORT)
fit("cognitive/meadow/bg_meadow_1.png", "bg_memory.png", (60, 130, 1000), TALL)
fit("cognitive/melody/bg_stream_1.png", "bg_melody.png", (60, 130, 1000), TALL)
fit("dosa_game_background_stove_fire_pngs/09_kitchen_counter_background.png", "bg_dosa.png", (0, 0, 1376), SHORT)
fit("peg_match/bg_meadow.png", "bg_shape.png", (500, 430, 1000), SHORT)
fit("ocean/lagoon_menu.png", "bg_ocean.png", (640, 30, 1020), SHORT)
sheet("cognitive/focus/tashi_search_4x4.png", "tashi_4x4.png", 1024)
sheet("cognitive/meadow/moti_happy_4x4.png", "moti_4x4.png", 1280)
sheet("cognitive/melody/nila_conduct_4x4.png", "nila_4x4.png", 1280)
sheet("cognitive/meadow/cover_lotus_4x4.png", "lotus_4x4.png", 1024)
sheet("dosa_cooking_game_transparent_pngs/03_raw_to_cooked_4x4.png", "dosa_4x4.png", 768)
sheet("dosa_cooking_game_transparent_pngs/01_large_dosa_tawa.png", "tawa.png", 512)
sheet("dosa_game_chef_sprites_pngs/chef_02_happy_perfect.png", "chef.png", 400)
sheet("sensory/atlas.png", "sounds_3x3.png", 900)
sheet("cognitive/melody/robin_4x4.png", "robin_4x4.png", 1024)
sheet("cognitive/focus/lens_frame.png", "lens.png", 360)
fruits = Image.open(ROOT / "cognitive/objects/fruits_4x4.png").convert("RGBA")
for name, column in (("mango", 0), ("apple", 2)):
    fruits.crop((column * 512, 0, column * 512 + 512, 512)).resize((256, 256), Image.LANCZOS).save(OUT / f"{name}.png", optimize=True)
for shape in ("cup", "cone", "cylinder"):
    sheet(f"peg_match/objects/{shape}.png", f"{shape}.png", 256)

# Soft, pale backdrop, so that the cards stand out.
backdrop = Image.open(ROOT / "cognitive/meadow/bg_meadow_1.png").convert("RGB").filter(ImageFilter.GaussianBlur(7))
backdrop = Image.blend(ImageEnhance.Color(backdrop).enhance(0.85), Image.new("RGB", backdrop.size, (255, 250, 235)), 0.3)
backdrop.save(OUT / "backdrop.png", optimize=True)
