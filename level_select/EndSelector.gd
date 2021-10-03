extends ColorRect

func are_all_levels_won():
	#return true
	
	for l in GS.levels:
		if not l.has_won:
			return false
			
	return true

func _process(delta):
	visible = are_all_levels_won()
	
	
func end():
	var e = get_tree().get_nodes_in_group("EndScript")
	if e.size() > 0:
		e[0].anim()

func _on_No_pressed():
	end()


func _on_Yes_pressed():
	end()
