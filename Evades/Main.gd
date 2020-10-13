extends Node

export var Debug = true

func _ready():
	randomize()
	
	# Make bot colored
	$PlayerContainer/Bot0.modulate = Color(0, 1, 0, 1)
	
	# Make safe zone transluscent
	$LeftSafeZone/ColorRect.color[3] = 0.5
	$RightSafeZone/ColorRect.color[3] = 0.5
	
	# Add collision exceptions for player+safezones and enemies+enemies
	# Also add exception for player+enemies (area handles death)
	var time_before = OS.get_ticks_msec()
	var children = $EnemyContainer.get_children()
	var players  = $PlayerContainer.get_children()
	
	for player in players:
		player.add_collision_exception_with($LeftSafeZone)
		player.add_collision_exception_with($RightSafeZone)
		for player_ in players:
			if player != player_:
				player.add_collision_exception_with(player_)
	
	for child in children:
		for player in players:
			child.add_collision_exception_with(player)
		for child_ in children:
			if child != child_:
				child.add_collision_exception_with(child_)
	var total_time = OS.get_ticks_msec() - time_before
	print("Time taken: " + str(total_time))

func _process(_delta):
	if Debug:
		if !$PlayerContainer/Player.alive:
			if Input.is_key_pressed(KEY_R):
				$PlayerContainer/Player.revive()
				
func _physics_process(delta):
	# Move bot
	if $PlayerContainer/Bot0.alive:
		$PlayerContainer/Bot0.velocity = $PlayerContainer/Player.velocity
	else:
		$PlayerContainer/Bot0.velocity = Vector2()
