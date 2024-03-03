extends Node

var load_position : Vector2 = Vector2(0, 0)
var load_animation : String = "idle"

func consume_load_position() -> Vector2:
	var position = load_position
	load_position = Vector2(0, 0)
	return position
