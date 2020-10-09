extends Node

func _ready():
	randomize()
	
	# Make safe zone transluscent
	$LeftSafeZone/ColorRect.color[3] = 0.5
	$RightSafeZone/ColorRect.color[3] = 0.5
	
	# Add collision exceptions for player+safezones and enemies+enemies
	# Also add exception for player+enemies (area handles death)
	$Ball.add_collision_exception_with($LeftSafeZone)
	$Ball.add_collision_exception_with($RightSafeZone)
	var time_before = OS.get_ticks_msec()
	var children = $EnemyContainer.get_children()
	for child in children:
		child.add_collision_exception_with($Ball)
		for child_ in children:
			if child != child_:
				child.add_collision_exception_with(child_)
	var total_time = OS.get_ticks_msec() - time_before
	print("Time taken: " + str(total_time))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
