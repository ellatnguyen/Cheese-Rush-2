extends Area2D

var speed =120
var player_pos
var target_pos
@onready var player = get_parent().get_parent().get_node("pacman")

func _ready() -> void:
	$ProgressBar.value = 5
	
func _physics_process(delta: float) -> void:
	player_pos = player.position
	target_pos = (player_pos -position).normalized()
	
	#if position.distance_to(player_pos)>3:
