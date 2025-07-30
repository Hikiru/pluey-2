extends CharacterBody2D

var max_radius = 70
var slowness = 7
var player_local_mouse_pos = get_local_mouse_position()
var player_global_mouse_pos = get_global_mouse_position()
var last_mouse_pos = Vector2.ZERO
var mouse_idle_time = 0.0
var mouse_idle_threshold = 0.5
var idle = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	%MindwaveSprite.play("default")

func _physics_process(delta):
	# Mindwave & Cursor
	player_local_mouse_pos = get_local_mouse_position()
	player_global_mouse_pos = get_global_mouse_position()
	
	# Mouse idle check
	var mouse_delta = player_global_mouse_pos.distance_to(last_mouse_pos)
	if mouse_delta < 1.0 && player_local_mouse_pos.length() < max_radius:
		mouse_idle_time += delta
	else:
		mouse_idle_time = 0.0
	last_mouse_pos = player_global_mouse_pos
	
	if mouse_idle_time >= mouse_idle_threshold && not idle:
		idle = true
		print("idle")
	elif mouse_idle_time < mouse_idle_threshold && idle:
		idle = false
		print("not idle")
	
	if player_local_mouse_pos.length() > max_radius:
		%Mindwave.position = player_local_mouse_pos.normalized() * max_radius
	else:
		%Mindwave.position = player_local_mouse_pos

	%Cursor.position = player_local_mouse_pos
	if player_local_mouse_pos.length() > max_radius + 15:
		%Cursor.show()
	else:
		%Cursor.hide()

	# Player
	if abs(%Mindwave.position.x) >= 5:
		position.x = clamp((position.x + %Mindwave.position.x / slowness), 30, 610)
		%MelodySprite.play("default", clamp((abs(%Mindwave.position.x) / 70), 0.3, 2))
	else:
		if %MelodySprite.frame == 0:
			%MelodySprite.stop()
