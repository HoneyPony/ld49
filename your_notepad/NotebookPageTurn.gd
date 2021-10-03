extends StaticBody

onready var page = get_node("../Viewport/NotepadPage")

export var dir = 1

func check_mouse():
	if Input.is_action_just_pressed("mouse_click"):
		page.turn(dir)
