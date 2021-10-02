extends Control

func _process(delta):
	var width = rect_min_size.x
	var parent_width = get_parent().rect_size.x
	
	margin_left = (parent_width - width) / 2.0
