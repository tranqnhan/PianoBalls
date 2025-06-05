extends Node2D

@export var shift_pos : Vector2

# DEBUG
@export var MAX_POINTS: int
@export var popped_effect: PackedScene
const POINT_COLOR= Color(0, 1, 0, 1)
const MINI_RADIUS = 5
signal num_points_changed(num_points: int)

# POINTS
var ppos : Array[Vector2] = []
var pppos : Array[Vector2] = []

# LINES
var ppair = []
var dconst : Array[float] = []

const HEIGHT = 500
const WIDTH = 1200
const G = 100

var SUBDIVISION = 10
var RADIUS = 100


func _ready() -> void:
	var SLICE = 2*PI/SUBDIVISION
	var ppos_init = []
	
	for i in range(SUBDIVISION):
		ppos_init.append(cos(SLICE * i))
		ppos_init.append(sin(SLICE * i))
	
	for i in range(int(len(ppos_init) / 2)):
		var p = Vector2(ppos_init[i*2], ppos_init[i*2+1])
		ppos.append(p * RADIUS + shift_pos)
		var v = Vector2(randf(), randf()) * 100 - Vector2.ONE * 50 #Vector2.ZERO
		pppos.append(p * RADIUS + shift_pos - v * 0.01)
	
	for i in range(0, len(ppos) - 1):
		var pair = [i, i + 1]
		ppair.append(pair)
	
	var pair = [len(ppos) - 1, 0]
	ppair.append(pair)

	for p in ppair:
		dconst.append(ppos[p[0]].distance_to(ppos[p[1]]))
		

func bounce_constraint(newpos, curpos):
	var is_bounce_x = false
	var is_bounce_y = false
	
	if (newpos.y > (HEIGHT - MINI_RADIUS)):
		newpos.y = 2*(HEIGHT - MINI_RADIUS) - newpos.y 
		curpos.y = 2*(HEIGHT - MINI_RADIUS) - curpos.y 
		is_bounce_y = true
	elif (newpos.y < MINI_RADIUS):
		newpos.y = 2*(MINI_RADIUS) - newpos.y 
		curpos.y = 2*(MINI_RADIUS) - curpos.y
		is_bounce_y = true
	elif (newpos.x > (WIDTH - MINI_RADIUS)):
		newpos.x = 2*(WIDTH - MINI_RADIUS) - newpos.x 
		curpos.x = 2*(WIDTH - MINI_RADIUS) - curpos.x
		is_bounce_x = true
	elif (newpos.x < MINI_RADIUS):
		newpos.x = 2*(MINI_RADIUS) - newpos.x 
		curpos.x = 2*(MINI_RADIUS) - curpos.x
		is_bounce_x = true
	
	if (is_bounce_y):
		# SOUND EFFECT
		var x = (newpos.x + curpos.x) / 2 # Estimates collision hit pos
		var note_id = LoadNotes.get_note_id_from_pos(x, WIDTH)
		var bounce_sfx = AudioStreamPlayer2D.new()
		bounce_sfx.stream = LoadNotes.get_note(note_id)
		self.add_child(bounce_sfx)
		bounce_sfx.play()
		bounce_sfx.finished.connect(func(): bounce_sfx.queue_free())
	
	return {"npos": newpos, "cpos": curpos}


func _physics_process(delta: float) -> void:
	for i in range(len(ppos)):
		var ppos1 = 2 * ppos[i] - pppos[i] + Vector2(0, G * delta * delta)
		var cspos = bounce_constraint(ppos1, ppos[i])
		
		ppos[i] = cspos["npos"]
		pppos[i] = cspos["cpos"]
	
	# PRIMITIVE WAY TO HANDLE COLLISIONS
	for i in range(len(ppos)):
		for j in range(i + 1, len(ppos)):
			var c = ppos[i].distance_to(ppos[j])
			if (c <= 2*MINI_RADIUS):
				var vi = ppos[i] - pppos[i]
				var vj = ppos[j] - pppos[j]
				pppos[i] = ppos[i] - vj
				pppos[j] = ppos[j] - vi

	queue_redraw()
	
	
func _draw() -> void:
	for p in ppos:
		draw_circle(p, MINI_RADIUS, POINT_COLOR, true)


func add_random_points(num_points: int):
	if (num_points + len(ppos) > MAX_POINTS):
		num_points = MAX_POINTS - len(ppos)
		if (num_points <= 0): 
			num_points_changed.emit(-1)
			return
	
	for i in range(num_points):
		var p = Vector2(randf() * (WIDTH - 2*MINI_RADIUS) + MINI_RADIUS, 
						randf() * (HEIGHT - 2*MINI_RADIUS) + MINI_RADIUS)
		ppos.append(p)
		var v = Vector2(randf(), randf()) * 200 - Vector2.ONE * 100 #Vector2.ZERO
		pppos.append(p - v * 0.01)
		num_points_changed.emit(len(ppos))
		await get_tree().create_timer(0.1).timeout
		
	$DequeuePointTimer.one_shot = false
	$DequeuePointTimer.start()
	

func get_num_points():
	return len(ppos)


func _on_dequeue_point_timeout() -> void:
	if (len(ppos) <= 0): return
	
	# POP EFFECT
	var efx = popped_effect.instantiate()
	efx.finished.connect(func(): efx.queue_free())
	efx.position = ppos[0]
	efx.emitting = true
	self.add_child(efx)
	
	ppos[0] = ppos.back()
	pppos[0] = pppos.back()
	ppos.pop_back() # There is a simple reason why I don't auto assign this to ppos[0] 
	pppos.pop_back()
	
	num_points_changed.emit(len(ppos))

	if (len(ppos) <= 0):
		$DequeuePointTimer.one_shot = true
		$DequeuePointTimer.stop()
		
	
