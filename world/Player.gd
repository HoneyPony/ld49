extends KinematicBody

#var is_paused = false

onready var YourStuff = get_node("Camera/YourStuff")

func get_move_dir():
	var d: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("p_forward"):
		d -= transform.basis.z
		
	if Input.is_action_pressed("p_back"):
		d += transform.basis.z
		
	if Input.is_action_pressed("p_left"):
		d -= transform.basis.x
		
	if Input.is_action_pressed("p_right"):
		d += transform.basis.x
		
	if d.length() > 0:
		$Camera.accum_time = 0
	return d.normalized()

var velocity = Vector3.ZERO

var move_speed = 8
var accel_magnitude = 70

var gravity = 60

var ignore_next_mouse_frame = true

var time_till_foot = 0.2

func rotate_on_mouse(mouse_motion):
	
	var mouse = Vector2.ZERO
	mouse.x = mouse_motion.x / 512
	mouse.y = mouse_motion.y / 512
	
	rotation.y -= mouse.x * 80 * 0.016
	
	var cam = $Camera.rotation.x
	var cam_drag_sign = 1
	if GS.invert_mouse:
		cam_drag_sign = -1
	cam -= mouse.y * 80 * 0.016 * cam_drag_sign
	
	cam = clamp(cam, -PI / 2, PI / 2)
	
	$Camera.rotation.x = cam
	
	$Camera.accum_mouse += mouse.length()
	if mouse.length() > 0.0001:
		$Camera.accum_time = 0
	
	pass
	

var last_mouse_place = Vector2.ZERO

func handle_mouse_things(mouse_motion):
	if get_tree().paused or YourStuff.showing_stuff or $Camera.is_diary_mode:
		ignore_next_mouse_frame = true
		
		GS.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
		
	
	GS.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
#	var mouse = get_viewport().get_mouse_position()
#
	var center = get_viewport().size / 2.0
#
#	mouse = mouse - last_mouse_place
#	mouse.x /= center.x # Dividing by center rather than size makes these -1 to 1
#	mouse.y /= center.y
	
	#print("mouse: ", mouse, " center: ", center)
	
	#get_viewport().warp_mouse(center)
	
	#last_mouse_place = get_viewport().get_mouse_position()
	
	#print("warped: ", get_viewport().get_mouse_position())
	
	if not ignore_next_mouse_frame:
		rotate_on_mouse(mouse_motion)
	ignore_next_mouse_frame = false
	
func _input(event: InputEvent):
#	if event is InputEventMouseButton:
#		if event.pressed:
#			GS.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
#	if event is InputEventAction:
#		if event.action == "open_tablet":
#			$Camera.accum_tab += 1
			
#			if YourStuff.showing_stuff:
#				GS.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		handle_mouse_things(event.relative)

func handle_oob():
	if translation.y <= -50:
		translation = Vector3(5.5, 1.15, -0.5)

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused 
		
	if get_tree().paused :
		return
	#handle_mouse_things(delta)
	
	if not YourStuff.showing_stuff:
		var dir = get_move_dir()
		var target = move_speed * dir
		
		var vel_nograv = Vector3(velocity.x, 0, velocity.z)
		
		var accel_dir = (target - vel_nograv).normalized()
		var max_accel = (target - vel_nograv).length()
		
		var accel_cur_mag = min(accel_magnitude * delta, max_accel)
		
		vel_nograv += accel_dir * accel_cur_mag
		
		velocity.x = vel_nograv.x
		velocity.z = vel_nograv.z
		
		velocity.y = max(velocity.y - gravity * delta, -30)
		
		velocity = move_and_slide(velocity, Vector3.UP)
		
		$Camera.accum_move += velocity.length() * delta
		
		
		if velocity.length() > 3:
			time_till_foot -= delta
			if time_till_foot <= 0:
				time_till_foot = 0.5
				if is_on_floor():
					[$Foot, $Foot2, $Foot3][int(rand_range(0, 2.9))].play_sfx()
					#print("Footstep")
		else:
			time_till_foot -= delta
			if time_till_foot <= 0.2:
				time_till_foot = 0.2
	handle_oob()
		
	
