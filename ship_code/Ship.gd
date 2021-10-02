extends Sprite

onready var code_editor = get_node("../UI/Root/LineEdit")

enum CodeInternal {
	None,
	PlayAnAnimation,
	MoveForward,
	TurnLeft,
	TurnRight,
	EnableTurbo,
	DisableTurbo,
}

var code_dict = {
	"0A" : CodeInternal.MoveForward,
	"3F" : CodeInternal.TurnLeft,
	"77" : CodeInternal.TurnRight,
	"53" : CodeInternal.EnableTurbo,
	"E9" : CodeInternal.DisableTurbo
}

var current_code = CodeInternal.None
var code_string = ""

var do_code_processing = false

export var move_vel = 300
export var rot_vel = 300

# Initialize this to ridiculous value to be sure the reset code is working.
var turbo_multiplier_state = 700

var current_code_index = -1

# Code states
var cs_target_pos = Vector2.ZERO
var cs_root_pos = Vector2.ZERO

export var cs_wiggle_amount = 0

var cs_rotate_amount = 0


func finish_anim_code():
	if current_code == CodeInternal.PlayAnAnimation:
		position = cs_root_pos
		current_code = CodeInternal.None

func reset_self():
	position = Vector2.ZERO
	rotation = 0
	current_code = CodeInternal.None
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("ResetStates")
	
	do_code_processing = false
	turbo_multiplier_state = 1
	
	current_code_index = -1
	
	var level = GS.current_puzzle_level
	if level != null and is_instance_valid(level):
		rotation_degrees = level.initial_rotation
	
	code_editor.ready_done()
	
func get_next_code():
	
	
	if code_string.length() >= 2:
		current_code_index += 1
		
		var sub = code_string.substr(0, 2)
		code_string = code_string.substr(2)
		code_string = code_string.trim_prefix(" ")
		
		current_code = code_dict.get(sub, CodeInternal.None)
		init_code_state()
		
		code_editor.highlight_code(current_code_index)
	if code_string.length() <= 1:
		# Cutoff last char if there is one.
		# Todo: Do we want some sort of special single-char codes...?
		code_string = ""
		
func do_error_anim():
	current_code = CodeInternal.PlayAnAnimation
	$AnimationPlayer.stop()
	$AnimationPlayer.play("WiggleError")
		
func evaluate_target_pos():
	var level: Node2D = GS.current_puzzle_level
	
	# Check this position too, for turbo movement.
	var half_pos = position.linear_interpolate(cs_target_pos, 0.5)
	
	if level != null:
		var children = level.get_children()
		for c in children:
			if c.is_in_group("Obstruct"):
				if c.does_obstruct(cs_target_pos) or c.does_obstruct(half_pos):
					cs_target_pos = Vector2.ZERO
					cs_root_pos = position
					do_error_anim()
					return
		
func init_code_state():
	if current_code == CodeInternal.None: # this happens when there's an invalid code
		cs_root_pos = position
		do_error_anim()
	
	if current_code == CodeInternal.MoveForward:
		cs_target_pos = polar2cartesian(64 * turbo_multiplier_state, rotation) + position
		evaluate_target_pos()
		
	if current_code == CodeInternal.TurnRight:
		cs_rotate_amount = 90
		
	if current_code == CodeInternal.TurnLeft:
		cs_rotate_amount = -90
		
	if current_code == CodeInternal.EnableTurbo:
		if turbo_multiplier_state >= 2.0:
			cs_root_pos = position
			do_error_anim()
		else:
			turbo_multiplier_state = 2.0
			
			current_code = CodeInternal.PlayAnAnimation
			cs_root_pos = position
			$AnimationPlayer.stop()
			$AnimationPlayer.play("TurnOnTurbo")
			
	if current_code == CodeInternal.DisableTurbo:
		if turbo_multiplier_state <= 1.0:
			cs_root_pos = position
			do_error_anim()
		else:
			turbo_multiplier_state = 1.0
			
			current_code = CodeInternal.PlayAnAnimation
			cs_root_pos = position
			$AnimationPlayer.stop()
			$AnimationPlayer.play("TurnOffTurbo")
		
func code_process(delta):
	if current_code == CodeInternal.None:
		get_next_code()
		
	if current_code == CodeInternal.PlayAnAnimation:
		var pos = cs_root_pos
		var dir90 = rotation_degrees + 90
		var vec = polar2cartesian(1, deg2rad(dir90))
		
		position = pos + vec * cs_wiggle_amount
		
	# It's fine to execute the new code after we load it from the string
	# in the same frame.
		
	if current_code == CodeInternal.MoveForward:
		var velocity = (cs_target_pos - position).normalized() * move_vel * turbo_multiplier_state
		position += velocity * delta
		if(cs_target_pos.distance_to(position) <= velocity.length() * delta * 1.5):
			position = cs_target_pos
			current_code = CodeInternal.None
			
	if current_code == CodeInternal.TurnLeft or current_code == CodeInternal.TurnRight:
		var start_s = sign(cs_rotate_amount)
		
		var amount = rot_vel * start_s * delta * turbo_multiplier_state
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
	
	code_editor.ready_playing()