extends Node2D


# Declare member variables here. Examples:
var bx := 0.0
var by := 0.0
var vx := 0.0
var vy := 0.0
var BARRIERRADIUS := 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.scale.x = BARRIERRADIUS
	$Sprite.scale.y = BARRIERRADIUS
	

func init(bx_, by_, vx_, vy_, r):
	bx = bx_
	by = by_
	vx = vy_
	vy = vy_
	BARRIERRADIUS = r


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pygame.draw.circle(screen, bcol, (int(u0 + k * barrier[0]), int(v0 - k * barrier[1])), int(k * BARRIERRADIUS), 0)
	#pass
