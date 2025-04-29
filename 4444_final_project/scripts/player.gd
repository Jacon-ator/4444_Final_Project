extends CharacterBody2D

const tile_size = 32
var input_dir

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	# Input Checker
	if Input.is_action_just_pressed("ui_down"):
		input_dir = Vector2(0, 1)
	elif Input.is_action_just_pressed("ui_up"):
		input_dir = Vector2(0, -1)
	elif Input.is_action_just_pressed("ui_right"):
		input_dir = Vector2(1, 0)
	elif Input.is_action_just_pressed("ui_left"):
		input_dir = Vector2(-1, 0)
	else:
		# No input this frame
		input_dir = Vector2.ZERO

	# If there was input, move
	if input_dir != Vector2.ZERO:
		var motion = input_dir * tile_size #simulated grid based movement
		move_and_collide(motion)
