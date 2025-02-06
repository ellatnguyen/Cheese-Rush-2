extends AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load the WAV audio file using load()
	var audio_stream = load("res://audio_files/VGM Project 1 -Gameplay - Flow 1.wav")
	
	# Check if the audio stream loaded successfully
	if audio_stream:
		stream = audio_stream
		play()
	else:
		print("Failed to load the audio stream.")
