extends Control

# Main menu script handles all main menu functions. Mostly just signal callbacks.

# Use preload for now. This means that, as soon as the menu scene is loaded,
# loading the game scene will be practically instantaneous.
var Game: PackedScene = preload("res://Game.tscn")

func _on_PlayGameButton_pressed():
	get_tree().change_scene_to(Game)
