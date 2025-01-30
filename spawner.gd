extends Node2D

@export var cheese_scene: PackedScene  # Drag `cheese.tscn` here in the Inspector
@export var spawn_positions: Array[Vector2]  # Define spawn positions in the Inspector

func _ready():
    for pos in spawn_positions:
        var cheese = cheese_scene.instantiate()
        cheese.position = pos
        add_child(cheese)
