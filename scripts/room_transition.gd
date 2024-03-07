class_name RoomTransition
extends Area2D

const tween_duration : float = 0.8

@export var camera_limit_bottom : float = 1000
@export var camera_limit_left : float = -1000
@export var camera_limit_right : float = 1000
@export var camera_limit_top : float = -1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_body_entered(body : Node2D):
	if body is Player:
		var player : Player = body as Player
		var tween : Tween = player.create_tween()
		tween.tween_property(player.camera, "limit_bottom", camera_limit_bottom, tween_duration)
		tween.parallel().tween_property(player.camera, "limit_left", camera_limit_left, tween_duration)
		tween.parallel().tween_property(player.camera, "limit_right", camera_limit_right, tween_duration)
		tween.parallel().tween_property(player.camera, "limit_top", camera_limit_top, tween_duration)
