class_name GenericEnemy
extends CharacterBody2D

@export var speed : float = 60.0
@export var detection_radius : float = 64
@export var respects_gravity : bool = true

@onready var detection_area : Area2D = Area2D.new()

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var target : Player
var initial_position : Vector2

func _ready() -> void:
	initial_position = global_position
	detection_area.body_entered.connect(on_body_detected)
	detection_area.body_exited.connect(on_body_undetected)
	var collision_shape : CollisionShape2D = CollisionShape2D.new()
	var detection_shape : CircleShape2D = CircleShape2D.new()
	detection_shape.radius = detection_radius
	collision_shape.shape = detection_shape
	add_child(detection_area)
	detection_area.add_child(collision_shape)

func _physics_process(delta: float) -> void:
	if target:
		on_target_process(target)
	else:
		on_no_target_process(initial_position)
		
	if respects_gravity and not is_on_floor():
		if velocity.y < 0:
			velocity.y = 0
		velocity.y += gravity * delta
	move_and_slide()

func on_target_process(target : Player):
	var direction = (target.global_position - global_position).normalized() * speed
	if respects_gravity:
		velocity.x = direction.x
	else:
		velocity = direction
		
func on_no_target_process(initial_position : Vector2):
	var direction = (initial_position - global_position).normalized() * speed / 2.0
	if respects_gravity:
		velocity.x = direction.x
	else:
		velocity = direction

func on_body_detected(body : Node2D):
	if body is Player:
		target = (body as Player)
		#print("Detected")

func on_body_undetected(body : Node2D):
	if body is Player:
		target = null
		#print("Undetected")
