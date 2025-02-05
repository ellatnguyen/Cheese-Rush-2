extends Area2D

class_name Pellet

signal pellet_eaten(pellet: Pellet)

@export var is_power_pellet: bool = false  # Define if this is a power pellet

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		pellet_eaten.emit(self)
		queue_free()
