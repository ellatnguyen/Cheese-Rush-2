extends Node2D

@onready var right_area_2d = $RightColorRect/Area2D
@onready var left_area_2d = $LeftColorRect/Area2D
@onready var top_area_2d = $TopColorRect/Area2D
@onready var bottom_area_2d = $BottomColorRect/Area2D

# Offset correction if needed (tweak these values if misaligned)
var top_tunnel_x_offset = 55  # Adjust this to the exact opening position
var bottom_tunnel_x_offset = 75 # Adjust this to the exact opening position

var allow_left_transition = true
var allow_right_transition = true
var allow_top_transition = true
var allow_bottom_transition = true

# 🚀 LEFT & RIGHT TRANSITIONS 🚀
func _on_right_area_2d_body_entered(body: Node2D) -> void:
	if body.velocity.x > 0 and allow_right_transition:
		body.position.x = left_area_2d.global_position.x
		allow_right_transition = false  

func _on_right_area_2d_body_exited(body: Node2D) -> void:
	allow_right_transition = true  

func _on_left_area_2d_body_entered(body: Node2D) -> void:
	if body.velocity.x < 0 and allow_left_transition:
		body.position.x = right_area_2d.global_position.x
		allow_left_transition = false  

func _on_left_area_2d_body_exited(body: Node2D) -> void:
	allow_left_transition = true  

# 🚀 FIXED TOP & BOTTOM TRANSITIONS 🚀
func _on_top_area_2d_body_entered(body: Node2D) -> void:
	if body.velocity.y < 0 and allow_top_transition:
		body.position.x = bottom_tunnel_x_offset  # ✅ Set exact X for bottom tunnel
		body.position.y = bottom_area_2d.global_position.y + 5  # ✅ Small offset to exit safely
		allow_top_transition = false  

func _on_top_area_2d_body_exited(body: Node2D) -> void:
	allow_top_transition = true  

func _on_bottom_area_2d_body_entered(body: Node2D) -> void:
	if body.velocity.y > 0 and allow_bottom_transition:
		body.position.x = top_tunnel_x_offset  # ✅ Set exact X for top tunnel
		body.position.y = top_area_2d.global_position.y - 5  # ✅ Small offset to exit safely
		allow_bottom_transition = false  

func _on_bottom_area_2d_body_exited(body: Node2D) -> void:
	allow_bottom_transition = true  
