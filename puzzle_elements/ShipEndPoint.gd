extends Sprite

var ship

func _ready():
	ship = get_tree().get_nodes_in_group("TheShip")[0]

func eval_win(player):
	var position_match = (global_position - player.global_position).length() < 1
	
	#print("S: ", global_position, " ", player.global_position)
	
	var my_rot = polar2cartesian(1, rotation)
	var player_rot = polar2cartesian(1, player.rotation)
	
#	print("R: ", my_rot, " ", player_rot)
	
	var rot_match = (my_rot - player_rot).length() < 0.1
	
	var code_match = ship.code_string.length() <= 1
	
	return position_match and rot_match and code_match
