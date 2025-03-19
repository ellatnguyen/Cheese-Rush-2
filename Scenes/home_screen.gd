extends Control

@onready var event_handler = get_node("/root/event_handler")
@onready var button = $Homescreen/Button
@onready var animated_sprite = $Homescreen/AnimatedSprite2D
@onready var homescreen = $"."
@onready var labels = get_node("/root/main/UI/MarginContainer/HBoxContainer/ScoreLabel")


func _ready():
	# Initially, MainScreen is visible
	homescreen.visible = true
	labels.visible = false
	
	# Make the button invisible but still clickable (transparent)
	button.modulate.a = 0  # Set alpha to 0 (fully transparent)

	
	# Connect the button press event using a callable
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	# Reset the AnimatedSprite frame to 0 (first frame) before playing the animation
	
	# Play the button animation once
	animated_sprite.play("default")
	
	# Wait for the animation to finish
	await animated_sprite.animation_finished
	
	# Hide the homescreen and reveal the main game
	homescreen.visible = false  # Hides the MainScreen (home screen)
	labels.visible = true
	event_handler.emit_signal("button_pressed")
