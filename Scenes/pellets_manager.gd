extends Node

var total_pellets_count
var pellets_eaten = 0

@onready var player_chomp_sound = $"../SoundPlayers/PlayerChompSound"

func _ready():
	var pellets = self.get_children() as Array[Pellet]
	total_pellets_count = pellets.size()
	for pellet in pellets:
		pellet.pellet_eaten.connect(on_pellet_eaten)

func on_pellet_eaten(should_allow_eating_ghosts: bool):
	
	if !player_chomp_sound.playing:
		player_chomp_sound.play()
	pellets_eaten += 1
	
	if should_allow_eating_ghosts:
		pass
	
	if pellets_eaten == total_pellets_count:
		pass
