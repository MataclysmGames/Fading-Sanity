extends Node2D

@onready var player : Player = $Player
@onready var old_man : OldMan = $"Old Man"
@onready var background : BackgroundWithFog = $ParallaxBackground
@onready var wall_1: MoveableWall = $Wall1
@onready var wall_2: MoveableWall = $Wall2

func _ready() -> void:
	MoodLighting.prepare_for_scene()
	BackgroundAudio.play_forest_ambience()
	BackgroundAudio.play_whispers_ambience(-20, 0.6)
	BackgroundAudio.play_forest_music(0.65)
	background.set_fog_speed(0.1)
	old_man.open_top_path.connect(on_open_top_path)
	
	if SaveData.has_opened_top_path():
		wall_1.move()
		wall_2.move()

func _process(delta: float) -> void:
	if Engine.get_process_frames() % 500 == 0:
		BackgroundAudio.play_whispers_ambience(randf_range(-15, 0), randf_range(0.5, 0.7))

func on_open_top_path():
	SaveData.open_top_path()
	player.disable_input_allow_gravity()
	var scene_tween : Tween = create_tween()
	scene_tween.tween_property(player.camera_target, "global_position", wall_1.global_position, 1.0)
	scene_tween.tween_interval(0.5)
	scene_tween.tween_callback(wall_1.move)
	scene_tween.parallel().tween_callback(wall_2.move)
	scene_tween.tween_interval(wall_1.movement_duration + 0.5)
	scene_tween.tween_property(player.camera_target, "global_position", player.global_position, 1.0)
	scene_tween.tween_callback(player.enable_input)
