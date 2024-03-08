extends Node2D

@onready var player : Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MoodLighting.show()
	BackgroundAudio.play_whispers_ambience(-30, 0.7)
	BackgroundAudio.play_forest_music(1.25, 2.0)
