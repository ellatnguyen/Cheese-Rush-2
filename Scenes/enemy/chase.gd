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



enum State { RUN, ATTACK }
var current_state: State = State.RUN

func _ready() -> void:
	if event_handler:
		event_handler.best_battle.connect(Callable(self, "_on_best_battle"))
		event_handler.better_battle.connect(Callable(self, "_on_better_battle"))
		event_handler.good_battle.connect(Callable(self, "_on_good_battle"))
		event_handler.knife_found.connect(Callable(self, "_on_knife_found"))
		
	# 10-second delay before chase begins
	var chase_timer = Timer.new()
	chase_timer.wait_time = 10.0
	chase_timer.one_shot = true
	chase_timer.connect("timeout", Callable(self, "_on_ChaseTimer_timeout"))
	add_child(chase_timer)
	chase_timer.start()

func _physics_process(delta: float) -> void:
	if chase_enabled:
		navigation_agent.target_position = target_to_chase.global_position
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * spd
		move_and_slide()
		_update_sprite_direction(velocity)

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
		if current_state == State.ATTACK:
			event_handler.emit_signal("battle_started")
			print("Chase cat hit - attack mode active!")
		else:
			var anim_player = get_node("/root/main/GameOverUI/AnimationPlayer2")
			var full_screen_image = get_node("/root/main/GameOverUI/FullScreenImage")
			var color = get_node("/root/main/GameOverUI/ColorRect")
			var labels = get_node("/root/main/UI/MarginContainer/HBoxContainer/ScoreLabel")
			var final = get_node("/root/main/UI/FinalScore")
			final.visible = true
			labels.visible = false
			color.visible = true
			full_screen_image.visible = true
			get_tree().paused = true
			anim_player.play("lose_screen_fade")

func _on_best_battle():
	show_poof_at_position(global_position)
	teleport_back_to_cage_for_7_seconds()

func _on_better_battle():
	if was_just_hit:
		show_poof_at_position(global_position)
		teleport_back_to_cage_for_7_seconds()
		was_just_hit = false

func _on_good_battle() -> void:
	print("Chase Good battle: freezing cat for 5 seconds!")
	chase_enabled = false
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

func _on_knife_found(knife_pellet: Node) -> void:
	print("Chase cat received knife_found signal!")
	if current_state != State.ATTACK:
		current_state = State.ATTACK
		print("Entering ATTACK mode!")
		var attack_timer = Timer.new()
		attack_timer.wait_time = 15.0
		attack_timer.one_shot = true
		attack_timer.connect("timeout", Callable(self, "_on_attack_timeout"))
		add_child(attack_timer)
		attack_timer.start()


func _on_attack_timeout() -> void:
	current_state = State.RUN
	chase_enabled = true
	print("Attack mode ended: reverting to CHASE mode.")
