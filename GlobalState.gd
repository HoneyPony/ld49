extends Node

# This script is used for managing anything that needs to be global state.
# Some people will say global states are bad. And they are, to a degree, correct.
# But for example, it makes much more sense to cache a Player node here than it
# does to have every single node try to grab the player using get_node() or
# get_nodes_in_group() or whatever.

var Game = preload("res://Game.tscn")
var LevelSelect = preload("res://LevelSelect.tscn")
var Main3D = preload("res://Main3D.tscn")
var MainMenu = preload("res://MainMenu.tscn")

var hover_prev_button = false
var hover_next_button = false

var current_puzzle_level = null
var current_level_info = null

var ship = null

var has_L = false
var has_R = false
var has_Turb = false
var has_SL = false
var has_SR = false

var has_DirB = false

var second_ls_load = false

# THIS ONE IS NOT RESET!!!
var very_first_load = true

# This one is also not reset
var invert_mouse = false

#func web_change_scene(s):
#	var cur = get_tree().get_nodes_in_group("CurrentScene")
#	for n in cur:
#		n.queue_free()
#
#	var ins = s.instance()
#	get_node("/root").add_child(ins)

func set_mouse_mode(mode):
	if mode == Input.MOUSE_MODE_CAPTURED:
		WebMouseWorkaround.get_node("Cursor").visible = false
	if mode == Input.MOUSE_MODE_VISIBLE:
		WebMouseWorkaround.get_node("Cursor").visible = true

func get_mouse_position():
	return WebMouseWorkaround.get_node("Cursor").position

func get_good_camera_ray():
	var s = get_viewport().size
	s.x /= 2
	s.y /= 2
#	s.y = 3 * s.y
	return s

func reset_GS():
	hover_prev_button = false
	hover_next_button = false
	
	current_puzzle_level = null
	current_level_info = null

	ship = null

	has_L = false
	has_R = false
	has_Turb = false
	has_SL = false
	has_SR = false

	second_ls_load = false
	
	current_level_id = -1
	
	levels = [
		augment_level(LevelInfo.new(1), ""),
		LevelInfo.new(2),
		LevelInfo.new(3, true),
		LevelInfo.new(4, true),
		LevelInfo.new(5, false, true),
		LevelInfo.new(6, true, true),
		LevelInfo.new(7, true, true),
		LevelInfo.new(8, true, false, true),
		LevelInfo.new(9, false, true, true),
		LevelInfo.new(10, false, false, false, true),
		LevelInfo.new(11, true, false, false, true, true),
		LevelInfo.new(12, true, false, false, false, true),
		
		LevelInfo.new(13, true, true, true),
		LevelInfo.new(14, true, false, true),
		LevelInfo.new(15, true, true, true, true, true),
	]

func activate_ability(which):
	if which == 0:
		has_L = true
	if which == 1:
		has_R = true
	if which == 2:
		has_Turb = true
	if which == 3:
		has_SL = true
	if which == 4:
		has_SR = true
		
	if which == 5:
		has_DirB = true

var current_level_id = -1

class LevelInfo:
	var id
	var reqL
	var reqR
	var reqTurb
	
	var reqSL
	var reqSR
	
	var has_won
	var last_code
	
	func _init(_id, _reqL = false, _reqR = false, _reqTurb = false, _reqSL = false, _reqSR = false):
		id = _id
		reqL = _reqL
		reqR = _reqR
		reqTurb = _reqTurb
		reqSL = _reqSL
		reqSR = _reqSR
		
		has_won = false
		last_code = ""

func augment_level(lvl, code):
	lvl.last_code = code
	return lvl

var levels = [
	augment_level(LevelInfo.new(1), ""),
	LevelInfo.new(2),
	LevelInfo.new(3, true),
	LevelInfo.new(4, true),
	LevelInfo.new(5, false, true),
	LevelInfo.new(6, true, true),
	LevelInfo.new(7, true, true),
	LevelInfo.new(8, true, false, true),
	LevelInfo.new(9, false, true, true),
	LevelInfo.new(10, false, false, false, true),
	LevelInfo.new(11, true, false, false, true, true),
	LevelInfo.new(12, true, false, false, false, true),
	
	LevelInfo.new(13, true, true, true),
	LevelInfo.new(14, true, false, true),
	LevelInfo.new(15, true, true, true, true, true),
]

func find_level(id):
	for l in levels:
		if l.id == id:
			return l
			
	return null
	
func is_level_avail(level):
	if level == null:
		return false
		
	if level.reqL and not has_L:
		return false
		
	if level.reqR and not has_R:
		return false
		
	if level.reqTurb and not has_Turb:
		return false
		
	if level.reqSL and not has_SL:
		return false
		
	if level.reqSR and not has_SR:
		return false
		
	return true
	
func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	
func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
