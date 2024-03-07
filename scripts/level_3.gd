extends Node2D

@onready var player : Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MoodLighting.show()
	BackgroundAudio.play_whispers_ambience(-20, 0.5)
	BackgroundAudio.play_forest_music(1.65, 2.0)
