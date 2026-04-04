extends Control

@onready var message_label = $MessagePanel/VBoxContainer/MessageLabel
@onready var play_again = $MessagePanel/VBoxContainer/PlayAgainButton

func _ready():
	hide()
	mouse_filter = Control.MOUSE_FILTER_STOP
	

func setup_popup(title: String, message: String = ""):
	# title: "YOU WIN!" or "YOU LOSE!"
	# message: optional extra info like "Time's Up!" or "Great job!"
	if message == "":
		message_label.text = title
	else:
		message_label.text = title + "\n" + message


func _on_play_again_button_pressed():
	print("Button pressed!")  # Debug - see if this prints
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Start.tscn")
