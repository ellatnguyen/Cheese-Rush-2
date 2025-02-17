extends Node

var ui: UI  # UI reference set by Main.gd

var total_pellets_count 
var pellets_eaten = 0
var score = 0

func _ready():
	ui = get_node("/root/main/UI")
	var pellets = self.get_children() as Array[Pellet]
	total_pellets_count = pellets.size()

	# Debug: Ensure pellets are correctly identified
	for pellet in pellets:
		pellet.pellet_eaten.connect(on_pellet_eaten)  # Connecting the signal

func on_pellet_eaten():
	var pelletsound = get_node("/root/main/PelletSound")
	pelletsound.play()
		
	pellets_eaten += 1
	
	score += 10
	if ui:
		ui.set_score(score)  # Update UI safely
		print("UI updated!")

	if pellets_eaten == total_pellets_count:

		var anim_player_path = "/root/main/GameOverUI2/AnimationPlayer2"
		var full_screen_image_path = "/root/main/GameOverUI2/FullScreenImage"
		var color_path = "/root/main/GameOverUI2/ColorRect"

		# Check if nodes exist before accessing them
		if has_node(anim_player_path) and has_node(full_screen_image_path) and has_node(color_path):
			var anim_player = get_node(anim_player_path)
			var full_screen_image = get_node(full_screen_image_path)
			var color = get_node(color_path)
			var final = get_node("/root/main/UI/FinalScore")
			var gameplaymusic = get_node("/root/main/GameplayMusic")
			var winmusic = get_node("/root/main/WinMusic")
			gameplaymusic.stop()
			winmusic.play()
			
			final.visible = true

			color.visible = true
			full_screen_image.visible = true
			get_tree().paused = true

			anim_player.play("lose_screen_fade")
		else:
			print("[ERROR] One or more UI elements are missing!")
