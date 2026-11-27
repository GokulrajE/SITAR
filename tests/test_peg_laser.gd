extends "res://tests/test_peg_match.gd"
## Laser Pop, driven by simulated IR-frame contacts.
## Optional: pass a folder after "--" to save screenshots there.

## Slides the board's legs to a new rotation without lifting it.
func turn(g, board: String, centre: Vector2, deg: float, noise := 0.0) -> void:
	var at := legs(board, centre, deg, noise)
	for i in 3:
		g.tracker._contacts[down[board][i]].pos = at[i]

func play(g, secs: float) -> void:
	var t := 0.0
	while t < secs:
		g.tracker.update(0.05)
		g.advance(0.05)
		t += 0.05

func aim_deg(g) -> float:
	return rad_to_deg(g.aim)

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		shots = args[0]
	Library.persist = false
	var g = await open("res://games/pegboard/scenes/peg_laser.tscn")
	g.set_process(false)
	g.tracker.set_process(false)
	check(g.balloons.size() == 3, "three balloons to start")
	play(g, 0.2)
	check(g.mirror == "" and g._path.size() == 2, "straight beam without a mirror")

	var spot := Vector2(800, 495)
	put(g, "A", spot, 40.0)
	play(g, 0.8)
	check(g.mirror == "A" and absf(aim_deg(g) + 90.0) < 4.0, "a new mirror points up, got %.1f" % aim_deg(g))
	for d in range(40, 101, 5):                          # turn 60 degrees clockwise
		turn(g, "A", spot, d)
		play(g, 0.1)
	play(g, 1.0)
	check(absf(aim_deg(g) + 30.0) < 4.0, "beam follows the turn, got %.1f" % aim_deg(g))

	# a lifted board keeps its aim, even when set down at another rotation
	lift(g, "A")
	play(g, 1.0)
	check(g.mirror == "", "lifted mirror is gone")
	put(g, "A", spot, 10.0)
	play(g, 0.8)
	check(absf(aim_deg(g) + 30.0) < 4.0, "aim is remembered, got %.1f" % aim_deg(g))

	# resting leg noise must not shake the beam much
	var low := 999.0
	var high := -999.0
	for i in 100:
		turn(g, "A", spot, 10.0, 0.5)
		play(g, 0.05)
		if i > 20:
			low = minf(low, aim_deg(g))
			high = maxf(high, aim_deg(g))
	print("beam wobble with +-0.5 mm leg noise: %.1f degrees" % (high - low))

	# pop all balloons by turning onto each one
	turn(g, "A", spot, 10.0)
	play(g, 0.5)
	var deg := 10.0
	var guard := 0
	while g.popped < g.TO_POP and guard < 40:
		guard += 1
		var want: float = rad_to_deg((g.balloons[0].pos - g.mirror_at).angle())
		var step := wrapf(want - rad_to_deg(g._target_aim["A"]), -180.0, 180.0)
		var n := int(absf(step) / 8.0) + 1
		for i in n:
			deg += step / n
			turn(g, "A", spot, deg)
			play(g, 0.05)
		if guard == 1:
			play(g, 0.25)
			await shot(g, "laser_aim")
		play(g, 1.2)
	check(g.popped == g.TO_POP and g._again.visible, "level can be finished, popped %d" % g.popped)
	await shot(g, "laser_done")
	g.start()
	check(g.popped == 0 and g.balloons.size() == 3, "play again")
	if failed:
		quit(1)
		return
	print("PASS: laser pop")
	quit()
