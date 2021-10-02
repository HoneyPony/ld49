extends Button



func _on_BackButton_pressed():

	
	var viewport = get_viewport()
	for child in viewport.get_children():
		child.queue_free()
		
	var ls = GS.LevelSelect.instance()
	viewport.add_child(ls)
