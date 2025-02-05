extends Area2D

class_name Pellet

signal pellet_eaten(pallet: Pellet)

@export var should_allow_eating_ghosts = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		pellet_eaten.emit(self)
		queue_free()
	
if should_allow_eating_ghosts:


var pellets = [Vector2(100, 100), Vector2(200, 200), Vector2(300, 300), Vector2(400, 400)]
var power_pellets = [Vector2(150, 150), Vector2(450, 450)]

func _ready():
	set_process(true)

func _draw():
	for pellet in pellets:
		draw_circle(pellet, 5, Color(1, 1, 0))
	for power_pellet in power_pellets:
		draw_circle(power_pellet, 10, Color(1, 1, 1))

func _process(delta):
	for power_pellet in power_pellets:
		if is_pacman_colliding(power_pellet):
			power_pellets.erase(power_pellet)
			update()

func is_pacman_colliding(position):
	var pacman_position = get_node("../PacMan").position
	return pacman_position.distance_to(position) < 15

		pass
		
