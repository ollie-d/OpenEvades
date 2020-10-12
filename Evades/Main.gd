extends Node

export var Debug = true

func _ready():
	randomize()
	
	# Make safe zone transluscent
	$LeftSafeZone/ColorRect.color[3] = 0.5
	$RightSafeZone/ColorRect.color[3] = 0.5
	
	# Add collision exceptions for player+safezones and enemies+enemies
	# Also add exception for player+enemies (area handles death)
	$Player.add_collision_exception_with($LeftSafeZone)
	$Player.add_collision_exception_with($RightSafeZone)
	var time_before = OS.get_ticks_msec()
	var children = $EnemyContainer.get_children()
	for child in children:
		child.add_collision_exception_with($Player)
		for child_ in children:
			if child != child_:
				child.add_collision_exception_with(child_)
	var total_time = OS.get_ticks_msec() - time_before
	print("Time taken: " + str(total_time))

func _process(_delta):
	if Debug:
		if !$Player.alive:
			if Input.is_key_pressed(KEY_R):
				$Player.revive()
