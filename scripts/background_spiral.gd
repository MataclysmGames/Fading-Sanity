class_name BackgroundSpiral
extends Node2D

const tween_duration : float = 45.0

@onready var texture_rect : TextureRect = $TextureRect

func _ready():
	create_zoom_tween()
	create_pulse_tween()
	pass

func create_zoom_tween():
	var tween = create_tween()
	tween.tween_property(texture_rect, "rotation_degrees", 0, 0).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(texture_rect, "rotation_degrees", 360, tween_duration).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(texture_rect, "scale", Vector2(1.5, 1.5), tween_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(texture_rect, "rotation_degrees", 0, 0).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(texture_rect, "rotation_degrees", 360, tween_duration).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(texture_rect, "scale", Vector2(1, 1), tween_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.set_loops()

func create_pulse_tween():
	var pulse_tween : Tween = create_tween()
	var gradient : Gradient = (texture_rect.texture as NoiseTexture2D).color_ramp
	var offsets : PackedFloat32Array = gradient.offsets
	var desired_high_offsets := offsets.duplicate()
	desired_high_offsets[1] = 0.65
	desired_high_offsets[2] = 0.75
	desired_high_offsets[3] = 0.85
	
	var desired_low_offsets := offsets.duplicate()
	desired_low_offsets[1] = 0.50
	desired_low_offsets[2] = 0.65
	desired_low_offsets[3] = 0.95
	
	pulse_tween.tween_property(gradient, "offsets", desired_low_offsets, 5.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	pulse_tween.tween_property(gradient, "offsets", desired_high_offsets, 5.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	pulse_tween.set_loops()
