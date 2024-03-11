extends Node2D

@export var light_level : float = 1.0

@onready var point_light_2d : PointLight2D = $PointLight2D
@onready var sprite_2d : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	point_light_2d.energy = light_level

func _process(_delta: float) -> void:
	if Engine.get_process_frames() % 4 == 0:
		var rand_val : float = randf_range(0.0, 1.0)
		if rand_val > 0.90:
			sprite_2d.flip_h = not sprite_2d.flip_h
			if rand_val > 0.93:
				point_light_2d.energy = light_level * 1.1
			elif rand_val > 0.96:
				point_light_2d.energy = light_level * 0.9
			else:
				point_light_2d.energy = light_level
