# enemy.gd
extends CharacterBody2D

const TILE_SIZE = 32

@export var player_node: Node2D
@export var tile_map_node: TileMapLayer

var current_path: Array[Vector2i] = []

@onready var move_timer: Timer = $MoveTimer
var can_move: bool = true

func _ready():
	# Ensure the Timer node exists
	if not has_node("MoveTimer"):
		push_error("Enemy AI: MoveTimer node not found! Add a Timer node named 'MoveTimer' as a child.")
		set_physics_process(false)
		return

	# Connect the timer's timeout signal
	move_timer.timeout.connect(_on_move_timer_timeout)
	move_timer.one_shot = true # Ensure it's one-shot

	# Initial setup
	if player_node == null:
		push_error("Enemy AI: Player node not assigned!")
	if tile_map_node == null:
		push_error("Enemy AI: TileMapLayer node not assigned!")
	
	# Set initial position snapped to grid if needed
	if tile_map_node != null:
		global_position = tile_map_node.map_to_local(tile_map_node.local_to_map(global_position))
	else:
		push_error("Enemy AI: Cannot snap to grid, TileMapLayer node is null in _ready()!")

# Use @warning_ignore("unused_parameter") to silence the delta warning
@warning_ignore("unused_parameter")
func _physics_process(delta: float):
	if not can_move:
		return

	# Basic checks
	if player_node == null or tile_map_node == null:
		return

	# --- Pathfinding Logic --- (Only runs when can_move is true)
	var start_tile = tile_map_node.local_to_map(global_position)
	var end_tile = tile_map_node.local_to_map(player_node.global_position)

	# Don't recalculate path if already at the target tile
	if start_tile == end_tile:
		return

	current_path = calculate_custom_path(start_tile, end_tile)

	# --- Movement Logic --- (Only runs when can_move is true)
	if not current_path.is_empty():
		var next_tile: Vector2i = current_path.pop_front()
		if is_tile_walkable(next_tile):
			# Snap to the next tile position instantly
			global_position = tile_map_node.map_to_local(next_tile)

			# Prevent moving again until timer finishes
			can_move = false
			move_timer.start() # Start the timer using its configured wait_time
	else:
		pass # Do nothing if path is empty, wait for next cycle

# --- Timer Callback ---
func _on_move_timer_timeout():
	can_move = true # Allow movement calculation again

# --- Helper Functions ---

func calculate_custom_path(start_tile: Vector2i, end_tile: Vector2i) -> Array[Vector2i]:
	# Basic Breadth-First Search (BFS) Implementation
	var queue: Array[Vector2i] = [start_tile]
	var visited: Dictionary = {start_tile: null} # Using a dictionary to store path: {tile: previous_tile}

	while not queue.is_empty():
		var current_tile = queue.pop_front()

		if current_tile == end_tile:
			# Path found, reconstruct it
			var path: Array[Vector2i] = []
			var step = end_tile
			while step != start_tile:
				# Check if the step exists in visited before accessing it
				if not visited.has(step):
					push_error("Error reconstructing path: step not found in visited dictionary.")
					return [] # Return empty path on error
				path.push_front(step)
				step = visited[step] # Backtrack using the stored path
			return path

		# Explore neighbors (Up, Down, Left, Right)
		var neighbors = [
			current_tile + Vector2i.UP,
			current_tile + Vector2i.DOWN,
			current_tile + Vector2i.LEFT,
			current_tile + Vector2i.RIGHT
		]

		for neighbor in neighbors:
			# Check if walkable and not visited
			if is_tile_walkable(neighbor) and not visited.has(neighbor):
				visited[neighbor] = current_tile # Record path: came from current_tile
				queue.push_back(neighbor) # Add to queue for exploration

	return [] # Return empty array if no path is found

func is_tile_walkable(tile_coord: Vector2i) -> bool:
	if tile_map_node == null:
		return false # Cannot determine walkability

	# Check if the tile exists and if it has collision
	# Assumes your wall tiles are on physics layer 1 (or adjust as needed)
	# You might need more sophisticated checks based on your TileSet setup
	# Using layer 0 for get_cell_tile_data
	var tile_data = tile_map_node.get_cell_tile_data(tile_coord)
	if tile_data == null:
		# Check if the coordinate is outside the used rectangle of the map
		var map_rect = tile_map_node.get_used_rect()
		if not map_rect.has_point(tile_coord):
			return false # Outside map bounds is not walkable
		return true # Assume empty space within map bounds is walkable

	# Check if the specific tile has collision configured
	# Assuming collision is on physics layer 0 of the tile data
	var collision_polygons = tile_data.get_collision_polygons_count(0) # Physics Layer 0
	return collision_polygons == 0 # Walkable if no collision shapes on this tile
