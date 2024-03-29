extends Node2D

@onready var player : Player = $Player
@onready var background : BackgroundWithFog = $ParallaxBackground

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MoodLighting.prepare_for_scene()
	BackgroundAudio.play_forest_ambience()
	BackgroundAudio.play_forest_music(0.65)
	background.set_fog_speed(0.04)
