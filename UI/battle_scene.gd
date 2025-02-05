extends Control

@onready var event_handler = get_node("/root/event_handler")
@onready var progress_bar = $background/Panel/MyProgressBar
@onready var mash_timer = $MashTimer  # Ensure the correct path

var mash_count = 0  # Counts the number of times the player mashes
var mash_timer_duration = 5.0  # Total time the minigame lasts
var mashing_active = false  # Whether the minigame is running

func _ready():
	print(progress_bar)
	visible = false
	$background.visible = false
	event_handler.battle_started.connect(init)
	
	
func init():
	# Stop player movement
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.velocity = Vector2.ZERO
		player.set_physics_process(false)
		player.set_process(false)
		player.set_deferred("motion_mode", 0)

	# Play fade-in animation
	anchor_left = 0.4
	anchor_right = 0.25
	anchor_top = 0.5
	anchor_bottom = 0.5
	visible = true
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished

	# Show battle background
	$background.visible = true
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished

	# Start the mashing minigame
	start_mash_minigame()

func start_mash_minigame():
	mashing_active = true
	mash_count = 0
	progress_bar.value = 0
	progress_bar.visible = true

	mash_timer.start(5.0)  # Ensure this runs!
	print("MashTimer started!")

func _input(event):
	if mashing_active and event.is_action_pressed("mash"):  # "mash" should be mapped to Space or another key
		mash_count += 1
		progress_bar.value = min((mash_count / 30.0) * 100, 100)  # Cap the bar at 100%
		print("Mash Count: ", mash_count)

func _on_mash_timer_timeout():
	print("Mash minigame ended!")  # Debugging
	mashing_active = false
	progress_bar.visible = false

	# Determine the outcome based on mash count
	if mash_count >= 30:
		print("Best Outcome!")
	elif mash_count >= 20:
		print("Great Outcome!")
	elif mash_count >= 10:
		print("Good Outcome!")
	else:
		print("Failed Outcome!")

	# Play fade-out animation
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished  # Wait for animation
	
		# Hide battle UI
	visible = false
	$background.visible = false
	
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished  # Wait for animation


	# Unpause the game
	get_tree().paused = false

	# Re-enable player movement
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_physics_process(true)  # Re-enable physics processing
		player.set_process(true)  # Re-enable regular processing
		player.set_deferred("motion_mode", 1)  # Re-enable movement (if using CharacterBody2D)

	print("Battle scene ended, resuming game.")
