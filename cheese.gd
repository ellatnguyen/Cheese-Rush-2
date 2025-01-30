extends Area2D

@export var points: int = 10  # Score for collecting cheese

signal cheese_collected(points)  # Signal to update score

func _ready():
	connect("body_entered", _on_mouse_collect)

func _on_mouse_collect(body):
	if body.name == "Mouse":  # If the player (mouse) collides
		cheese_collected.emit(points)  # Emit signal for score
		queue_free()  # Remove the cheese pellet
