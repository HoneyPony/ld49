extends Sprite

export var width_px = 128
export var height_px = 128

export var is_rot_gate = false

func _physics_process(delta):
	if is_rot_gate:
		var s = GS.ship
		if s != null:
			rotation = s.rotation

func does_obstruct(pos: Vector2):
	var rect = Rect2(global_position - Vector2(width_px * 0.5, height_px * 0.5), Vector2(width_px, height_px))
	
	if is_rot_gate:
		var s = GS.ship
		if s != null:
			var rot_as_vec = polar2cartesian(1, rotation)
			var rotation_to_self = global_position - s.global_position
			#print("t: ", rot_as_vec, " ", rotation_to_self)
			if (rot_as_vec - rotation_to_self.normalized()).length() < 0.001:
				return false
	
	return rect.has_point(pos)
		
