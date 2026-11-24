extends RefCounted
## Distinct paths, not just different pictures on the same six point layouts.
## Grid coordinates become generous, non-overlapping TV touch targets.
const DESIGNS = [
	["Flying bird",0,[[0,2],[2,0],[4,2]]],
	["Tree crown",1,[[0,3],[2,0],[4,3],[2,4]]],
	["Rolling wave",2,[[0,3],[1,1],[2,3],[3,1],[4,3]]],
	["Car roof",7,[[0,3],[1,1],[3,1],[4,3],[2,4]]],
	["Guitar neck",3,[[0,4],[1,2],[4,0],[3,3],[2,4]]],
	["Train window",8,[[0,0],[2,0],[4,0],[4,3],[2,3],[0,3]]],
	["Triangle",-1,[[0,4],[2,0],[4,4]]],
	["Square",-1,[[0,0],[4,0],[4,4],[0,4]]],
	["Diamond",-1,[[2,0],[4,2],[2,4],[0,2]]],
	["House",-1,[[0,4],[0,2],[2,0],[4,2],[4,4]]],
	["Sailboat",-1,[[0,2],[2,2],[2,0],[4,2],[3,4],[1,4]]],
	["Mountain peaks",-1,[[0,4],[1,0],[2,3],[3,1],[4,4]]],
	["Staircase",-1,[[0,4],[0,2],[2,2],[2,0],[4,0]]],
	["Lightning",-1,[[3,0],[0,2],[3,2],[1,4]]],
	["Crown",-1,[[0,1],[1,3],[2,0],[3,3],[4,1],[4,4],[0,4]]],
	["Hexagon",-1,[[1,0],[3,0],[4,2],[3,4],[1,4],[0,2]]],
	["Arrow",-1,[[0,1],[2,1],[2,0],[4,2],[2,4],[2,3],[0,3]]],
	["Cup",-1,[[0,0],[0,4],[3,4],[3,0],[4,1],[4,3]]],
	["Butterfly",-1,[[2,2],[0,0],[0,4],[2,3],[4,4],[4,0]]],
	["Umbrella",-1,[[0,2],[1,0],[3,0],[4,2],[2,2],[2,4],[1,4]]],
	["Fish",-1,[[0,0],[2,2],[4,0],[4,4],[2,3],[0,4]]],
	["Ribbon",-1,[[0,0],[4,0],[4,4],[2,3],[0,4]]],
	["Arch",-1,[[0,4],[0,1],[2,0],[4,1],[4,4]]],
	["Spiral",-1,[[0,4],[0,0],[4,0],[4,4],[2,4],[2,2]]],
	["Bridge",-1,[[0,4],[0,1],[1,1],[2,3],[3,1],[4,1],[4,4]]],
	["Valley",-1,[[0,0],[1,2],[2,4],[3,2],[4,0]]],
	["Kite tail",-1,[[2,0],[4,1],[2,2],[0,1],[1,3],[3,4]]],
	["Octagon",-1,[[1,0],[3,0],[4,1],[4,3],[3,4],[1,4],[0,3],[0,1]]]
]

static func all() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for entry in DESIGNS:
		var points: Array[Vector2] = []
		for pair in entry[2]:
			var point := Vector2(870+float(pair[0])*155,85+float(pair[1])*105)
			# Repeated path vertices would be impossible in simultaneous mode.
			if not points.has(point): points.append(point)
		var closed: bool = entry[0] in ["Triangle","Square","Diamond","House","Sailboat","Crown","Hexagon","Arrow","Butterfly","Fish","Ribbon","Octagon"]
		result.append({"name":entry[0],"cell":entry[1],"points":points,"closed":closed})
	return result

