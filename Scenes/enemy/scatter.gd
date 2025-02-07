extends Area2D

@export var speed: float = 105
@export var scatter_targets: Array[NodePath] = []
@export var tile_map: TileMap
@export var chase_enabled: bool = true  # Normal scatter mode is enabled by default.
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: Sprite2D = $BodySprite
var current_target_index: int = 0
@export var cage_position_node: Node2D


var was_just_hit: bool = false
const PoofEffect = preload("res://Scenes/enemy/poof.tscn")


func _ready() -> void:
	# Connect battle signals if event_handler exists.
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

	# Populate scatter_targets if not set via the editor.
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

func _process(delta: float) -> void:
	# Only move along the scatter path if chase_enabled is true.
	if not chase_enabled:
		return

	# "Nudge" the agent every frame so it recalculates its path.
	nav_agent.set_target_position(nav_agent.target_position)

	# Get the next point along the computed path.
	var next_point: Vector2 = nav_agent.get_next_path_position()
	var diff: Vector2 = next_point - global_position

	if diff.length() > 0.1:
		var direction: Vector2 = diff.normalized()
		_update_sprite_direction(direction)
		# Move the cat manually.
		global_position += direction * speed * delta


func _update_sprite_direction(direction: Vector2) -> void:
	# Play the appropriate animation based on movement direction.
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$CatAnimation.play("cat_right_ani")
		else:
			$CatAnimation.play("cat_left_ani")
	else:
		if direction.y > 0:
			$CatAnimation.play("cat_down_ani")
		else:
			$CatAnimation.play("cat_up_ani")

func _on_target_reached() -> void:
	# When the current scatter target is reached, cycle to the next target.
	current_target_index = (current_target_index + 1) % scatter_targets.size()
	_set_target(scatter_targets[current_target_index])

func _set_target(target_path: NodePath) -> void:
	var target_node = get_node_or_null(target_path)
	if target_node and target_node is Node2D:
		nav_agent.set_target_position(target_node.global_position)

func teleport_back_to_cage_for_7_seconds() -> void:
	# For best and better battle outcomes.
	chase_enabled = false
	if cage_position_node:
		global_position = cage_position_node.global_position

	nav_agent.set_target_position(global_position)
	var cage_timer = Timer.new()
	cage_timer.wait_time = 10.0
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
		was_just_hit = true
		event_handler.emit_signal("battle_started")
		print("Scatter cat hit!")

func _on_best_battle() -> void:
	show_poof_at_position(global_position)
	teleport_back_to_cage_for_7_seconds()  

func _on_better_battle() -> void:
	if was_just_hit:
		show_poof_at_position(global_position)
		teleport_back_to_cage_for_7_seconds()
		was_just_hit = false

func _on_good_battle() -> void:
	print("Scatter Good battle: freezing cat for 5 seconds!")
	chase_enabled = false  # Stop normal scatter movement.
	# Start a timer to unfreeze after 5 seconds.
	var freeze_timer = Timer.new()
	freeze_timer.wait_time = 5.0
	freeze_timer.one_shot = true
	freeze_timer.connect("timeout", Callable(self, "_on_FreezeTimer_timeout"))
	add_child(freeze_timer)
	freeze_timer.start()



func _on_FreezeTimer_timeout() -> void:
	# Unfreeze the_ cat so it resumes its scatter movement.
	chase_enabled = true

func show_poof_at_position(pos: Vector2) -> void:
	var poof = PoofEffect.instantiate()
	get_tree().current_scene.add_child(poof)
	poof.global_position = pos
	poof.get_node("AnimatedSprite2D").play("poof")
