extends Spatial

onready var Sun = $Sun
onready var Earth = $EarthAnchor2/EarthAnchor/Earth
onready var EarthAnchor = $EarthAnchor2/EarthAnchor

var earth_rotation

var earth_rot_speed = deg2rad(10)
var earth_orbit_speed = deg2rad(3)

var sun_rot_speed = deg2rad(50)

func _ready():
	earth_rotation = Vector3.UP.rotated(Vector3.BACK, deg2rad(22))

func _physics_process(delta):
	Earth.rotate(earth_rotation, earth_rot_speed * delta)
	
	EarthAnchor.rotate_y(earth_orbit_speed * delta)
	
	$Sun.rotate(Vector3(0, 1, 1).normalized(), -sun_rot_speed * delta)
