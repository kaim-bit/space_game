extends Area2D


signal planet_collected



@onready var vacuum_area: Area2D = $VacuumArea # Area used to detect nearby objects
@onready var vacuum_audio = $VacuumSound
@onready var collect_audio = $CollectSound


@export var speed := 400  # pixels per second

var is_collecting := false  # Prevent multiple collections at once


func _process(delta):
	
	handle_movement(delta)
	handle_vacuum(delta)

# --- Movement ---	
func handle_movement(delta):
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

# --- Vacuuming ---
func	 handle_vacuum(delta):
	var vacuuming := Input.is_action_pressed("vacuum") # Spacebar

	if vacuuming:
		if not vacuum_audio.playing:
			vacuum_audio.play()
		#else:
			#if vacuum_audio.playing:
				#vacuum_audio.stop()
					#
		var bodies_in_range = vacuum_area.get_overlapping_bodies()
		for body in bodies_in_range:
			if body.is_in_group("planets"):
				var direction = (global_position - body.global_position).normalized()
				var pull_strength = 200
				body.global_position += direction * pull_strength * delta
				


func _on_body_entered(body):
	if body.is_in_group("planets") and not is_collecting:
		is_collecting = true
		
		emit_signal("planet_collected")
		collect_audio.play()
		#body.set_deferred("monitoring", false)
		#body.set_deferred("monitorable", false)
		
		# Get planet visual components
		#var sprite = body.get_node("Sprite2D")
		#var original_scale = body.scale
		#var original_color = sprite.modulate
		#
		## POP EFFECT: Scale up and flash white
		#var tween = create_tween()
		#tween.set_parallel(true)
		#tween.tween_property(body, "scale", original_scale * 1.8, 0.08)
		#tween.tween_property(sprite, "modulate", Color.WHITE, 0.08)
#
		## Wait for pop
		#await tween.finished
		
		# Scale back down
		#tween = create_tween()
		#tween.set_parallel(true)
		#tween.tween_property(body, "scale", original_scale, 0.08)
		#tween.tween_property(sprite, "modulate", original_color, 0.08)
		#
		#await tween.finished
		# Teleport the planet - THIS GOES IN SUN SCRIPT
		var main = get_node("/root/main")
		if main:
			body.set_deferred("global_position", main.get_random_position())
			#randomize_planet_appearance(body)
		is_collecting = false	
			#body.global_position = main.get_random_position()
		#body.queue_free() # remove planet (collected)
	#
	#if not is_instance_valid(planet):
		#return
		#
	#planet.monitoring = false
#
	## prevent double collection while animating
	##planet.set_deferred("monitoring", false)
#
	#var sprite = planet.get_node("Sprite2D")
	#var original_scale = sprite.scale
#
	#var tween = get_tree().create_tween()
	#tween.tween_property(sprite, "scale", original_scale * 1.4, 0.07)
	#tween.tween_property(sprite, "scale", original_scale * 0.1, 0.08)
#
	#await tween.finished
	#
	## reset scale BEFORE teleport
	#sprite.scale = original_scale
#
	#var main = get_node("/root/main")
	#if main:
		#planet.set_deferred("global_position", main.get_random_position())
#
## re-enable collision detection
	#await get_tree().process_frame
	#planet.monitoring = true
	### re-enable after teleport
	##planet.set_deferred("monitoring", true)

func teleport_planet(planet):
	var main = get_node("/root/main")  # Use absolute path
	if main:
		
		planet.global_position = main.get_random_position()
		
		# Optional: Also randomize the planet's appearance again
		randomize_planet_appearance(planet)
	else:
		print("ERROR: Cannot find main node")

func randomize_planet_appearance(planet):
	## Re-randomize texture, scale, and rotation for variety
	var main = get_node("/root/main")
	if main and main.planet_textures.size() > 0:
		# Random texture
		var tex = main.planet_textures[randi() % main.planet_textures.size()]
		#var body = planet.get_node("Earth")
		var sprite = planet.get_node("Sprite2D")
		sprite.set_texture(tex)
		
		# Random rotation
		sprite.rotation = randf() * TAU
		
		# Random scale
		var s = 2 + randf() * 1.2
		sprite.scale = Vector2(s, s)
