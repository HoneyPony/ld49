extends StaticBody

var indicate_timer = 0

export var which_ability = 0

func activate_indicator():
	indicate_timer = 0.08
	
func consume():
	GS.activate_ability(which_ability)
	hide()
	$Pickup.play_sfx()
	
	

func _process(delta):
	if visible == false:
		return
	
	indicate_timer = max(indicate_timer - delta, -1)
	
	$Indicator.visible = indicate_timer > 0
	
	if Input.is_action_just_pressed("activate") and indicate_timer > 0:
		consume()



func _on_Pickup_finished():
	if visible == false:
		queue_free()
