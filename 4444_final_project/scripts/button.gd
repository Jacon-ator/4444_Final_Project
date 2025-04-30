extends Button

@export var enemy_node: Node2D

func _pressed():
	if enemy_node == null:
		push_error("Button: enemy_node is null! Did you assign it in Inspector?")
		return

	# gets agent
	var agent := enemy_node.get_node("NavigationAgent2D") as NavigationAgent2D
	if agent:
		agent.debug_enabled = not agent.debug_enabled
	else:
		#error checking
		push_error("Button: Couldn't find NavigationAgent2D under '%s'" % enemy_node.name)
