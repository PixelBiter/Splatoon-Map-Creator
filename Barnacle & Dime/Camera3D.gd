extends Node3D

var Held = false
var Sens = 0.3
var Angle=0

func _input(event): 
	if Held == true:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x*Sens))
			var Angle=-event.relative.y*Sens
			$Camera.rotate_x(deg_to_rad(Angle))

func _process(delta):
	G.CamPosition = position.y
	if Held == true:
		if Input.is_action_just_pressed("RESET"):
			position = Vector3(0.315,6.437,5.37)
			rotation = Vector3(-25,0,0)
			$Camera.rotation = Vector3.ZERO
		if Input.is_action_pressed("Forward"):
			position -= $Camera.global_transform.basis.z * 0.1
		if Input.is_action_pressed("Backward"):
			position += $Camera.global_transform.basis.z * 0.1
		if Input.is_action_pressed("Left"):
			position -= global_transform.basis.x * 0.1
		if Input.is_action_pressed("Right"):
			position += global_transform.basis.x * 0.1
		if Input.is_action_just_pressed("Camera"):
			if $Camera.projection == 0:
				$Camera.projection = 1
			else:
				$Camera.projection = 0
	
	
	if Input.is_action_just_pressed("HOLD"):
		if Held == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Held = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Held = false
	
	
