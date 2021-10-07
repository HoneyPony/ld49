extends ColorRect

var force_pause = false

func _ready():
	$Label.visible = false
	$Button.visible = false
	visible = false
	pass
	
func anim():
	$AnimationPlayer.play("OnEndWeb")

func pause():
	get_tree().paused = true
	force_pause = true
	
func _process(delta):
	if force_pause:
		get_tree().paused = true

func _on_Button_pressed():
	get_tree().quit()
