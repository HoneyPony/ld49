extends StaticBody

onready var page = get_node("../Viewport/NotepadPage")

export var dir = 1

var frame_timer = 0

func check_mouse():
	frame_timer = 2
	
	if Input.is_action_just_pressed("mouse_click"):
		page.turn(dir)
		
func _process(delta):
	frame_timer = max(frame_timer - 1, 0)
	
	if dir > 0:
		GS.hover_next_button = (frame_timer > 0)
	else:
		GS.hover_prev_button = (frame_timer > 0)
