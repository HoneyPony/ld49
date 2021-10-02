extends Control

export var DEBUG_enable_all_abilities = false

func _ready():
	# Helper to keep this instance non-invalid
	GS.ship = null
	
	if DEBUG_enable_all_abilities:
		GS.has_L = true
		GS.has_R = true
		GS.has_Turb = true
		GS.has_SL = true
		GS.has_SR = true

func _process(delta):
	var width = rect_min_size.x
	var parent_width = get_parent().rect_size.x
	
	margin_left = (parent_width - width) / 2.0
