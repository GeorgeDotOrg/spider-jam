extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var speed = SPEED
var run = 2
@onready var camera := $Camera

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var last_pos = Vector2()

func _physics_process(delta):
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = Input.get_vector("ui_moveleft", "ui_moveright", "ui_movefwd", "ui_moveback")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	var mouse_pos = get_viewport().get_mouse_position()
	var min = Vector2()
	var max = get_viewport().size
	var center_pos = get_viewport().size/2
	
	if(mouse_pos.x <= min.x or mouse_pos.x >= max.x):
		mouse_pos.x = center_pos.x
		last_pos.x = center_pos.x
	
	if(mouse_pos.y <= min.y or mouse_pos.y >= max.y):
		mouse_pos.y = center_pos.y
		last_pos.y = center_pos.y
	
	get_viewport().warp_mouse(mouse_pos)
	
	#var rot_x = 10
	var rot_x = 5*clamp((last_pos.x-mouse_pos.x)/center_pos.x,-1,1)
	if(mouse_pos.x < last_pos.x):
		rotate_y(rot_x)
	elif(mouse_pos.x > last_pos.x):
		rotate_y(rot_x)
	
	#var rot_y = 10
	var rot_y = 5*clamp((last_pos.y-mouse_pos.y)/center_pos.y,-1,1)
	if(camera.rotation_degrees.x < 90 and mouse_pos.y < last_pos.y):
		camera.rotate_x(rot_y)
	elif(camera.rotation_degrees.x > -90 and mouse_pos.y > last_pos.y):
		camera.rotate_x(rot_y)
	
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	
	last_pos = mouse_pos
	
	move_and_slide()
