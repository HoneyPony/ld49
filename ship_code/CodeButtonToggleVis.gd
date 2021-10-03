extends TextureButton

func _vis():
	visible = not visible
	
	var b = get_node_or_null("Button")
	if b != null:
		# We want to only play 1 sfx, which is inconvenient because of early
		# silly decisions. lol
		b.play_usual()
