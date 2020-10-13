extends KinematicBody2D

export var speed = 400 
export var SAVE_TIME = 60
var alive = true
var timer_value = 60;
var velocity = Vector2()

func _ready():
	pass

func _physics_process(_delta):
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
