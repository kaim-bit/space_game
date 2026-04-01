extends Area2D

@onready var vacuum_area: Area2D = $VacuumArea # Area used to detect nearby objects

@export var speed := 400  # pixels per second


func _process(delta):
	var input_vector := Vector2.ZERO
	# WASD or arrow keys
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	
	# Normalize to prevent faster diagonal movement
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
	
	position += input_vector * speed * delta
	
	
	var vacuuming := Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT) # True when holding left click
	if vacuuming:
		var nearby = vacuum_area.get_overlapping_bodies()
		if nearby.size() > 0:
			print("Objects in vacuum range: ", nearby.size())
	
