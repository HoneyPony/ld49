extends Sprite

func eval_win(player):
	var position_match = (global_position - player.global_position).length() < 1
	
	var my_rot = polar2cartesian(rotation, 1)
	var player_rot = polar2cartesian(player.rotation, 1)
	
	var rot_match = (my_rot - player_rot).length() < 0.05
	
	return position_match and rot_match
