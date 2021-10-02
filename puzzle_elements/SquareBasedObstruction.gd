extends Sprite

export var width_px = 128
export var height_px = 128

func does_obstruct(pos: Vector2):
	var rect = Rect2(global_position - Vector2(width_px * 0.5, height_px * 0.5), Vector2(width_px, height_px))
	return rect.has_point(pos)
		
