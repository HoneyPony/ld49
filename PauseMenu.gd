extends ColorRect

onready var End = get_node("../../End/ColorRect")

func _process(delta):
	visible = get_tree().paused
	if End.force_pause:
		visible = false


func _on_Button_pressed():
	get_tree().paused = false
