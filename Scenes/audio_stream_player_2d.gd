extends AudioStreamPlayer2D

func _ready() -> void:
	if stream:  # Ensure an audio file is assigned
		play()
	else:
		print("Warning: No audio stream assigned to AudioStreamPlayer2D")
