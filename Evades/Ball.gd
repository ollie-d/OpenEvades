extends KinematicBody2D

export var speed = 400 
export var SAVE_TIME = 60
var alive = true
var timer_value = 60;

func _ready():
	pass

func _physics_process(_delta):
	if alive:
		var velocity = Vector2()
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		# warning-ignore:return_value_discarded
		move_and_slide(velocity) 

func kill():
	if alive:
		alive = false;
		$Label.text = str(SAVE_TIME)
		timer_value = SAVE_TIME
		$Label.visible = true
		$CollisionShape2D.set_deferred("disabled", true)
		$BallArea/CollisionShape2D.set_deferred("disabled", true)
		$Sprite.modulate.a = 0.5
		$DeathTimer.start()

func revive():
		alive = true;
		$Label.visible = false
		$CollisionShape2D.set_deferred("disabled", false)
		$BallArea/CollisionShape2D.set_deferred("disabled", false)
		$Sprite.modulate.a = 1
		$DeathTimer.stop()

func hit(body):
	if body.name == "Enemy":
		kill()
	elif body.name == "Ally":
		revive()
	
func _on_DeathTimer_timeout():
	if timer_value > 0:
		timer_value -= 1
		$Label.text = str(timer_value)
