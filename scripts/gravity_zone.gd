@tool
class_name GravityZone
extends Area2D

@export var gravity_vector : Vector2 = Vector2(0, 1)
@export var particle_amount : int = 1024
@export var color_particles : bool = false

@onready var particles : CPUParticles2D = $Particles
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var player : Player

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	apply_gravity_vector(gravity_vector, true)

func apply_gravity_vector(new_gravity_vector : Vector2, force : bool = false, time_until_player_affected : float = 0.25):
	if gravity_vector != new_gravity_vector or force:
		print("New vector: %s" % [str(new_gravity_vector)])
		gravity_vector = new_gravity_vector
		particles.visible = true
		particles.emission_rect_extents = (collision_shape_2d.shape as RectangleShape2D).size / 2.0
		particles.direction = gravity_vector
		particles.scale = Vector2(1, 1)
		particles.amount = particle_amount
		particles.position = gravity_vector * -80
		particles.initial_velocity_max *= gravity_vector.length()
		particles.initial_velocity_min *= gravity_vector.length()
		
		if gravity_vector.x != 0:
			particles.angle_min = 90
			particles.angle_max = 90
		else:
			particles.angle_min = 0
			particles.angle_max = 0
			
		if color_particles:
			if gravity_vector.y < 0:
				particles.modulate = Color(1, 0, 0, 1)
			elif gravity_vector.y > 0:
				particles.modulate = Color(0, 1, 0, 1)
			elif gravity_vector.x != 0:
				particles.modulate = Color(0, 0, 1, 1)
	
	if player:
		var tween : Tween = create_tween()
		tween.tween_interval(time_until_player_affected)
		tween.tween_callback(func(): player.set_gravity_vector(new_gravity_vector))

func _process(delta: float) -> void:
	pass

func on_body_entered(body : Node2D):
	if body is Player:
		player = body as Player
		player.set_gravity_vector(gravity_vector)

func on_body_exited(body : Node2D):
	if body is Player:
		player = null
