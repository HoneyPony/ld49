extends Node

# This script is used for managing anything that needs to be global state.
# Some people will say global states are bad. And they are, to a degree, correct.
# But for example, it makes much more sense to cache a Player node here than it
# does to have every single node try to grab the player using get_node() or
# get_nodes_in_group() or whatever.

var Game = preload("res://Game.tscn")
var LevelSelect = preload("res://LevelSelect.tscn")

var current_puzzle_level = null
var current_level_info = null

var ship = null

var has_L = false
var has_R = false
var has_Turb = false
var has_SL = false
var has_SR = false

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
