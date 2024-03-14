class_name GenericEnemy
extends CharacterBody2D

signal hit()

@export var max_health : float = 100.0
@export var speed : float = 60.0
@export var exp_given : float = 1.0
@export var detection_radius : float = 64
@export var respects_gravity : bool = true
@export var stun_duration : float = 0.25
@export var knockback_strength : float = 200.0

@onready var detection_area : Area2D = Area2D.new()

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var target : Player
var initial_position : Vector2
var is_stunned : bool = false
var stun_timer : Timer = Timer.new()
var health : float
var is_alive : bool = true

func _ready() -> void:
	health = max_health
	initial_position = global_position
	detection_area.body_entered.connect(on_body_detected)
	detection_area.body_exited.connect(on_body_undetected)
	var collision_shape : CollisionShape2D = CollisionShape2D.new()
	var detection_shape : CircleShape2D = CircleShape2D.new()
	detection_shape.radius = detection_radius
	collision_shape.shape = detection_shape
	detection_area.add_child(collision_shape)
	add_child(detection_area)
	
	stun_timer.one_shot = true
	stun_timer.timeout.connect(on_stun_end)
	add_child(stun_timer)

func _physics_process(delta: float) -> void:		
	if not is_stunned and is_alive:
		if target:
			on_target_process(target)
		else:
			on_no_target_process(initial_position)
	
	if not is_alive:
		velocity.x = 0

	if respects_gravity and not is_on_floor():
		velocity.y += gravity * delta
	velocity.y = clampf(velocity.y, -500, 500)
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

func on_body_undetected(body : Node2D):
	if body is Player:
		target = null

func take_damage(amount : float, knockback_direction : Vector2, player : Player):
	if is_stunned:
		return
		
	hit.emit()
	health -= amount
	if health <= 0.0 and is_alive:
		is_alive = false
		player.give_exp(exp_given)
		handle_death()
		return
		
	velocity = knockback_direction * knockback_strength
	is_stunned = true
	handle_stun()

func handle_stun():
	stun_timer.start(stun_duration)
	if "sprite" in self and self.sprite is AnimatedSprite2D:
		var animated_sprite : AnimatedSprite2D = (self.sprite as AnimatedSprite2D)
		animated_sprite.modulate = Color(1, 0, 0, 1)
		var flash_tween : Tween = animated_sprite.create_tween()
		flash_tween.tween_property(animated_sprite, "modulate", Color(1, 1, 1, 1), stun_duration)

func on_stun_end():
	is_stunned = false
	if health <= 0.0 and is_alive:
		handle_death()

func handle_death():
	var fade_tween : Tween = create_tween()
	if "sprite" in self and self.sprite is AnimatedSprite2D:
		var animated_sprite : AnimatedSprite2D = (self.sprite as AnimatedSprite2D)
		animated_sprite.modulate = Color(1, 0, 0, 1)
		fade_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.25)
	fade_tween.tween_callback(queue_free)
