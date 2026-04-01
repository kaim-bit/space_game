extends Control





func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	



func _on_controls_pressed():
	get_tree().change_scene_to_file("res://scenes/controls.tscn")


func _on_end_pressed():
	get_tree().quit()
