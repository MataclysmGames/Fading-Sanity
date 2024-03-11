class_name MoveableWall
extends Node2D

@export var relative_movement : Vector2 = Vector2(0, 0)
@export var movement_duration : float = 1.0

func move():
	var movement_tween : Tween = create_tween()
	movement_tween.tween_property(self, "global_position", global_position + relative_movement, movement_duration)
