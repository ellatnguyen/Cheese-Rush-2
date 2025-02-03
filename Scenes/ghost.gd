extends Area2D
class_name Ghost
<<<<<<< Updated upstream
=======

# Signal emitted when the ghost's movement direction (cardinal) changes.
signal direction_change(direction: String)
>>>>>>> Stashed changes

@export var speed: float = 120.0
# An array of NodePaths to your scatter target nodes.
@export var scatter_targets: Array[NodePath] = []
@export var tile_map: TileMap
@export var color: Color
@onready var body_sprite=$BodySprite


var current_target_index: int = 0
# Stores the current cardinal direction as a string: "left", "right", "up", or "down".
var direction: String = ""

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	# Configure the NavigationAgent2D.
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 1.0 
	nav_agent.target_reached.connect(_on_target_reached)
	
	# If using a TileMap, assign its navigation map to the agent.
	if tile_map:
		var nav_map = tile_map.get_navigation_map(0)
		nav_agent.set_navigation_map(nav_map)
		NavigationServer2D.agent_set_map(nav_agent.get_rid(), nav_map)
	
	# If no scatter targets were assigned in the Inspector, assign some default paths.
	if scatter_targets.size() == 0:
		scatter_targets = [
			"/root/main/MovementTargets/RedGhost/scatter/Red1",
			"/root/main/MovementTargets/RedGhost/scatter/Red2",
			"/root/main/MovementTargets/RedGhost/scatter/Red3",
			"/root/main/MovementTargets/RedGhost/scatter/Red4"
		]
	
	# Start by setting the first scatter target.
	if scatter_targets.size() > 0:
		_set_target(scatter_targets[current_target_index])
	else:
		print("No scatter targets defined!")

func _process(delta: float) -> void:
	# -----------------------------------------------------------------------
	# IMPORTANT:
	# When NavigationAgent2D is a child of a moving node, its local position
	# remains fixed (usually (0,0)), so we “nudge” it by re-setting its target
	# each frame. This forces a recalculation of the path from the ghost's current
	# global position.
	# -----------------------------------------------------------------------
	nav_agent.set_target_position(nav_agent.target_position)
	
	# Retrieve the next point along the computed path.
	var next_point: Vector2 = nav_agent.get_next_path_position()
	var diff: Vector2 = next_point - global_position
	
	# If there's significant distance to the next point, move toward it.
	if diff.length() > 0.1:
		var move_dir: Vector2 = diff.normalized()
		
		# Determine the cardinal direction based on the movement vector.
		var new_direction: String = ""
		if abs(move_dir.x) > abs(move_dir.y):
			new_direction = "right" if move_dir.x > 0.0 else "left"
		else:
			new_direction = "down" if move_dir.y > 0.0 else "up"

		
		# If the cardinal direction has changed, update and emit the signal.
		if new_direction != direction:
			direction = new_direction
			emit_signal("direction_change", new_direction)
		
		# Move the ghost.
		position += move_dir * speed * delta

func _on_target_reached() -> void:
	print("Reached scatter target index:", current_target_index)
	# --- INSERT STOP CONDITION HERE IF NEEDED ---
	# For example, if you want to stop cycling under some condition:
	# if some_condition:
	#     return
	
	# Cycle to the next scatter target (wraps around automatically).
	current_target_index = (current_target_index + 1) % scatter_targets.size()
	_set_target(scatter_targets[current_target_index])

func _set_target(target_path: NodePath) -> void:
	var target_node = get_node_or_null(target_path)
	if target_node and target_node is Node2D:
		nav_agent.set_target_position(target_node.global_position)
		print("New target set:", target_node.name, "at", target_node.global_position)
	else:
		print("Error: Could not find scatter target node at:", target_path)
