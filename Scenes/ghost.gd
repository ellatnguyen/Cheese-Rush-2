extends Area2D
var current_scatter_index =0
@export var speed = 120
@export var movement_targets: Resource
@export var tile_map: TileMap
@onready var navigation_agent_2d = $NavigationAgent2D

func _ready():
	navigation_agent_2d.path_desired_distance= 4.0
	navigation_agent_2d.target_desired_distance= 4.0
	navigation_agent_2d.target_reached.connect(on_position_reached)

	call_deferred("setup")


func scatter():
	navigation_agent_2d.target_position = movement_targets.scatter_targets[current_scatter_index]

func _process(delta):
	move_ghost(navigation_agent_2d.get_next_path_position(), delta)
	
func move_ghost(next_position: Vector2, delta: float):
	var current_ghost_position = global_position
	
	var new_velocity = (next_position - current_ghost_position).normalized() * speed * delta
	position += new_velocity
	

func setup():
	navigation_agent_2d.set_navigation_map(tile_map.get_navigation_map(0))
	NavigationServer2D.agent_set_map(navigation_agent_2d.get_rid(),tile_map.get_navigation_map(0))
	scatter()

func on_position_reached():
	if current_scatter_index < 3:
		current_scatter_index +=1
	else:
		current_scatter_index=0
	navigation_agent_2d.target_position = movement_targets.scatter_targets[current_scatter_index]
