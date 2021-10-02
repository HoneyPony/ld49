extends TextureButton

export var level_id = 1

func _ready():
	var label_str = String(level_id)
	if label_str.length() < 2:
		label_str = "0" + label_str
		
	$Label.text = label_str
		
	var level = GS.find_level(level_id)
	$Hard.visible = not GS.is_level_avail(level)
	
	$Completed.visible = false
	if level != null:
		if level.has_won:
			$Completed.visible = true
			$Hard.visible = false


func _on_LevelButton_pressed():
	GS.current_level_id = level_id
	
	var viewport = get_viewport()
	for child in viewport.get_children():
		child.queue_free()
		
	var game = GS.Game.instance()
	viewport.add_child(game)
