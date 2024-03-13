@tool
class_name GravityZone
extends Area2D

@export var gravity_vector : Vector2 = Vector2(0, 1)
@export var particle_amount : int = 1024

@onready var particles : CPUParticles2D = $Particles
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(on_body_entered)
	particles.visible = true
	particles.emission_rect_extents = (collision_shape_2d.shape as RectangleShape2D).size / 2.0
	particles.direction = gravity_vector
	particles.scale = Vector2(1, 1)
	particles.amount = particle_amount
	particles.position = gravity_vector * -80
	if gravity_vector.x != 0:
		particles.angle_min = 90
		particles.angle_max = 90

func _process(delta: float) -> void:
	pass

func on_body_entered(body : Node2D):
	if body is Player:
		(body as Player).set_gravity_vector(gravity_vector)
