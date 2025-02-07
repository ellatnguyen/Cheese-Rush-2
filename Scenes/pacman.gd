extends CharacterBody2D

class_name Player

@export var speed = 100
var movement_direction = Vector2.ZERO

func _physics_process(delta):
	get_input()
	
	velocity = movement_direction * speed
	move_and_slide()

func get_input():
	
	if Input.is_action_pressed("left"):
		movement_direction = Vector2.LEFT
		$MouseAnimation.play("running_lr")
		$MouseAnimation.flip_h = false
		
	elif Input.is_action_pressed("right"):
		movement_direction = Vector2.RIGHT
		$MouseAnimation.play("running_lr")
		$MouseAnimation.flip_h = true
		
	elif Input.is_action_pressed("down"):
		movement_direction = Vector2.DOWN
		$MouseAnimation.play("running_down")
		
	elif Input.is_action_pressed("up"):
		movement_direction = Vector2.UP
		$MouseAnimation.play("running_up")
	
