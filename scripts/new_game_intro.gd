extends Node2D

@onready var center_label : Label = $CanvasLayer/CenterLabel

var initial_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = center_label.global_position
	var tween : Tween = create_tween()
	show_text(tween, "", 0.0, 0.0)
	show_text(tween, "It started out so simple...")
	tween.tween_callback(BackgroundAudio.play_whispers_ambience.bind(-35))
	show_text(tween, "Just another day...")
	tween.tween_callback(BackgroundAudio.play_whispers_ambience.bind(-30))
	show_text(tween, "But that's when they started...")
	tween.tween_callback(BackgroundAudio.play_whispers_ambience.bind(-20))
	show_text(tween, "...")
	tween.tween_callback(BackgroundAudio.play_whispers_ambience.bind(-15))
	show_text(tween, "I just want them to stop...")

	tween.tween_callback(func(): SceneLoader.fade_in_scene("res://scenes/levels/intro.tscn"))

func show_text(tween : Tween, text : String, fade_duration : float = 1.5, show_duration : float = 2.5):
	tween.tween_property(center_label, "global_position", initial_position + Vector2(randf_range(-100, 100), randf_range(-100, 100)), 0.0)
	tween.tween_callback(func(): center_label.text = text)
	tween.tween_property(center_label, "modulate", Color(1, 1, 1, 1), fade_duration)
	tween.parallel().tween_property(center_label, "visible_ratio", 1, fade_duration)
	tween.tween_interval(show_duration)
	tween.tween_property(center_label, "modulate", Color(1, 1, 1, 0), fade_duration)
	tween.parallel().tween_property(center_label, "visible_ratio", 0, fade_duration)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
