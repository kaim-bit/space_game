extends RigidBody2D


@export var planet_texture: Texture2D 


func set_texture(tex: Texture2D) -> void:
	$Sprite2D.texture = tex
