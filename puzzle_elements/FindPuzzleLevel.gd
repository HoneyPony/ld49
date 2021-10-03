extends Node2D

func _ready():
	# This is the sound effect for selecting a level...
	$Select.play()
	
	
	# Do this to clean up invalid instances.
	GS.current_puzzle_level = null
	
	var candidates = get_tree().get_nodes_in_group("Levels")
	
	for c in candidates:
		c.hide() # Hide all non-correct ones
		if c.id == GS.current_level_id:
			GS.current_puzzle_level = c
			c.show()
			
	GS.current_level_info = GS.find_level(GS.current_level_id)
	
	# Need to be sure level is loaded before doing this.
	get_node("Ship").reset_self()
