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
var targetindex := 0


# set the width and height of the screen (pixels)
var WIDTH := OS.get_window_size().x # 1024
var HEIGHT := OS.get_window_size().y # 768

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

var pathstodraw = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# barrier contents are (bx, by, visibilitymask)
	# Generate some initial random barriers
	for i in range(20):
			var bx = rng.randf_range(PLAYFIELDCORNERS[0], PLAYFIELDCORNERS[2]-1)
			var by = rng.randf_range(PLAYFIELDCORNERS[1], PLAYFIELDCORNERS[3]-1)
			var vx = rng.randfn(0.0, BARRIERVELOCITYRANGE)
			var vy = rng.randfn(0.0, BARRIERVELOCITYRANGE)
			var barrier = [bx, by, vx, vy]
			barriers.append(barrier)
	rng.randomize()
	targetindex = rng.randi_range(0, len(barriers)-1) # inclusive


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Function to predict new robot position based on current pose and velocity controls
# Uses time deltat in future
# Returns xnew, ynew, thetanew
# Also returns path. This is just used for graphics, and returns some complicated stuff
# used to draw the possible paths during planning. Don't worry about the details of that.
func predictPosition(vL, vR, x, y, theta, deltat):
	# Variables
	var xnew
	var ynew
	var thetanew
	var path
	
	# Simple special cases
	# Straight line motion
	if stepify(vL, 0.001) == stepify(vR, 0.001):
		xnew = x + vL * deltat * cos(theta)
		ynew = y + vL * deltat * sin(theta)
		thetanew = theta
		path = [0, vL * deltat]   # 0 indicates pure translation
		
	# Pure rotation motion
	elif stepify(vL, 0.001) == -stepify(vR, 0.001):
		xnew = x
		ynew = y
		thetanew = theta + ((vR - vL) * deltat / W)
		path = [1, 0] # 1 indicates pure rotation
	
	# Rotation and arc angle of general circular motion
	else:
		# Using equations given in Lecture 2
		var R = W / 2.0 * (vR + vL) / (vR - vL)
		var deltatheta = (vR - vL) * deltat / W
		xnew = x + R * (sin(deltatheta + theta) - sin(theta))
		ynew = y - R * (cos(deltatheta + theta) - cos(theta))
		thetanew = theta + deltatheta

		# To calculate parameters for arc drawing (complicated Pygame stuff, don't worry)
		# We need centre of circle
		var cx = x - R * sin(theta)
		var cy = y + R * cos (theta)
		
		# Turn this into Rect
		var Rabs = abs(R)
		var tlx = int(u0 + k * (cx - Rabs))
		var tly = int(v0 - k * (cy + Rabs))
		var Rx =  int(k * (2 * Rabs))
		var Ry =  int(k * (2 * Rabs))
		
		if (R > 0):
			var start_angle = theta - PI/2.0
		else:
			var start_angle = theta + PI/2.0
			var stop_angle = start_angle + deltatheta
			path = [2, [[tlx, tly], [Rx, Ry]], start_angle, stop_angle] # 2 indicates general motion

	return [xnew, ynew, thetanew, path]


# Function to calculate the closest obstacle at a position (x, y)
# Used during planning
func calculateClosestObstacleDistance(x, y):
	var closestdist = 100000.0  
	var barrier
	var dx
	var dy
	var d
	var dist
	
	# Calculate distance to closest obstacle
	for i in range(len(barriers)):
		barrier = barriers[i]
		if (i != targetindex):
			dx = barrier[0] - x
			dy = barrier[1] - y
			d = sqrt(dx^2 + dy^2)
			
			# Distance between closest touching point of circular robot and circular barrier
			dist = d - BARRIERRADIUS -      ROBOTRADIUS
			if (dist < closestdist):
				closestdist = dist
	return closestdist
