extends Node2D  # The root node of your scene, which is "AudioTest" in this case

# Declare a variable to hold the reference to the AudioStreamPlayer2D node
var background_music_player: AudioStreamPlayer2D

# File path to your audio
var audio_file_path: String = "res://Final Assets/Audio_Files/VGM Project 1 - Gameplay - Flow 1.wav"  # Your audio file path

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure the AudioStreamPlayer2D node is assigned correctly
	background_music_player = $AudioStreamPlayer2D  # This points to the AudioStreamPlayer2D node inside AudioTest

	# Load the audio file dynamically
	var audio_stream = load(audio_file_path)  # Load the audio file from the specified path

	if audio_stream:
		# Assign the audio stream to the AudioStreamPlayer2D node
		background_music_player.stream = audio_stream
		# Play the audio immediately
		background_music_player.play()
	else:
		print("Error: Unable to load the audio file at path: ", audio_file_path)
