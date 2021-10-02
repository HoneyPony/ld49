extends Control

# Main menu script handles all main menu functions. Mostly just signal callbacks.

# Use preload for now. This means that, as soon as the menu scene is loaded,
# loading the game scene will be practically instantaneous.

var Main3D: PackedScene = preload("res://Main3D.tscn")

func _on_PlayGameButton_pressed():
	get_tree().change_scene_to(Main3D)
