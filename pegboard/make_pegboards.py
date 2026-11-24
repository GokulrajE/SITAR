"""Regenerate the SITAR pegboards (A/B/C) as STEP files.

Each board = round base plate + 3 legs (scalene triangle, unique per board)
+ the original threaded peg copied verbatim from SITAR_TOOL.step, so every
existing shape still screws on.

Requires:  pip install cadquery-ocp   (OpenCascade, the same kernel FreeCAD uses)
Run:       python make_pegboards.py
Output:    peg_board_85_A.step, peg_board_85_B.step, peg_board_85_C.step,
           peg_boards_85_all.step (all three side by side) - open in FreeCAD.
"""
import math, os
from OCP.STEPCAFControl import STEPCAFControl_Reader
from OCP.STEPControl import STEPControl_Writer, STEPControl_AsIs
from OCP.TDocStd import TDocStd_Document
from OCP.TCollection import TCollection_ExtendedString
from OCP.XCAFDoc import XCAFDoc_DocumentTool
from OCP.TDF import TDF_LabelSequence
from OCP.TDataStd import TDataStd_Name
from OCP.BRepPrimAPI import BRepPrimAPI_MakeCylinder
from OCP.BRepAlgoAPI import BRepAlgoAPI_Common, BRepAlgoAPI_Fuse
from OCP.BRepFilletAPI import BRepFilletAPI_MakeFillet
from OCP.BRepBuilderAPI import BRepBuilderAPI_Transform
from OCP.BRep import BRep_Builder
from OCP.TopoDS import TopoDS, TopoDS_Compound
from OCP.TopExp import TopExp_Explorer
from OCP.TopAbs import TopAbs_EDGE
from OCP.BRepAdaptor import BRepAdaptor_Curve
from OCP.GeomAbs import GeomAbs_Circle
from OCP.ShapeUpgrade import ShapeUpgrade_UnifySameDomain
from OCP.gp import gp_Ax2, gp_Pnt, gp_Dir, gp_Trsf, gp_Vec

# ---------------- parameters (mm) ----------------
BOARD_D      = 85.0    # base plate diameter
PLATE_T      = 5.0     # plate thickness (Z 0..5, same as original)
LEG_D        = 12.0    # leg diameter  (was 10)
LEG_LEN      = 15.0    # board underside height above glass (was 10; IR frame bezel ~11)
LEG_TIP_R    = 1.0     # rounded tip
LEG_ROOT_R   = 2.5     # fillet where leg meets plate
PLATE_EDGE_R = 1.5     # rounded plate edges

# Leg centres per board. Sorted side lengths:
#   A 53.0 / 59.9 / 66.8   B 41.7 / 52.1 / 65.3   C 40.2 / 47.2 / 54.2
# -> every board differs from every other by >= 11.1 mm on some side,
#    legs >= 40 mm apart, board centre >= 12 mm inside the leg triangle.
LEGS = {
    "A": [(33.5, 11.5), (-18.5, -30.5), (-25.5, 22.0)],
    "B": [(35.5, 1.0), (-26.5, 21.5), (-13.0, -18.0)],
    "C": [(-7.0, -20.0), (-24.0, 24.0), (26.0, 3.0)],
}

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "SITAR_TOOL.step")


def load_original_peg():
    doc = TDocStd_Document(TCollection_ExtendedString("doc"))
    r = STEPCAFControl_Reader(); r.SetNameMode(True)
    r.ReadFile(SRC); r.Transfer(doc)
    st = XCAFDoc_DocumentTool.ShapeTool_s(doc.Main())
    roots = TDF_LabelSequence(); st.GetFreeShapes(roots)
    for i in range(1, roots.Length() + 1):
        ch = TDF_LabelSequence(); st.GetComponents_s(roots.Value(i), ch)
        for j in range(1, ch.Length() + 1):
            n = TDataStd_Name()
            if ch.Value(j).FindAttribute(TDataStd_Name.GetID_s(), n) and \
               n.Get().ToExtString().startswith("peg_board_A"):
                board = st.GetShape_s(ch.Value(j))
                # threaded peg + its root, everything inside r=12 above Z=3
                cut = BRepPrimAPI_MakeCylinder(gp_Ax2(gp_Pnt(0, 0, 3), gp_Dir(0, 0, 1)), 12.0, 30.0).Shape()
                return BRepAlgoAPI_Common(board, cut).Shape()
    raise RuntimeError("peg_board_A not found in SITAR_TOOL.step")


def circle_edges(shape, pred):
    out, ex = [], TopExp_Explorer(shape, TopAbs_EDGE)
    while ex.More():
        e = TopoDS.Edge_s(ex.Current()); c = BRepAdaptor_Curve(e)
        if c.GetType() == GeomAbs_Circle:
            circ = c.Circle()
            if pred(circ.Radius(), circ.Location()):
                out.append(e)
        ex.Next()
    return out


def fillet(shape, edges, r):
    if not edges:
        return shape
    f = BRepFilletAPI_MakeFillet(shape)
    for e in edges:
        f.Add(r, e)
    f.Build()
    return f.Shape()


def make_board(legs, peg):
    R = BOARD_D / 2
    plate = BRepPrimAPI_MakeCylinder(gp_Ax2(gp_Pnt(0, 0, 0), gp_Dir(0, 0, 1)), R, PLATE_T).Shape()
    plate = fillet(plate, circle_edges(plate, lambda rad, p: abs(rad - R) < 1e-3), PLATE_EDGE_R)
    body = plate
    for (x, y) in legs:
        leg = BRepPrimAPI_MakeCylinder(gp_Ax2(gp_Pnt(x, y, -LEG_LEN), gp_Dir(0, 0, 1)), LEG_D / 2, LEG_LEN + 0.5).Shape()
        leg = fillet(leg, circle_edges(leg, lambda rad, p: abs(p.Z() + LEG_LEN) < 1e-3), LEG_TIP_R)
        body = BRepAlgoAPI_Fuse(body, leg).Shape()
    body = fillet(body, circle_edges(body, lambda rad, p: abs(p.Z()) < 1e-3 and abs(rad - LEG_D / 2) < 1e-3), LEG_ROOT_R)
    body = BRepAlgoAPI_Fuse(body, peg).Shape()
    u = ShapeUpgrade_UnifySameDomain(body, True, True, False); u.Build()
    return u.Shape()


def write(shape, path):
    w = STEPControl_Writer(); w.Transfer(shape, STEPControl_AsIs)
    if w.Write(path) != 1:
        raise RuntimeError("failed to write " + path)
    print("wrote", path)


if __name__ == "__main__":
    peg = load_original_peg()
    comp = TopoDS_Compound(); bld = BRep_Builder(); bld.MakeCompound(comp)
    for i, (name, legs) in enumerate(LEGS.items()):
        b = make_board(legs, peg)
        write(b, os.path.join(HERE, f"peg_board_85_{name}.step"))
        t = gp_Trsf(); t.SetTranslation(gp_Vec(i * (BOARD_D + 15), 0, 0))
        bld.Add(comp, BRepBuilderAPI_Transform(b, t, True).Shape())
    write(comp, os.path.join(HERE, "peg_boards_85_all.step"))
