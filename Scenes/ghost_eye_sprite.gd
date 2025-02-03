extends Sprite2D
class_name EyesSprite

@export_group("Eye Textures")
@export var up: Texture2D
@export var down: Texture2D
@export var left: Texture2D
@export var right: Texture2D
@export_group("")

var direction_lookup_table = {
	"up": up,
	"down": down,
	"left": left,
	"right": right
}

func _ready():
	print("EyesSprite ready, parent: ", get_parent())
	if get_parent() is Ghost:
		(get_parent() as Ghost).direction_change.connect(on_direction_change)
		print("Connected to ghost's direction_change signal.")
	else:
		print("Warning: Parent is not a Ghost!")
	
	# Optionally, set a default texture so you always see something.
	if up:
		texture = up
		print("Default eye texture set to 'up'.")

func on_direction_change(direction: String) -> void:
	print("EyesSprite on_direction_change: ", direction)
	# Update the texture based on the new direction.
	if direction_lookup_table.has(direction) and direction_lookup_table[direction]:
		texture = direction_lookup_table[direction]
	else:
		print("No texture assigned for direction:", direction)

func hide_eyes() -> void:
	hide()

func show_eyes() -> void:
	show()
