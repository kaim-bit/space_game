extends Control



func _ready():
	hide()

func open():
	show()
	get_tree().paused = true

func close():
	hide()
	get_tree().paused = false

func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Start.tscn")

func _on_cancel_pressed():
	close()
