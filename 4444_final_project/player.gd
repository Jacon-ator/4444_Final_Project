extends CharacterBody2D

const tile_size = 32
# Removed move_speed as movement is now instant per frame
# Removed moving variable
var input_dir

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	# Check for input - use is_action_just_pressed for single step per press
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

	# If there was input, attempt to move
	if input_dir != Vector2.ZERO:
		var motion = input_dir * tile_size
		move_and_collide(motion)
