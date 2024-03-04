class_name TransitionTrigger
extends Area2D

@export var scene_to_load : String
@export var player_load_position : Vector2
@export var player_load_animation : String = "idle"

var triggered : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body : Node2D):
	if body is Player and not triggered:
		triggered = true
		SceneLoader.fade_in_scene(scene_to_load, 0.5, 0.5)
		(body as Player).can_handle_user_input = false
		PlayerLoadInfo.load_position = player_load_position
		PlayerLoadInfo.load_animation = player_load_animation
