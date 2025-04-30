# enemy.gd
extends CharacterBody2D

const TILE_SIZE = 32

@export var player_node: Node2D
@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D



func makePathToPlayer():
	# updated the path to player position
	if is_instance_valid(player_node):
		navigation_agent.target_position = player_node.global_position
	else:
		print("Player node is not valid.")
		$Timer.stop()


func _on_timer_timeout() -> void:
	makePathToPlayer()

	# while enemy not at player
	if not navigation_agent.is_navigation_finished():
		# determine player position and make a path towards them
		var current_agent_position := global_position
		var next_path_position := navigation_agent.get_next_path_position()
		
		var direction_vector = (next_path_position - current_agent_position).normalized()

		# grid movement 
		var grid_direction = Vector2.ZERO
		if abs(direction_vector.x) > abs(direction_vector.y):
			grid_direction.x = sign(direction_vector.x)
		else:
			grid_direction.y = sign(direction_vector.y)
			
		# prevents diagional movement
		if grid_direction == Vector2.ZERO and direction_vector != Vector2.ZERO:
			# edge cases
			if abs(direction_vector.x) > 0.01: # Use a small threshold
				grid_direction.x = sign(direction_vector.x)
			elif abs(direction_vector.y) > 0.01:
				grid_direction.y = sign(direction_vector.y)

		# only move when valid move available
		if grid_direction != Vector2.ZERO:
			var motion = grid_direction * TILE_SIZE
			move_and_collide(motion)
