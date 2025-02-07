extends Area2D

class_name knife

signal knife_found

func _on_body_entered(body: Node) -> void:
	if body is Player:
		knife_found.emit(self)
		queue_free()
