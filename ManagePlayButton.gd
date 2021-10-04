extends Control

func _on_StopButton_pressed():
	$PlayButton.visible = true
	$StopButton.visible = false
	$Button.play_usual()

func _on_PlayButton_pressed():
	$PlayButton.visible = false
	$StopButton.visible = true
	$Button.play_usual()
