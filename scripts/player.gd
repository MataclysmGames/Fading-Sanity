class_name Player
extends CharacterBody2D

const SPEED : float = 160.0
const JUMP_VELOCITY : float = -250.0
const MAX_FALL_SPEED : float = 400.0
const COYOTE_FRAMES : float = 5

const one_shot_animations : Array[String] = ["disintegrate", "jump", "land", "death"]

@export var camera_limit_top : int = -2560
@export var camera_limit_left : int = -2560
@export var camera_limit_right : int = 2560
@export var camera_limit_bottom : int = 2560

@onready var camera : Camera2D = $Camera2D
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_target : RemoteTransform2D = $CameraTarget
@onready var attack_aim : Node2D = $AttackAim
@onready var hit_box : Area2D = $AttackAim/HitBox
@onready var attack_sprite : Sprite2D = $AttackAim/HitBox/CollisionShape2D/Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Player state
var is_alive : bool = true
var can_handle_user_input : bool = true
var frames_since_grounded = 0
var has_jumped : bool = false
var on_ground : bool = true
var has_been_on_ground : bool = false

# Player stats
var attack_damage : float = 24.9
var total_exp : float = 0.0

# Camera target
var target_list_size : int = 60
var target_index : int = 0
var last_velocity_x_list : Array[float]
var last_velocity_sum : float = 0.0

# Animation State
var one_shot_animation_playing : bool = false

func _ready() -> void:
	last_velocity_x_list.resize(target_list_size)
	sprite.animation_finished.connect(on_animation_finished)
	
	var load_position : Vector2 = PlayerLoadInfo.consume_load_position()
	if load_position:
		position = load_position
	if PlayerLoadInfo.consume_load_animation() == "death":
		reverse_death()
	
	camera.limit_top = camera_limit_top
	camera.limit_left = camera_limit_left
	camera.limit_right = camera_limit_right
	camera.limit_bottom = camera_limit_bottom

func _physics_process(delta):
	handle_gravity(delta)
	if is_alive and can_handle_user_input:
		handle_aim()
		handle_jump()
		handle_horizontal_movement()
		handle_camera_target()
	if (is_alive and can_handle_user_input) or not has_been_on_ground:
		move_and_slide()

func _process(delta: float) -> void:
	if (SaveData.save_resource as SaveDataResource).allow_aberration:
		var x_int : int = global_position.x
		var x_dist : int = (abs(x_int) % 400) - 200
		ScreenShader.set_aberration(clampf(x_dist / 4000.0, -0.05, 0.05))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		PauseMenu.toggle_pause(self)
	if event is InputEventMouseButton and can_handle_user_input:
		if (event as InputEventMouseButton).pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				handle_attack()
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				pass
		
func handle_attack():
	var hit_something : bool = false
	var attack_tween : Tween = create_tween()
	attack_tween.tween_callback(attack_sprite.show)
	attack_tween.tween_interval(0.1)
	attack_tween.tween_callback(attack_sprite.hide)
	for body in hit_box.get_overlapping_bodies():
		if body is GenericEnemy:
			hit_something = true
			var knockback_direction = sprite.global_position.direction_to(body.global_position).normalized()
			knockback_direction.y = clampf(knockback_direction.y, -0.4, -1.0)
			(body as GenericEnemy).take_damage(attack_damage, knockback_direction, self)
	print(hit_something)

func handle_aim():
	var global_mouse_pos : Vector2 = get_global_mouse_position()
	attack_aim.rotation = attack_aim.global_position.angle_to_point(global_mouse_pos)

func handle_gravity(delta : float):
	if is_on_floor():
		has_been_on_ground = true
		if sprite.animation == "fall":
			update_animation("land")
		has_jumped = false
		frames_since_grounded = 0
	else:
		frames_since_grounded += 1
		var fall_factor = 0.6 if Input.is_action_pressed("jump") else 1.2
		if velocity.y < 0: # going up
			fall_factor *= 0.75
		velocity.y += gravity * fall_factor * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
		
		if velocity.y > 0:
			update_animation("fall")

func handle_jump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or is_on_wall() or (not has_jumped and frames_since_grounded < COYOTE_FRAMES):
			velocity.y = JUMP_VELOCITY
			has_jumped = true
			update_animation("jump", true)

func handle_horizontal_movement():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / 4)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 3)
	
	if is_on_floor():
		if velocity.x != 0:
			if abs(velocity.x) > SPEED / 2:
				update_animation("run")
			else:
				update_animation("walk")
		else:
			update_animation("idle")

	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

func update_animation(animation_name : String, force_restart : bool = false, play_backwards : bool = false):
	if force_restart or sprite.animation != animation_name and not one_shot_animation_playing:
		#print(animation_name)
		if play_backwards:
			sprite.play_backwards(animation_name)
		else:
			sprite.play(animation_name)
		if sprite.animation in one_shot_animations:
			one_shot_animation_playing = true

func on_animation_finished():
	if sprite.animation in one_shot_animations:
		one_shot_animation_playing = false
	if sprite.animation == "death" and is_alive:
		can_handle_user_input = true

func death():
	update_animation("death", true)
	is_alive = false
	
func reverse_death():
	update_animation("death", true, true)
	can_handle_user_input = false

func handle_camera_target():
	var curr_velocity_x : float = velocity.x
	last_velocity_sum -= last_velocity_x_list[target_index]
	last_velocity_sum += curr_velocity_x
	last_velocity_x_list[target_index] = curr_velocity_x
	target_index += 1
	target_index = target_index % target_list_size

	var avg_velocity_x : float = last_velocity_sum / target_list_size

	var x_lead : float = avg_velocity_x / 3
	if camera_target.position.x * x_lead < 0 or (camera_target.position.x * x_lead >= 0 and abs(x_lead) > abs(camera_target.position.x)):
		camera_target.position.x = move_toward(camera_target.position.x, x_lead, 0.5)

	if is_on_floor():
		var look_up_down_direction = Input.get_axis("up", "down")
		camera_target.position.y = move_toward(camera_target.position.y, look_up_down_direction * 50, 1.5)

func avg(list : Array[float]) -> float:
	var total = 0.0
	for val in list:
		total += val
	return total / len(list)

func give_exp(amount : float):
	total_exp += amount
	print("Now have %d exp" % total_exp)
