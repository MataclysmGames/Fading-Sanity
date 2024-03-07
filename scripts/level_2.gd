extends Node2D

@onready var player : Player = $Player
@onready var background: BackgroundWithFog = $ParallaxBackground

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MoodLighting.show()
	BackgroundAudio.play_whispers_ambience()
	BackgroundAudio.play_forest_music(0.65, 2.0)
	background.set_fog_speed(0.1)
