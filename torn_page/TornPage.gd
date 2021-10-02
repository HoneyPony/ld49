extends StaticBody

var indicate_timer = 0

export var which_ability = 0

func activate_indicator():
	indicate_timer = 0.08
	
func consume():
	GS.activate_ability(which_ability)
	queue_free()

func _process(delta):
	indicate_timer = max(indicate_timer - delta, -1)
	
	$Indicator.visible = indicate_timer > 0
	
	if Input.is_action_just_pressed("activate") and indicate_timer > 0:
		consume()

