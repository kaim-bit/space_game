extends Control


@onready var music = $MusicPlayer

func _ready():
	music.seek(8.0)
	music.play()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Start.tscn")
