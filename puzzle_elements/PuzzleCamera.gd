extends Camera2D

func _process(delta):
	var p = GS.current_puzzle_level
	if p != null:
		var w = p.needed_width_tiles * 64
		var h = p.needed_height_tiles * 64
		
		var vs = get_viewport().size
		var avail_width = vs.x
		var avail_height = vs.y - 64
		
		var fw = avail_width / w
		var fh = avail_height / h
		var best_zoom = min(fw, fh)
		
		best_zoom = 1 / best_zoom
		
		zoom = Vector2(best_zoom, best_zoom)
		
		var cam_place = p.get_node_or_null("CameraPlace")
		if cam_place != null:
			global_position = cam_place.global_position
	
		
