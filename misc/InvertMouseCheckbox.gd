extends CheckBox

func _ready():
	pressed = GS.invert_mouse

func _process(delta):
	GS.invert_mouse = pressed
