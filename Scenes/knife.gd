extends Area2D

class_name knife

signal knife_found

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("Knife pellet collided with Player")
		# Emit the knife_found signal through the global event_handler
		event_handler.emit_signal("knife_found", self)
		queue_free()
