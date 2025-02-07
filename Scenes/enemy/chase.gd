extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target_to_chase: CharacterBody2D
@onready var sprite: Sprite2D = $BodySprite

@export var texture_up: Texture2D
@export var texture_down: Texture2D
@export var texture_left: Texture2D
@export var texture_right: Texture2D

const SPEED = 120
@export var chase_enabled: bool = false

@export var cage_position_node: Node2D

func _ready() -> void:
	# Event Handler
	if event_handler:
		event_handler.best_battle.connect(_on_best_battle)
		event_handler.better_battle.connect(_on_better_battle)
		event_handler.good_battle.connect(_on_good_battle)
		
	# 10-second delay
	var chase_timer = Timer.new()
	chase_timer.wait_time = 10.0
	chase_timer.one_shot = true
	chase_timer.connect("timeout", Callable(self, "_on_ChaseTimer_timeout"))
	add_child(chase_timer)
	chase_timer.start()

func _physics_process(delta: float) -> void:
	if chase_enabled:
		navigation_agent.target_position = target_to_chase.global_position
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * SPEED
		move_and_slide()
		_update_sprite_direction(velocity)

func _update_sprite_direction(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			sprite.texture = texture_right
		else:
			sprite.texture = texture_left
	else:
		if direction.y > 0:
			sprite.texture = texture_down
		else:
			sprite.texture = texture_up

func _on_ChaseTimer_timeout() -> void:
	chase_enabled = true

# Teleport the ghost to the "cage" for 7 sec

func teleport_back_to_cage_for_7_seconds() -> void:
	chase_enabled = false
	# Move ghost to cage
	if cage_position_node:
		global_position = cage_position_node.global_position
	velocity = Vector2.ZERO

	# Start a 7-second cage timer
	var cage_timer = Timer.new()
	cage_timer.wait_time = 7.0
	cage_timer.one_shot = true
	cage_timer.connect("timeout", Callable(self, "_on_CageTimer_timeout"))
	add_child(cage_timer)
	cage_timer.start()

func _on_CageTimer_timeout() -> void:
	chase_enabled = true

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
	print("Chase Best battle!")  

func _on_better_battle():
	print("Chase Better battle!")  

func _on_good_battle():
	print("Chase Good battle!")  
