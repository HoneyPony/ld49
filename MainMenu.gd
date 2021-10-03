extends Spatial

func _ready():
	get_tree().paused = false
	
	GS.reset_GS()

func _on_Button_pressed():
	get_tree().change_scene_to(GS.Main3D)

func _on_Quit_pressed():
	get_tree().quit()
