extends Node2D

@onready var player : Player = $Player
@onready var background : BackgroundWithFog = $ParallaxBackground

func _ready() -> void:
	MoodLighting.show()
	BackgroundAudio.play_whispers_ambience(-20, 0.6)
	BackgroundAudio.play_forest_music(0.65, 2.0)
	background.set_fog_speed(0.1)

func _process(delta: float) -> void:
	if Engine.get_process_frames() % 500 == 0:
		BackgroundAudio.play_whispers_ambience(randf_range(-15, 0), randf_range(0.5, 0.7))
