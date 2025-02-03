extends Control

@onready var event_handler = get_node("/root/event_handler")

func _ready():
	visible = false
	$background.visible = false
	event_handler.battle_started.connect(init)
	pass

#func init(character_name, lvl):
	#visible = true
	#$AnimationPlayer.play("fade_in")
	#get_tree().paused = true 
	#pass

#func init(character_name, lvl):
	#visible = true
	#print("Animation should be playing)")
	#$AnimationPlayer.playback_process_mode = AnimationPlayer.ANIMATION_PROCESS_IDLE
	#$AnimationPlayer.play("fade_in")
	#await $AnimationPlayer.animation_finished
	#get_tree().paused = true

#func init(character_name, lvl):
	#anchor_left = 0.21
	#anchor_right = 0.275
	#anchor_top = 0.5
	#anchor_bottom = 0.5
	#visible = true
	#$AnimationPlayer.play("fade_in")
	#await $AnimationPlayer.animation_finished
	#get_tree().paused = true

#func init(character_name, lvl):
	#anchor_left = 0.4
	#anchor_right = 0.25
	#anchor_top = 0.5
	#anchor_bottom = 0.5
	#visible = true
	#$AnimationPlayer.play("fade_in")
	#await $AnimationPlayer.animation_finished  # Wait for fade_in to finish
	#$background.visible = true
	#print("Playing fade_out")
	#$AnimationPlayer.play("fade_out")
	#await $AnimationPlayer.animation_finished  # Wait for fade_out to finish
	#get_tree().paused = true  # Now pause the game
	
func init(character_name, lvl):
	# Stop player movement immediately
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.velocity = Vector2.ZERO  # Instantly stop movement
		player.set_physics_process(false)  # Disables movement
		player.set_process(false)  # Disables regular processing
		player.set_deferred("motion_mode", 0)  # Optional: If using CharacterBody2D, set motion mode to static

	# Play fade-in animation
	anchor_left = 0.4
	anchor_right = 0.25
	anchor_top = 0.5
	anchor_bottom = 0.5
	visible = true
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished  # Wait for fade_in to finish

	# Show battle background
	$background.visible = true
	print("Playing fade_out")
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished  # Wait for fade_out to finish

	# Now, pause the game fully
	get_tree().paused = true
