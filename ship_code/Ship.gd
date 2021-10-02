extends Sprite

onready var code_editor = get_node("../UI/Root/LineEdit")

enum CodeInternal {
	None,
	MoveForward,
	TurnLeft,
	TurnRight
}

var code_dict = {
	"0A" : CodeInternal.MoveForward,
	"3F" : CodeInternal.TurnLeft,
	"77" : CodeInternal.TurnRight
}

var current_code = CodeInternal.None
var code_string = ""

var do_code_processing = false

export var move_vel = 300
export var rot_vel = 200

# Code states
var cs_target_pos = Vector2.ZERO

var cs_rotate_amount = 0

func _ready():
	reset_self()

func reset_self():
	position = Vector2.ZERO
	rotation = 0
	
	do_code_processing = false

func get_next_code():
	if code_string.length() >= 2:
		var sub = code_string.substr(0, 2)
		code_string = code_string.substr(2)
		code_string = code_string.trim_prefix(" ")
		
		current_code = code_dict.get(sub, CodeInternal.None)
		init_code_state()
	if code_string.length() <= 1:
		# Cutoff last char if there is one.
		# Todo: Do we want some sort of special single-char codes...?
		code_string = ""
		
	
		
func init_code_state():
	if current_code == CodeInternal.MoveForward:
		cs_target_pos = polar2cartesian(64, rotation) + position
		
	if current_code == CodeInternal.TurnRight:
		cs_rotate_amount = 90
		
		
	if current_code == CodeInternal.TurnLeft:
		cs_rotate_amount = -90
		
func code_process(delta):
	if current_code == CodeInternal.None:
		get_next_code()
		
	# It's fine to execute the new code after we load it from the string
	# in the same frame.
		
	if current_code == CodeInternal.MoveForward:
		var velocity = (cs_target_pos - position).normalized() * move_vel
		position += velocity * delta
		if(cs_target_pos.distance_to(position) <= velocity.length() * delta * 1.5):
			position = cs_target_pos
			current_code = CodeInternal.None
			
	if current_code == CodeInternal.TurnLeft or current_code == CodeInternal.TurnRight:
		var start_s = sign(cs_rotate_amount)
		
		var amount = rot_vel * start_s * delta
		rotate(deg2rad(amount))
		cs_rotate_amount -= amount
		
		if start_s != sign(cs_rotate_amount):
			rotation_degrees = round(rotation_degrees / 90.0) * 90.0
			current_code = CodeInternal.None
		
		
func _physics_process(delta):
	if do_code_processing:
		code_process(delta)

func play():
	code_string = code_editor.text
	do_code_processing = true
