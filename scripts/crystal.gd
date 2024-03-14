class_name Crystal
extends Sprite2D

signal obtained()

enum CRYSTAL_NAME {SLIME, GRAVITY, IDENTITY}

@export var crystal_name : CRYSTAL_NAME = CRYSTAL_NAME.SLIME

@onready var area_2d : Area2D = $Area2D
@onready var point_light_2d : PointLight2D = $PointLight2D

func _ready() -> void:
	area_2d.body_entered.connect(on_body_entered)

func on_body_entered(body : Node2D):
	if body is Player:
		var player := body as Player
		player.disable_input_allow_gravity()
		obtained.emit()
		SaveData.obtain_crystal(crystal_name)
		
		var tween : Tween = create_tween()
		tween.tween_property(point_light_2d, "scale", Vector2(1.5, 1.5), 3)
		tween.parallel().tween_property(point_light_2d, "energy", 4, 3)
		tween.tween_callback(func(): SceneLoader.fade_in_scene("res://scenes/levels/home.tscn"))
