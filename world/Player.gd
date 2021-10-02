extends KinematicBody

var is_paused = false

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
		
	return d.normalized()

var velocity = Vector3.ZERO

var move_speed = 6
var accel_magnitude = 70

var ignore_next_mouse_frame = true

func rotate_on_mouse(mouse, delta):
	
	rotation.y -= mouse.x * 80 * delta
	
	var cam = $Camera.rotation.x
	cam -= mouse.y * 80 * delta
	
	cam = clamp(cam, -PI / 2, PI / 2)
	
	$Camera.rotation.x = cam
	
	pass

func handle_mouse_things(delta):
	if is_paused or YourStuff.showing_stuff:
		ignore_next_mouse_frame = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
		
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	var mouse = get_viewport().get_mouse_position()

	var center = get_viewport().size / 2.0
	
	mouse = mouse - center
	mouse.x /= center.x # Dividing by center rather than size makes these -1 to 1
	mouse.y /= center.y
	
	get_viewport().warp_mouse(center)
	
	if not ignore_next_mouse_frame:
		rotate_on_mouse(mouse, delta)
	ignore_next_mouse_frame = false

func _physics_process(delta):
	handle_mouse_things(delta)
	
	var dir = get_move_dir()
	var target = move_speed * dir
	
	var accel_dir = (target - velocity).normalized()
	var max_accel = (target - velocity).length()
	
	var accel_cur_mag = min(accel_magnitude * delta, max_accel)
	
	velocity += accel_dir * accel_cur_mag
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("pause"):
		is_paused = not is_paused
