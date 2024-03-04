extends Node2D

@onready var player : Player = $Player
@onready var mood_lighting : DirectionalLight2D = $MoodLighting

var ambience : AudioStream = load("res://external_assets/405134__mjeno__autumn-forest-leaves-falling-close-to-pond-ii-loopable.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mood_lighting.visible = true
	BackgroundAudio.play_ambience(ambience)
	BackgroundAudio.play_forest_music(0.5)
	SceneLoader.set_color(Color(0, 0, 0, 0))
	if PlayerLoadInfo.load_animation == "death":
		player.reverse_death()
