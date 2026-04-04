extends Node2D

@onready var pause_popup = $CanvasLayer/PausePopup
@onready var game_popup = $CanvasLayer/GamePopup
@onready var score_label = $UI/ScoreLabel
@onready var timer_label = $UI/TimerLabel
@onready var sun_scene = $Sun 


var score := 0
var time_left: float = 60.0
var game_active := true

@export var planet_scene: PackedScene          # assign Planet.tscn
@export var planet_textures: Array[Texture2D] = []  # assign textures
@export var planet_count: int = 10
@export var spawn_area_size: Vector2 = Vector2(3000, 3000)
@export var win_score: int = 25
@export var start_time: float = 60.0

func _ready():
	
	var sun = $Sun/Sun
	sun.connect("planet_collected", Callable(self, "_on_planet_collected"))

	
	time_left = start_time
	update_timer_display()
	
	# Spawn Planets
	randomize()
	for i in planet_count:
		var planet = planet_scene.instantiate()
		
		# pick a random texture and assign it
		var tex = planet_textures[randi() % planet_textures.size()]
		planet.get_node("Earth").set_texture(tex)
		
		# random position in world
		var x = randf() * spawn_area_size.x - spawn_area_size.x / 2
		var y = randf() * spawn_area_size.y - spawn_area_size.y / 2
		planet.global_position = Vector2(x, y)
		
		# random rotation
		var body = planet.get_node("Earth")
		body.get_node("Sprite2D").set_texture(tex)
		body.get_node("Sprite2D").rotation = randf() * TAU
		
		# random scale
		var s = 2 + randf() * 0.7
		body.get_node("Sprite2D").scale = Vector2(s, s)
	
		
		add_child(planet)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if pause_popup.visible:
			pause_popup.close()
		else:
			pause_popup.open()		
	
	# Timer countdown (only if game is active and popup not showing)
	if game_active and not game_popup.visible:
		time_left -= delta
		update_timer_display()
		# Check lose condition
		if time_left <= 0:
			time_left = 0
			show_game_popup("YOU LOSE!", "Time's Up!")

func update_timer_display():
	timer_label.text = "Time: %.1f" % time_left	
	
func _on_planet_collected():
	if not game_active:
		return
	
	score +=1
	score_label.text = "Planets Collected: %d" % score
	# Bonus time when collecting a planet (optional)
	time_left += 0.5
	update_timer_display()
	
	# Check win condition
	if score >= win_score:
		show_game_popup("YOU WIN!", "Collected " + str(score) + " planets!")
		
func show_game_popup(title: String, message: String = ""):
	game_active = false
	sun_scene.process_mode = Node.PROCESS_MODE_DISABLED
	game_popup.show()
	game_popup.setup_popup(title, message)
	
	#await get_tree().process_frame
	#get_tree().paused = true
	
func get_random_position():
	var x = randf() * spawn_area_size.x - spawn_area_size.x / 2
	var y = randf() * spawn_area_size.y - spawn_area_size.y / 2
	return Vector2(x, y)
