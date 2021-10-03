extends MeshInstance

var rot_speed = deg2rad(1)

func _physics_process(delta):
	rotate_y(-rot_speed * delta)
