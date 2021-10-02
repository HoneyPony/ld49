extends Spatial

var disabled_timer = 0

# This determines if we're on the book or if we're on the notepad.
var showing_book = false

# This determines if we're showing stuff AT ALL.
var showing_stuff = false

var the_input_handler_col
var the_shower_col

var the_notepad_col

var the_tablet
var the_notepad

func _ready():
	the_input_handler_col = get_node("Slider/GUIPanel3D/Quad/Area/CollisionShape")
	the_shower_col = get_node("Slider/GUIPanel3D/SlideToTabletThing/CollisionShape")
	the_notepad_col = get_node("Slider/notepad/SlideToNotepadThing/CollisionShape2")
	
	the_tablet = get_node("Slider/GUIPanel3D/SlideToTabletThing")
	the_notepad = get_node("Slider/notepad/SlideToNotepadThing")
	
	the_input_handler_col.disabled = false
	the_shower_col.disabled = true
	the_notepad_col.disabled = false

func _on_SlideToTabletThing_mouse_entered():
	pass
func slide_tablet():
	if not showing_book:
		return
	
	if disabled_timer <= 0:
		$AnimationPlayer.play("ShowTablet")
		showing_book = false
		disabled_timer = 0.4
		the_input_handler_col.disabled = false
		the_shower_col.disabled = true
		the_notepad_col.disabled = false

func _on_SlideToNotepadThing_mouse_entered():
	pass
func slide_notepad():
	if showing_book:
		return
	
	if disabled_timer <= 0:
		$AnimationPlayer.play("ShowBook")
		showing_book = true
		disabled_timer = 0.4
		the_input_handler_col.disabled = true
		the_shower_col.disabled = false
		the_notepad_col.disabled = true

func check_rays():
	var mouse = get_viewport().get_mouse_position()
	var camera = get_node("../")
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * 10
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to,
							[], the_notepad.collision_mask)
							
	var col = result.get("collider")
	#print(result.has("collider"))
	#print(col, " vs ", the_notepad)
	if col == the_notepad:
		slide_notepad()
	if col == the_tablet:
		slide_tablet()

func _process(delta):
	disabled_timer = max(disabled_timer - delta, -1)
	
	if showing_stuff:
		check_rays()
		
	if Input.is_action_just_pressed("open_tablet"):
		showing_stuff = not showing_stuff
		if showing_stuff:
			$ShowStuffP.play("Show")
		else:
			get_viewport().warp_mouse(get_viewport().size / 2.0)
			$ShowStuffP.play("Hide")
			
	
	
