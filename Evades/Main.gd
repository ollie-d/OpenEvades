extends Node

export var Debug = true

func _ready():
	randomize()
	
	# Make bot colored
	$PlayerContainer/Bot0.modulate = Color(0, 1, 0, 1)
	
	# Make safe zone transluscent
	$LeftSafeZone/ColorRect.color[3] = 0.5
	$RightSafeZone/ColorRect.color[3] = 0.5
	
	# Idk why, but bot required specific exception with safezones
	# despite layer/mask data being identical to player
	var players  = $PlayerContainer.get_children()
	for player in players:
		player.add_collision_exception_with($LeftSafeZone)
		player.add_collision_exception_with($RightSafeZone)

func _process(_delta):
	if Debug:
		if !$PlayerContainer/Player.alive:
			if Input.is_key_pressed(KEY_R):
				$PlayerContainer/Player.revive()
				
func _physics_process(delta):
	pass
#	# Move bot
#	if $PlayerContainer/Bot0.alive:
#		$PlayerContainer/Bot0.velocity = $PlayerContainer/Player.velocity
#	else:
#		$PlayerContainer/Bot0.velocity = Vector2()
	
	# Use raycasting to determine path for bot
