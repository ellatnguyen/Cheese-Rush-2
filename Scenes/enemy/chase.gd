extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target_to_chase: CharacterBody2D
@onready var sprite: Sprite2D = $BodySprite
const spd = 120
const run_away_spd = 240
@export var chase_enabled: bool = false
@export var cage_position_node: Node2D
var was_just_hit: bool = false

const PoofEffect = preload("res://Scenes/enemy/poof.tscn")
var runaway_enabled: bool = false

func _ready() -> void:
	# Connect event signals
	if event_handler:
		event_handler.best_battle.connect(_on_best_battle)
		event_handler.better_battle.connect(_on_better_battle)
		event_handler.good_battle.connect(_on_good_battle)
		
	# 10-second delay before chase begins
	var chase_timer = Timer.new()
	chase_timer.wait_time = 10.0
	chase_timer.one_shot = true
	chase_timer.connect("timeout", Callable(self, "_on_ChaseTimer_timeout"))
	add_child(chase_timer)
	chase_timer.start()

func _physics_process(delta: float) -> void:
	if runaway_enabled:
		# Compute the direction away from the target:
		var direction = (global_position - target_to_chase.global_position).normalized()
		velocity = direction * run_away_spd
		move_and_slide()
		_update_sprite_direction(velocity)
	elif chase_enabled:
		# Set the navigation agent's target and move toward it.
		navigation_agent.target_position = target_to_chase.global_position
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * spd
		move_and_slide()
		_update_sprite_direction(velocity)
	# If neither runaway nor chase is enabled, the cat remains frozen.

func _update_sprite_direction(direction: Vector2) -> void:
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

func _on_ChaseTimer_timeout() -> void:
	chase_enabled = true

func teleport_back_to_cage_for_7_seconds() -> void:
	chase_enabled = false
	if cage_position_node:
		global_position = cage_position_node.global_position
	velocity = Vector2.ZERO

	# Start a cage timer.
	var cage_timer = Timer.new()
	cage_timer.wait_time = 10.0
	cage_timer.one_shot = true
	cage_timer.connect("timeout", Callable(self, "_on_CageTimer_timeout"))
	add_child(cage_timer)
	cage_timer.start()

func _on_CageTimer_timeout() -> void:
	chase_enabled = true

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		was_just_hit = true
		event_handler.emit_signal("battle_started")
		# Debug message:
		#print("Chase cat hit!")

func _on_best_battle():
	show_poof_at_position(global_position)
	teleport_back_to_cage_for_7_seconds()  

func _on_better_battle():
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
	chase_enabled = true

func show_poof_at_position(pos: Vector2) -> void:
	var poof = PoofEffect.instantiate()
	get_tree().current_scene.add_child(poof)
	poof.global_position = pos
	poof.get_node("AnimatedSprite2D").play("poof")
