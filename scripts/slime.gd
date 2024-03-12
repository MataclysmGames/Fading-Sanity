class_name Slime
extends GenericEnemy

@export var jump_velocity : float = -300.0
@export var splits_remaining : int = 0
@export var initial_scale : Vector2 = Vector2(1, 1)

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var hurt_box : Area2D = $HurtBox

var timer : Timer = Timer.new()
var rotation_index : int = 0
var rotation_delta : int = 1

func _ready() -> void:
	super()
	scale = initial_scale
	add_child(timer)
	timer.timeout.connect(on_timer)
	timer.autostart = true
	timer.one_shot = false
	timer.start(0.35 + randf_range(0.00, 0.15))
	
	hurt_box.body_entered.connect(on_hurtbox_entered)

func _process(_delta: float) -> void:
	if not is_stunned:
		sprite.flip_h = velocity.x < 0

func on_timer():
	if not is_stunned and is_on_floor():
		jump()

func jump():
	rotation_index = rotation_index + rotation_delta
	if abs(rotation_index) >= 2:
		rotation_delta *= -1
	var next_rotation : float = rotation_index * 90
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(initial_scale.x, initial_scale.y * 0.8), 0.25)
	tween.tween_callback(func(): velocity.y = jump_velocity)
	tween.tween_property(self, "scale", Vector2(initial_scale.x, initial_scale.y * 1.2), 0.25)
	tween.tween_property(self, "rotation_degrees", next_rotation, 0.25)
	tween.tween_property(self, "scale", Vector2(initial_scale.x, initial_scale.y), 0)

func handle_death():
	var fade_tween : Tween = create_tween()
	sprite.modulate = Color(1, 0, 0, 1)
	if rotation_index % 2 == 1:
		fade_tween.tween_property(self, "scale", Vector2(initial_scale.x, 0), 1)
	else:
		fade_tween.tween_property(self, "scale", Vector2(0, initial_scale.y), 1)
	fade_tween.parallel().tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	fade_tween.tween_callback(split)
	fade_tween.tween_callback(queue_free)

func split():
	if splits_remaining > 0:
		var slime_split_1 : Slime = (load("res://scenes/slime.tscn") as PackedScene).instantiate() as Slime
		var slime_split_2 : Slime = (load("res://scenes/slime.tscn") as PackedScene).instantiate() as Slime
		slime_split_1.global_position = global_position + Vector2(-20, -20)
		slime_split_2.global_position = global_position + Vector2(20, -20)
		slime_split_1.splits_remaining = splits_remaining - 1
		slime_split_2.splits_remaining = splits_remaining - 1
		slime_split_1.initial_scale = initial_scale / 2
		slime_split_2.initial_scale = initial_scale / 2
		slime_split_1.max_health = max_health / 2
		slime_split_2.max_health = max_health / 2
		slime_split_1.jump_velocity = jump_velocity / 2
		slime_split_2.jump_velocity = jump_velocity / 2
		slime_split_1.detection_radius = detection_radius
		slime_split_2.detection_radius = detection_radius
		get_parent().add_child(slime_split_1)
		get_parent().add_child(slime_split_2)

func on_hurtbox_entered(body : Node2D):
	if body is Player and is_alive:
		var player := body as Player
		var knockback_direction : Vector2 = sprite.global_position.direction_to(body.global_position).normalized()
		knockback_direction.y = clampf(knockback_direction.y, -0.4, -1.0)
		player.take_damage(25, knockback_direction)
