extends Area2D

class_name knife

signal knife_found
@onready var cutter_popup = $PizzaCutterPopUp

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("Knife pellet collided with Player")
		
		#cutter_popup.visible = true
		#cutter_popup.position.x = -300
		#cutter_popup.position.y = 55
		
		#var tween = create_tween()
		#tween.tween_property(cutter_popup, "position:x", 55, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		#await tween.finished 
		#
		##var tween = create_tween()
		#tween.tween_property(cutter_popup, "position:x", 200, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		#await tween.finished  
		##cutter_popup.visible = false
	
		# Emit the knife_found signal through the global event_handler
		event_handler.emit_signal("knife_found", self)
		queue_free()
