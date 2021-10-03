extends Spatial

func _ready():
	get_tree().paused = false
	
	GS.reset_GS()
	
	if GS.very_first_load:
		GS.very_first_load = false
		#OS.set_window_maximized(true)

func _on_Button_pressed():
	get_tree().change_scene_to(GS.Main3D)

func _on_Quit_pressed():
	get_tree().quit()
