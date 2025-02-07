extends Area2D

class_name Pellet

signal pellet_eaten

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("pellet_eaten")
		queue_free()

		
