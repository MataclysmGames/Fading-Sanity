class_name Crystal
extends Sprite2D

enum CRYSTAL_NAME {SLIME_KING, BOSS_B, BOSS_C}

@export var crystal_name : CRYSTAL_NAME = CRYSTAL_NAME.SLIME_KING

@onready var area_2d : Area2D = $Area2D
@onready var point_light_2d : PointLight2D = $PointLight2D

func _ready() -> void:
	area_2d.body_entered.connect(on_body_entered)

func on_body_entered(body : Node2D):
	if body is Player:
		var player := body as Player
		print("Player obtained %s" % [str(crystal_name)])
		player.can_handle_user_input = false
		var tween : Tween = create_tween()
		#tween.tween_property(point_light_2d, "scale", Vector2(20, 20), 3)
		tween.tween_property(point_light_2d, "energy", 20, 3)
		tween.tween_callback(func(): SceneLoader.flashbang_fade_in_scene("res://scenes/levels/home.tscn"))
