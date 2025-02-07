extends Area2D

@export var speed: float = 105

@export var scatter_targets: Array[NodePath] = []
@export var tile_map: TileMap

@export var texture_up: Texture2D
@export var texture_down: Texture2D
@export var texture_left: Texture2D
@export var texture_right: Texture2D

@export var chase_enabled: bool = false

var current_target_index: int = 0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: Sprite2D = $BodySprite


@export var cage_position_node: Node2D

func _ready() -> void:
	# Event Handler
	if event_handler:
		event_handler.best_battle.connect(_on_best_battle)
		event_handler.better_battle.connect(_on_better_battle)
		event_handler.good_battle.connect(_on_good_battle)
		
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 1.0
	nav_agent.target_reached.connect(_on_target_reached)

	if tile_map:
		var nav_map = tile_map.get_navigation_map(0)
		nav_agent.set_navigation_map(nav_map)
		NavigationServer2D.agent_set_map(nav_agent.get_rid(), nav_map)

	if scatter_targets.size() == 0:
		scatter_targets = [
			"/root/main/MovementTargets/RedGhost/scatter/Red1",
			"/root/main/MovementTargets/RedGhost/scatter/Red2",
			"/root/main/MovementTargets/RedGhost/scatter/Red3",
			"/root/main/MovementTargets/RedGhost/scatter/Red4"
		]

	# Start by setting the first scatter target
	if scatter_targets.size() > 0:
		_set_target(scatter_targets[current_target_index])

func _process(delta: float) -> void:
	# Only move if chase_enabled = true
	if not chase_enabled:
		return

	# "Nudge" the agent every frame so it recalculates from our current position
	nav_agent.set_target_position(nav_agent.target_position)

	# Get the next point along the computed path
	var next_point: Vector2 = nav_agent.get_next_path_position()
	var diff: Vector2 = next_point - global_position

	if diff.length() > 0.1:
		# Determine the direction of movement
		var direction: Vector2 = diff.normalized()
		_update_sprite_direction(direction)

		# Move the ghost
		position += direction * speed * delta

func _update_sprite_direction(direction: Vector2) -> void:
	# Determine which texture to use, based on movement direction
	if abs(direction.x) > abs(direction.y):
		# Horizontal
		if direction.x > 0:
			sprite.texture = texture_right
		else:
			sprite.texture = texture_left
	else:
		# Vertical
		if direction.y > 0:
			sprite.texture = texture_down
		else:
			sprite.texture = texture_up

func _on_target_reached() -> void:
	# The ghost reached its current scatter target
	current_target_index = (current_target_index + 1) % scatter_targets.size()
	_set_target(scatter_targets[current_target_index])

func _set_target(target_path: NodePath) -> void:
	var target_node = get_node_or_null(target_path)
	if target_node and target_node is Node2D:
		nav_agent.set_target_position(target_node.global_position)


# Teleport the ghost to the "cage" for 7 sec

func teleport_back_to_cage_for_7_seconds() -> void:
	chase_enabled = false

	if cage_position_node:
		global_position = cage_position_node.global_position
	
	# Setting the target position to the same position ensures no path
	nav_agent.set_target_position(global_position)

	var cage_timer = Timer.new()
	cage_timer.wait_time = 7.0
	cage_timer.one_shot = true
	cage_timer.connect("timeout", Callable(self, "_on_CageTimer_timeout"))
	add_child(cage_timer)
	cage_timer.start()

func _on_CageTimer_timeout() -> void:
	chase_enabled = true
	if scatter_targets.size() > 0:
		_set_target(scatter_targets[current_target_index])


func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		event_handler.emit_signal("battle_started")
		print("Ghost hit") # Debug- delete later
		#if false:
			##event_handler.emit_signal("battle_started")
			##print("Ghost hit") # Debug- delete later
			#pass
		#else:
			#var anim_player = get_node("/root/main/GameOverUI/AnimationPlayer2")
			#var full_screen_image = get_node("/root/main/GameOverUI/FullScreenImage")
			#var color = get_node("/root/main/GameOverUI/ColorRect")
			#color.visible=true
			#full_screen_image.visible= true
			#get_tree().paused=true
			#anim_player.play("lose_screen_fade")

func _on_best_battle():
	print("Scatter Best battle!")  

func _on_better_battle():
	print("Scatter Better battle!")  

func _on_good_battle():
	print("Scatter Good battle!")  
