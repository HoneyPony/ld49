extends Camera

var indicate_page

var label_wasd
var label_mouse
var label_tab

var label_dia_open
var label_dia_close

var accum_move = 0
var accum_mouse = 0
var accum_tab = 0

var wait_move = true
var wait_mouse = true
var wait_tab = true

var accum_time = 0

var diary_cam

func _ready():
	indicate_page = get_tree().get_nodes_in_group("PageIndicate")[0]
	
	label_wasd = indicate_page.get_node("../WASD")
	label_mouse = indicate_page.get_node("../Mouse")
	label_tab = indicate_page.get_node("../Tablet")
	
	label_dia_open = indicate_page.get_node("../DiaryWhenView")
	label_dia_close = indicate_page.get_node("../DiaryWhenSee")
	
	label_wasd.hide()
	label_mouse.hide()
	label_tab.hide()
	
	diary_cam = get_tree().get_nodes_in_group("DiaryCam")[0]

func update(a, v):
	if v:
		if not a.visible:
			a.get_node("AnimationPlayer").play("Show")
	else:
		if a.visible:
			a.get_node("AnimationPlayer").play("Hide")

func handle_accums(delta):
	if accum_move >= 15:
		wait_move = false
	if accum_mouse >= 5:
		wait_mouse = false
	if accum_tab >= 2:
		wait_tab = false
		
	accum_time += delta
	
	var s1 = wait_move
	var s2 = wait_mouse
	var s3 = wait_tab
	
	if $YourStuff.showing_stuff:
		accum_time = 0
	
	if accum_time >= 4.0:
		s1 = true
		s2 = true
		s3 = true
		
	if is_diary_mode:
		s1 = false
		s2 = false
		s3 = false
		
	if $YourStuff.showing_stuff:
		s1 = false
		s2 = false
		
	update(label_wasd, s1)
	update(label_mouse, s2)
	update(label_tab, s3)

func check_rays():
	var mouse = get_viewport().get_mouse_position()
	var camera = self
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * 5
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to,
							[], 0x400)#0x20000)
							
	var col = result.get("collider")
	var got_col = false
	#print(result.has("collider"))
	#print(col, " vs ", the_notepad)
	if col != null and col.is_in_group("TornPage"):
		got_col = true
		col.activate_indicator()
		
	indicate_page.visible = got_col
		
func check_rays_notebook():
	
	var mouse = get_viewport().get_mouse_position()
	var camera = self
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * 5
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to,
							[], 0x800)#0x20000)
							
	var col = result.get("collider")
	#print(result.has("collider"))
	#print(col, " vs ", the_notepad)
	if col != null and col.is_in_group("BookTurn"):
		col.check_mouse()
		
func check_rays_diary():
	if $YourStuff.showing_stuff:
		return
	
	var mouse = get_viewport().get_mouse_position()
	var camera = self
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * 5
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to,
							[], 0x1000)#0x20000)
							
	var col = result.get("collider")
	#print(result.has("collider"))
	#print(col, " vs ", the_notepad)
	var show_dia_message = false
	
	if col != null and col.is_in_group("Diary"):
		show_dia_message = true
		if Input.is_action_just_pressed("activate"):
			is_diary_mode = true
			show_dia_message = false
			
	label_dia_close.visible = show_dia_message
		#col.check_mouse()
		
var is_diary_mode = true
		
func _process(delta):
	if is_diary_mode:
		current = false
		diary_cam.current = true
		label_dia_open.visible = true
		label_dia_close.visible = false
		
		if Input.is_action_just_pressed("activate"):
			is_diary_mode = false
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		current = true
		diary_cam.current = false
		label_dia_open.visible = false
		
		check_rays_diary()
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if $YourStuff.showing_stuff:
		label_dia_close.visible = false
	
	check_rays()
	check_rays_notebook()
	
	
	if Input.is_action_just_pressed("open_tablet"):
		accum_tab += 1
		
	
	
	handle_accums(delta)
	
	
