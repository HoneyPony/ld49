extends Sprite

#func _process(delta):
	#position = get_local_mouse_position()

var notice

var flag = false

func _ready():
	hide()
	notice = get_node("../Notice")
	notice.hide()

func go_in_bounds():
	var s = get_viewport().size
	position.x = clamp(position.x, 0, s.x)
	position.y = clamp(position.y, 0, s.y)
	
func _process(delta):
	if flag:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			notice.show()
			hide()
		else:
			notice.hide()
			show()

func _input(event):
	var cant_do_event = Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			
			show()
			notice.hide()
			
			if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
				position = event.position
				
				flag = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		if not cant_do_event:
			event.position = position
			event.global_position = position

	if cant_do_event:
			get_tree().set_input_as_handled()
	
	if event is InputEventMouseMotion:
		position += event.relative
		go_in_bounds()
		
		event.position = position
		event.global_position = position
		
		#get_tree().set_input_as_handled()
		#get_tree().input_event(event)
		
	
		#get_tree().set_input_as_handled()
		#get_tree().input_event(event)
