extends Node2D

@onready var player : Player = $Player
@onready var gravity_zone: GravityZone = $"Gravity Zone"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MoodLighting.prepare_for_scene(0.8)
	BackgroundAudio.play_whispers_ambience(-30, 0.7)
	BackgroundAudio.play_forest_music(1.0, 2.0)
	
	var gravity_zone_tween : Tween = create_tween()
	gravity_zone_tween.tween_callback(reverse_gravity)
	gravity_zone_tween.tween_interval(1.6)
	gravity_zone_tween.set_loops()

func reverse_gravity():
	gravity_zone.apply_gravity_vector(gravity_zone.gravity_vector * -1)
