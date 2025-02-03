extends Sprite2D
@onready var animation_player = $"../Animation Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = (get_parent() as Ghost).color
	animation_player.play("moving")
