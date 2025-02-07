extends Node

@onready var chase_cat = $Enemys/chase_cat
@onready var scatter_cat = $Enemys/Scatter_cat

@onready var ui = $UI
@onready var pellet_manager = $Pellets

func _ready() -> void:
	pellet_manager.ui = ui
	# We will connect the signals from large pellets to _on_large_pellet_eaten()
	# in code OR via the Editor (next steps).
	pass

func _on_large_pellet_eaten(pellet):
	# This function is called when a large pellet is eaten.
	# Teleport each cat to the cage for 7 seconds.
	chase_cat.teleport_back_to_cage_for_7_seconds()
	scatter_cat.teleport_back_to_cage_for_7_seconds()


func _on_LargePellet_pellet_eaten(pallet: Pellet) -> void:
	chase_cat.teleport_back_to_cage_for_7_seconds()
	scatter_cat.teleport_back_to_cage_for_7_seconds()
