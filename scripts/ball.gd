extends RigidBody3D

var speed = 10

var jump_height = 600
var jumpTimerActive = false
var base = Basis()
var gravity = 9.8
# Called when the node enters the scene tree for the first time.
func _ready():
	base = $jumpArea.global_transform.basis

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$jumpArea.global_transform.basis = base

func _integrate_forces(state):
	var velocity = Vector3.ZERO
	if load.playing:
		if Input.is_action_pressed("forwards"):
			if linear_velocity.z > 0:
				velocity.z += 1 * speed
			else:
				velocity.z += 0.75 * speed
		if Input.is_action_pressed("backwards"):
			if linear_velocity.z < 0:
				velocity.z -= 1 * speed
			else:
				velocity.z -= 0.75 * speed
		if Input.is_action_pressed("left"):
			if linear_velocity.x > 0:
				velocity.x += 1 * speed
			else:
				velocity.x += 0.75 * speed
		if Input.is_action_pressed("right"):
			if linear_velocity.x < 0:
				velocity.x -= 1 * speed
			else:
				velocity.x -= 0.75 * speed
		if Input.is_action_pressed("jump") and $jumpArea.get_overlapping_bodies().has(load.grid) and not jumpTimerActive:
			velocity.y += jump_height
			$jumpTimer.start()
			jumpTimerActive = true
		$Marker3D.global_transform.origin = global_transform.origin
	if linear_velocity.length() <= 15:
		state.apply_force(velocity)
	else:
		state.apply_force(Vector3(0,velocity.y,0))
func _on_jump_timer_timeout():
	jumpTimerActive = false
