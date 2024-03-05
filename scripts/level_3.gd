extends Node2D

@onready var player : Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MoodLighting.show()
	BackgroundAudio.play_forest_ambience()
	BackgroundAudio.play_forest_music(0.85, 2.0)
	if PlayerLoadInfo.load_animation == "death":
		player.reverse_death()
