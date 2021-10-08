# Translation from Python (PyGame) -> Godot
# Original
# 	Dynamic Window Approach (Local Planning) with moving obstacles
# 	By Andrew Davison 2019
# Translation
#	By Alessandro "Ollie" D'Amico (ollie-d) 07Oct2021

extends Node


# Constants and variables
# Units here are in metres and radians using our standard coordinate frame
var BARRIERRADIUS := 0.1
var ROBOTRADIUS := 0.10
var W := 2 * ROBOTRADIUS # width of robot
var SAFEDIST := ROBOTRADIUS      # used in the cost function for avoiding obstacles

var MAXVELOCITY := 0.5     #ms^(-1) max speed of each wheel
var MAXACCELERATION := 0.5 #ms^(-2) max rate we can change speed of each wheel


var BARRIERVELOCITYRANGE := 0.15


# The region we will fill with obstacles
var PLAYFIELDCORNERS := [-4.0, -3.0, 4.0, 3.0]



# Starting pose of robot
var x = PLAYFIELDCORNERS[0] - 0.5
var y := 0.0
var theta := 0.0

# Use for displaying a trail of the robot's positions
var locationhistory := []

# Starting wheel velocities
var vL := 0.00
var vR := 0.00

# Timestep delta to run control and simulation at
var dt := 0.05 # Set this to probably 1/60 ? Make sure step constant on all fs
var STEPSAHEADTOPLAN := 10
var tau := dt * STEPSAHEADTOPLAN # Keyword TAU equivalent?

# Barrier (obstacle) locations
var barriers = []

var rng = RandomNumberGenerator.new()


# set the width and height of the screen (pixels)
var WIDTH := get_viewport().size.x # 1024
var HEIGHT := get_viewport().size.y # 768

var size := [WIDTH, HEIGHT]
var black := Color(20,20,40)
var lightblue := Color(0,120,255)
var darkblue := Color(0,40,160)
var red := Color(255,100,0)
var white := Color(255,255,255)
var blue := Color(0,0,255)
var grey := Color(70,70,70)
var k := 160 # pixels per metre for graphics

# Screen centre will correspond to (x, y) = (0, 0)
var u0 := WIDTH / 2
var v0 := HEIGHT / 2

# Called when the node enters the scene tree for the first time.
func _ready():
	# barrier contents are (bx, by, visibilitymask)
	# Generate some initial random barriers
	for i in range(20):
			#(bx, by, vx, vy) = (random.uniform(PLAYFIELDCORNERS[0], PLAYFIELDCORNERS[2]), random.uniform(PLAYFIELDCORNERS[1], PLAYFIELDCORNERS[3]), random.gauss(0.0, BARRIERVELOCITYRANGE), random.gauss(0.0, BARRIERVELOCITYRANGE))
			var bx = rng.randf_range(PLAYFIELDCORNERS[0], PLAYFIELDCORNERS[2]-1)
			var by = rng.randf_range(PLAYFIELDCORNERS[1], PLAYFIELDCORNERS[3]-1)
			var vx = rng.randf(0.0, BARRIERVELOCITYRANGE)
			var vy = rng.randf(0.0, BARRIERVELOCITYRANGE)
			var barrier = [bx, by, vx, vy]
			barriers.append(barrier)
	rng.randomize()
	var targetindex = rng.randi_range(0, len(barriers)-1) # inclusive

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
