extends Control

@onready var event_handler = get_node("/root/event_handler")
@onready var mash_timer = $MashTimer  

@onready var rat = $RatFightSprite  
@onready var cat = $CatFightSprite  
@onready var scatter_cat = $Scatter_cat
@onready var battle_animation = $BattleAnimation
@onready var mash_space = $MashSpacebar
@onready var good = $GOOD
@onready var better = $BETTER
@onready var best = $BEST
@onready var labels = get_node("/root/main/UI/MarginContainer/HBoxContainer/ScoreLabel")
@onready var gameplaymusic = get_node("/root/main/GameplayMusic")
@onready var powerupmusic = get_node("/root/main/PowerUpMusic")

#@onready var cutter_popup = get_node("/root/main/Knife/Area2D/PizzaCutterPopUp")
#@onready var map = $BackgroundWithTunnels
#@onready var progress_bar = $background/Panel/MyProgressBar  

var mash_count = 0  
var mashing_active = false  

func _ready():
	visible = false
	$background.visible = false
	event_handler.battle_started.connect(init)

func init(): 
	labels.visible = false
	gameplaymusic.stop()
	powerupmusic.play()
	
	# Stop player movement
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.velocity = Vector2.ZERO
		player.set_physics_process(false)
		player.set_process(false)
		player.set_deferred("motion_mode", 0)

	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		enemy.set_physics_process(false)
		enemy.set_process(false)
		player.set_deferred("motion_mode", 0)
	
	mash_space.position.x = 602  
	mash_space.position.y = 346  
	
	#cutter_popup.visible = false
	
	# Set initial positions for rat and cat (off-screen)
	rat.position.x = -300  
	cat.position.x = 1200  
	rat.position.y = 328  
	cat.position.y = 320  	

	visible = true
	battle_animation.visible = false
	
	# Create tweens for fast sliding in
	var tween = create_tween()
	tween.tween_property(rat, "position:x", 566, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(cat, "position:x", 541, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	await tween.finished  # Wait for slide-in animation
	battle_animation.visible = true
	
	# Calculate the midpoint
	#var midpoint = map.position

	# Example: Positioning something at the midpoint
	battle_animation.position.x = 561  
	battle_animation.position.y = 330  
	battle_animation.play("fight")

	# Show battle background
	cat.visible = false
	rat.visible = false

	# Start the mashing minigame
	start_mash_minigame()

func start_mash_minigame():
	mashing_active = true
	mash_count = 0
	#progress_bar.value = 0
	#progress_bar.visible = true

	mash_timer.start(5.0)  
	print("MashTimer started!")

func _input(event):
	if mashing_active and event.is_action_pressed("mash"):  
		mash_count += 1
		#progress_bar.value = min((mash_count / 30.0) * 100, 100)  
		print("Mash Count: ", mash_count)

func _on_mash_timer_timeout():
	print("Mash minigame ended!")  
	mashing_active = false
	#progress_bar.visible = false

	# Determine the outcome based on mash count
	if mash_count >= 30:
		print("Best Outcome!")
		best.visible = true
		best.position.x = 584
		best.position.y = 327
		event_handler.emit_signal("best_battle")
	elif mash_count >= 20:
		print("Better Outcome!")
		better.visible = true
		better.position.x = 584
		better.position.y = 327
		event_handler.emit_signal("better_battle")
	elif mash_count >= 10:
		print("Good Outcome!")
		good.visible = true
		good.position.x = 584
		good.position.y = 327
		event_handler.emit_signal("good_battle")
	else:
		print("Failed Outcome!")
	
	battle_animation.visible = false
	cat.visible = true
	rat.visible = true
	
	mash_space.visible = false
	
	# Create tweens for sliding out
	var tween = create_tween()
	tween.tween_property(rat, "position:x", -300, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(cat, "position:x", 1200, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	await tween.finished  # Wait for slide-out animation
	
	# Hide battle UI
	visible = false
	$background.visible = false
	good.visible = false
	better.visible = false
	best.visible = false

	# Unpause the game
	get_tree().paused = false

	# Re-enable player movement
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.set_physics_process(true)
		player.set_process(true)
		player.set_deferred("motion_mode", 1)
	
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		enemy.set_physics_process(true)
		enemy.set_process(true)
		player.set_deferred("motion_mode", 1)
	
	print("Battle scene ended, resuming game.")

	labels.visible = true
	powerupmusic.stop()
	gameplaymusic.play()
