"""Build the SITAR pegboards as a PARAMETRIC FreeCAD document.

Run (FreeCAD on D:):
    D:\\freeCad\\bin\\freecadcmd.exe D:\\sitar\\pegboard\\build_pegboards_freecad.py

Creates  peg_boards_70.FCStd  plus one STEP per board.
Open the .FCStd in FreeCAD and edit the "Params" spreadsheet (board size, leg
size/height, leg X/Y) - every board updates automatically. Re-export STEP from
FreeCAD (select PegBoard_A -> File > Export) after editing.

The threaded peg is copied from SITAR_TOOL.step so all existing shapes still fit.
"""
import os
import FreeCAD as App
import Part

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "SITAR_TOOL.step")
OUT = os.path.join(HERE, "peg_boards_70.FCStd")
FONT = r"C:/Windows/Fonts/arialbd.ttf"

PARAMS = {  # name: (value, unit note)
    "board_d": (70.0, "plate diameter mm"),
    "plate_t": (5.0, "plate thickness mm (peg starts on top)"),
    "leg_d": (7.0, "leg diameter mm"),
    "leg_h": (12.0, "leg height = plate height above glass mm (10 or 12)"),
    "root_r": (2.0, "fillet where leg meets plate mm (keep < leg_h)"),
    "tip_r": (1.0, "leg tip rounding mm - info only, edit LegTip_* features"),
    "edge_r": (1.5, "plate edge rounding mm - info only, edit PlateRound_* features"),
    "spacing": (90.0, "distance between boards in this file mm"),
}
# Leg centres (mm from board centre). Sorted side lengths:
#   A 30.5/37.6/44.9   B 42.9/50.4/57.3   C 32.0/44.1/56.3
#   -> boards differ by >= 10.9 mm, legs >= 30.5 mm apart.
LEGS = {
    "A": [(-18.5, -19.5), (-2.5, 22.5), (15.0, -2.5)],
    "B": [(22.5, 20.0), (-30.0, -3.0), (16.5, -22.5)],
    "C": [(4.0, -30.0), (-14.5, 10.0), (13.5, 25.5)],
}


def original_peg():
    for s in Part.read(SRC).Solids:
        c = s.BoundBox.Center
        if abs(c.x) < 1 and abs(c.y) < 1 and s.BoundBox.ZMin < -5:  # peg_board_A
            cut = Part.makeCylinder(12.0, 30.0, App.Vector(0, 0, 3))
            return s.common(cut)
    raise RuntimeError("peg_board_A not found in SITAR_TOOL.step")


doc = App.newDocument("peg_boards_70")

sheet = doc.addObject("Spreadsheet::Sheet", "Params")
sheet.set("A1", "parameter"); sheet.set("B1", "value"); sheet.set("C1", "note")
row = 2
for name, (val, note) in PARAMS.items():
    sheet.set(f"A{row}", name); sheet.set(f"B{row}", str(val)); sheet.set(f"C{row}", note)
    sheet.setAlias(f"B{row}", name)
    row += 1
row += 1
for b, legs in LEGS.items():
    for i, (x, y) in enumerate(legs, 1):
        sheet.set(f"A{row}", f"{b}{i}x"); sheet.set(f"B{row}", str(x)); sheet.setAlias(f"B{row}", f"{b}{i}x"); row += 1
        sheet.set(f"A{row}", f"{b}{i}y"); sheet.set(f"B{row}", str(y)); sheet.setAlias(f"B{row}", f"{b}{i}y"); row += 1
doc.recompute()

peg_shape = original_peg()

for bi, (b, legs) in enumerate(LEGS.items()):
    off = f"Params.spacing * {bi}"

    plate = doc.addObject("Part::Cylinder", f"Plate_{b}")
    plate.setExpression("Radius", "Params.board_d / 2")
    plate.setExpression("Height", "Params.plate_t")
    plate.setExpression(".Placement.Base.x", off)
    plate_f = doc.addObject("Part::Fillet", f"PlateRound_{b}")
    plate_f.Base = plate
    doc.recompute()
    plate_f.Edges = [(2, 1.5, 1.5), (3, 1.5, 1.5)]   # Edge2 bottom circle, Edge3 top circle
    plate.Visibility = False

    parts = [plate_f]
    for i in range(1, 4):
        leg = doc.addObject("Part::Cylinder", f"Leg_{b}{i}")
        leg.setExpression("Radius", "Params.leg_d / 2")
        leg.setExpression("Height", "Params.leg_h + 0.5")       # 0.5 mm overlap into plate
        leg.setExpression(".Placement.Base.x", f"Params.{b}{i}x + {off}")
        leg.setExpression(".Placement.Base.y", f"Params.{b}{i}y")
        leg.setExpression(".Placement.Base.z", "-Params.leg_h")
        tip = doc.addObject("Part::Fillet", f"LegTip_{b}{i}")
        tip.Base = leg
        doc.recompute()
        tip.Edges = [(2, 1.0, 1.0)]                              # Edge2 = bottom circle (tip)
        leg.Visibility = False
        parts.append(tip)

        # Root fillet: a collar (cylinder) with a torus cut out leaves a concave
        # quarter-round between the leg wall and the plate underside.
        lx, ly = f"Params.{b}{i}x + {off}", f"Params.{b}{i}y"
        ring = doc.addObject("Part::Cylinder", f"RootRing_{b}{i}")
        ring.setExpression("Radius", "Params.leg_d / 2 + Params.root_r")
        ring.setExpression("Height", "Params.root_r + 0.3")      # 0.3 mm into the plate
        ring.setExpression(".Placement.Base.x", lx)
        ring.setExpression(".Placement.Base.y", ly)
        ring.setExpression(".Placement.Base.z", "-Params.root_r")
        tor = doc.addObject("Part::Torus", f"RootTorus_{b}{i}")
        tor.setExpression("Radius1", "Params.leg_d / 2 + Params.root_r")
        tor.setExpression("Radius2", "Params.root_r")
        tor.setExpression(".Placement.Base.x", lx)
        tor.setExpression(".Placement.Base.y", ly)
        tor.setExpression(".Placement.Base.z", "-Params.root_r")
        root = doc.addObject("Part::Cut", f"RootFillet_{b}{i}")
        root.Base = ring
        root.Tool = tor
        # keep the fillet inside the plate's rounded rim
        trim = doc.addObject("Part::Cylinder", f"RootTrim_{b}{i}")
        trim.setExpression("Radius", "Params.board_d / 2 - 1.5")
        trim.setExpression("Height", "Params.root_r + 1")
        trim.setExpression(".Placement.Base.x", off)
        trim.setExpression(".Placement.Base.z", "-Params.root_r - 0.5")
        root_t = doc.addObject("Part::Common", f"RootFilletTrim_{b}{i}")
        root_t.Base = root
        root_t.Tool = trim
        for o in (ring, tor, root, trim):
            o.Visibility = False
        parts.append(root_t)

    peg = doc.addObject("Part::Feature", f"Peg_{b}")
    peg.Shape = peg_shape
    peg.setExpression(".Placement.Base.x", off)
    parts.append(peg)

    fuse = doc.addObject("Part::MultiFuse", f"Body_{b}")
    fuse.Shapes = parts
    fuse.Refine = True
    for p in parts:
        p.Visibility = False
    doc.recompute()

    # Board letter engraved on the plate top, near the rim (visible around small shapes).
    final = fuse
    if os.path.exists(FONT):
        try:
            txt = Part.makeWireString(b, FONT, 8.0)
            faces = []
            for ch in txt:
                ws = sorted(ch, key=lambda w: -abs(Part.Face(w).Area))
                f = Part.Face(ws[0])
                for hole in ws[1:]:
                    f = f.cut(Part.Face(hole))
                faces.append(f)
            letter = Part.makeCompound(faces)
            bb = letter.BoundBox
            letter.translate(App.Vector(-bb.Center.x, -bb.Center.y, 0))
            letter = letter.extrude(App.Vector(0, 0, 1.0))
            eng = doc.addObject("Part::Feature", f"Letter_{b}")
            eng.Shape = letter
            eng.setExpression(".Placement.Base.x", f"{off}")
            eng.setExpression(".Placement.Base.y", "Params.board_d / 2 - 9")
            eng.setExpression(".Placement.Base.z", "Params.plate_t - 0.6")
            cut = doc.addObject("Part::Cut", f"PegBoard_{b}")
            cut.Base = fuse
            cut.Tool = eng
            fuse.Visibility = False
            eng.Visibility = False
            final = cut
        except Exception as e:  # font problems should never block the board
            print("letter skipped:", e)
    if final is fuse:
        fuse.Label = f"PegBoard_{b}"
    doc.recompute()

    out_shape = final.Shape.copy()
    out_shape.translate(App.Vector(-PARAMS["spacing"][0] * bi, 0, 0))   # centre each STEP on the origin
    out_shape.exportStep(os.path.join(HERE, f"peg_board_70_{b}.step"))
    print(f"PegBoard_{b}: valid={final.Shape.isValid()} solids={len(final.Shape.Solids)} "
          f"vol={final.Shape.Volume/1000:.1f} cm3")

doc.saveAs(OUT)
print("saved", OUT)
