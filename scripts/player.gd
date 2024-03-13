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
@onready var attack_animated_sprite : AnimatedSprite2D = $AttackAim/HitBox/CollisionShape2D/AttackAnimatedSprite

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Player state
var health : float = 100.0
var is_alive : bool = true
var can_handle_user_input : bool = true
var frames_since_grounded = 0
var has_jumped : bool = false
var on_ground : bool = true
var has_been_on_ground : bool = false
var has_i_frames : bool = false
var can_attack : bool = true
var gravity_vector : Vector2 = Vector2(0, 1)

# Player stats
@export var attack_damage : float = 25.1
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
	attack_animated_sprite.animation_finished.connect(on_attack_animation_finished)
	
	var load_position : Vector2 = PlayerLoadInfo.consume_load_position()
	if load_position:
		position = load_position
	if PlayerLoadInfo.consume_load_animation() == "death":
		reverse_death()
	
	camera.limit_top = camera_limit_top
	camera.limit_left = camera_limit_left
	camera.limit_right = camera_limit_right
	camera.limit_bottom = camera_limit_bottom
	
	var current_scene_file : String = get_tree().current_scene.scene_file_path
	SaveData.update_current_scene(current_scene_file)

func _physics_process(delta):
	if is_alive and can_handle_user_input:
		handle_aim()
		handle_jump()
		handle_directional_movement(delta)
		handle_camera_target()
	handle_gravity(delta)
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
	if can_handle_user_input and event.is_action_pressed("attack"):
		handle_attack()

func disable_input_allow_gravity():
	velocity.x = 0
	can_handle_user_input = false
	has_been_on_ground = false

func enable_input():
	can_handle_user_input = true
	
func set_gravity_vector(vec : Vector2):
	gravity_vector = vec
	up_direction = gravity_vector * -1
	if gravity_vector.y < 0:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	if gravity_vector.x > 0:
		rotation_degrees = -90
	elif gravity_vector.x < 0:
		rotation_degrees = 90
	else:
		rotation_degrees = 0

func handle_attack():
	if not can_attack:
		return

	can_attack = false
	attack_animated_sprite.play()
	
	var hit_something : bool = false
	for body in hit_box.get_overlapping_bodies():
		if body is GenericEnemy:
			hit_something = true
			var knockback_direction = sprite.global_position.direction_to(body.global_position).normalized()
			knockback_direction.y = clampf(knockback_direction.y, -0.4, -1.0)
			(body as GenericEnemy).take_damage(attack_damage, knockback_direction, self)
	print(hit_something)
	
func get_input_direction() -> Vector2:
	if gravity_vector.x > 0 and gravity_vector.y == 0:
		return Input.get_vector("up", "down", "right", "left")
	elif gravity_vector.x < 0 and gravity_vector.y == 0:
		return Input.get_vector("up", "down", "left", "right")
	return Input.get_vector("left", "right", "up", "down")

func handle_aim():
	if not can_attack:
		return
		
	var direction : Vector2 = get_input_direction()
	if abs(direction.y) > abs(direction.x):
		# attacking up or down
		if direction.y > 0:
			attack_aim.rotation_degrees = 90
		else:
			attack_aim.rotation_degrees = -90
	else:
		if direction.x == 0:
			direction.x = -1 if sprite.flip_h else 1
		if direction.x < 0:
			attack_aim.rotation_degrees = 180
		else:
			attack_aim.rotation_degrees = 0

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
		velocity += gravity * gravity_vector * fall_factor * delta
		velocity.y = clampf(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)
		
		if velocity.y > 0:
			update_animation("fall")

func handle_jump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or is_on_wall() or (not has_jumped and frames_since_grounded < COYOTE_FRAMES):
			if gravity_vector.y != 0:
				velocity.y = JUMP_VELOCITY / gravity_vector.y
			elif gravity_vector.x != 0:
				velocity.x = JUMP_VELOCITY / gravity_vector.x
			has_jumped = true
			update_animation("jump", true)

func handle_directional_movement(delta):
	var direction : Vector2 = get_input_direction()
	if gravity_vector.x != 0:
		velocity.y = move_toward(velocity.y, direction.y * SPEED, SPEED * delta * 15)
	else:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, SPEED * delta * 15)

	var horizontal_velocity : float = velocity.x if gravity_vector.y != 0 else velocity.y
	if is_on_floor():
		if horizontal_velocity != 0:
			if abs(horizontal_velocity) > SPEED / 2:
				update_animation("run")
			else:
				update_animation("walk")
		else:
			update_animation("idle")
	
	if gravity_vector.x > 0:
		horizontal_velocity *= -1
	if horizontal_velocity < 0:
		sprite.flip_h = true
	elif horizontal_velocity > 0:
		sprite.flip_h = false

func update_animation(animation_name : String, force_restart : bool = false, play_backwards : bool = false):
	if not is_alive:
		return
	if force_restart or sprite.animation != animation_name and not one_shot_animation_playing:
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

func on_attack_animation_finished():
	can_attack = true

func death():
	if is_on_floor():
		update_animation("death", true)
	else:
		update_animation("disintegrate", true)
	is_alive = false
	can_handle_user_input = false
	var death_tween : Tween = create_tween()
	death_tween.tween_interval(1.0)
	death_tween.tween_callback(SceneLoader.reload_scene)
	
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
		var look_direction : Vector2 = get_input_direction()
		camera_target.position.y = move_toward(camera_target.position.y, look_direction.y * 50, 1.5)

func avg(list : Array[float]) -> float:
	var total : float = 0.0
	for val in list:
		total += val
	return total / len(list)

func give_exp(amount : float):
	total_exp += amount
	print("Now have %d exp" % total_exp)

func take_damage(amount : float, knockback_direction : Vector2):
	if has_i_frames:
		return
	
	has_i_frames = true
	health -= amount
	print("Player has %d health." % [health])
	velocity = knockback_direction * 300
	
	var hit_tween : Tween = create_tween()
	hit_tween.tween_property(sprite, "modulate", Color(1, 0, 0, 0.5), 0)
	hit_tween.tween_interval(0.25)
	hit_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0.5), 0.25)
	hit_tween.tween_interval(0.25)
	hit_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0)
	hit_tween.tween_callback(func(): has_i_frames = false)

	if health <= 0.0 and is_alive:
		death()
