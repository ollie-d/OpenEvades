extends KinematicBody2D

export var speed = 400 
export var SAVE_TIME = 60
var alive = true
var timer_value = 60;
var velocity = Vector2()

func _ready():
	pass

func _physics_process(_delta):
	var space_state = get_world_2d().direct_space_state
	var result
	var max_vector = Vector2(0, 0)
	var vector = Vector2(0, 0)
	if alive:
		for r in range(-30, 31, 5):
			result = space_state.intersect_ray(self.position, self.position + Vector2(8000, 0).rotated(deg2rad(r)), [self], 0b00000000000000001001)
			vector = result.position - self.position
			if max_vector.length() < vector.length():
				max_vector = vector
		velocity = max_vector.normalized() * speed
		move_and_slide(velocity)
	
func kill():
	if alive:
		alive = false;
		$Label.text = str(SAVE_TIME)
		timer_value = SAVE_TIME
		$Label.visible = true
		$CollisionShape2D.set_deferred("disabled", true)
		#$BallArea/CollisionShape2D.set_deferred("disabled", true)
		$Sprite.modulate.a = 0.5
		$DeathTimer.start()

func revive():
		if !alive:
			alive = true;
			$Label.visible = false
			$CollisionShape2D.set_deferred("disabled", false)
			#$BallArea/CollisionShape2D.set_deferred("disabled", false)
			$Sprite.modulate.a = 1
			$DeathTimer.stop()

func hit(body):
	print(body.name)
	if body.name == "Enemy":
		kill()
	elif body.name == "BallArea":
		revive()
	
func _on_DeathTimer_timeout():
	if timer_value > 0:
		timer_value -= 1
		$Label.text = str(timer_value)
