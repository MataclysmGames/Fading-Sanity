extends Node2D

@onready var player : Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MoodLighting.prepare_for_scene(0.8)
	BackgroundAudio.play_forest_ambience()
	BackgroundAudio.play_whispers_ambience(-10, 0.9)
	BackgroundAudio.play_forest_music(1.0, 2.0)
