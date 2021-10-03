extends Camera

func check_rays():
	var mouse = get_viewport().get_mouse_position()
	var camera = self
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * 5
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to,
							[], 0x400)#0x20000)
							
	var col = result.get("collider")
	#print(result.has("collider"))
	#print(col, " vs ", the_notepad)
	if col != null and col.is_in_group("TornPage"):
		col.activate_indicator()
		
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
		
func _process(delta):
	check_rays()
	check_rays_notebook()
