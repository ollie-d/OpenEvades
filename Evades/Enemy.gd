extends KinematicBody2D

var velocity = Vector2()  # The player's movement vector.
export var speed = 350;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	velocity = Vector2(rand_range(0, 1), rand_range(0, 1))

func _physics_process(delta):
	velocity = velocity.normalized() * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
