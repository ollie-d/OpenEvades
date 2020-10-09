extends KinematicBody2D

export var speed = 400  # How fast the player will move (pixels/sec).
export var SAVE_TIME = 60
var is_hit = false
var timer_value = 60;

func _ready():
	pass
	
#func _process(delta):
	
func _physics_process(_delta):
	if !is_hit:
		var velocity = Vector2()  # The player's movement vector.
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

func hit(_body):
	is_hit = true;
	$Label.text = str(SAVE_TIME)
	timer_value = SAVE_TIME
	$Label.visible = true
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Sprite.modulate.a = 0.5
	$DeathTimer.start()


func _on_DeathTimer_timeout():
	if timer_value > 0:
		timer_value -= 1
		$Label.text = str(timer_value)
