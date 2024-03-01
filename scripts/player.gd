extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -250.0
const MAX_FALL_SPEED = 200
const COYOTE_FRAMES = 5

@onready var camera : Camera2D = $Camera2D
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_target : RemoteTransform2D = $CameraTarget

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Player state
var is_alive : bool = true
var can_handle_user_input : bool = true
var death_position : Vector2
var death_timer_is_created : bool = false
var reload_position : Vector2
var frames_since_grounded = 0
var has_jumped : bool = false
var is_perma_disabled : bool = false

# Camera target
var target_list_size = 60
var target_index = 0
var last_velocity_x_list : Array[float]

func _ready() -> void:
	last_velocity_x_list.resize(target_list_size)

func _physics_process(delta):
	if is_alive and can_handle_user_input:
		handle_horizontal_movement(delta)
		handle_vertical_movement(delta)
		move_and_slide()
		handle_camera_target()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		BackgroundAudio.play_bell()
		SceneLoader.fade_in_scene("res://scenes/title.tscn")

func handle_camera_target():
	# Update list of last n velocity values
	last_velocity_x_list[target_index] = velocity.x
	target_index += 1
	target_index = target_index % target_list_size
	
	# Calculate avg velocity based on last 60 frames
	# Yes I could keep a running total, allowing just one subtraction, one additon, and one division
	# But I really can't be bothered
	var avg_velocity_x = avg(last_velocity_x_list)

	# Determine how much to lead the camera
	var x_lead = avg_velocity_x / 4
	camera_target.position.x = move_toward(camera_target.position.x, x_lead, 0.5)

	if is_on_floor():
		var look_up_down_direction = Input.get_axis("up", "down")
		camera_target.position.y = move_toward(camera_target.position.y, look_up_down_direction * 50, 1.5)

func handle_vertical_movement(delta):
	if is_perma_disabled:
		# Let the script controlling the player decide what their velocity should be
		return
		
	if is_on_floor():
		has_jumped = false
		frames_since_grounded = 0
	else:
		frames_since_grounded += 1
		# Add the gravity.
		var fall_factor = 0.4 if Input.is_action_pressed("jump") else 0.6
		velocity.y += gravity * fall_factor * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
		
		if velocity.y > 0 and sprite.animation != "fall":
			sprite.animation = "default"

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or is_on_wall() or (not has_jumped and frames_since_grounded < COYOTE_FRAMES):
			velocity.y = JUMP_VELOCITY
			has_jumped = true

func handle_horizontal_movement(_delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / 4)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 3)
	
	if is_on_floor():
		if velocity.x != 0:
			sprite.animation = "default"
		else:
			sprite.animation = "default"

	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

func avg(list : Array[float]) -> float:
	var total = 0.0
	for val in list:
		total += val
	return total / len(list)
