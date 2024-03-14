extends Node2D

@onready var player : Player = $Player
@onready var moveable_wall : MoveableWall = $"Moveable Wall"

var boss_is_dead : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MoodLighting.prepare_for_scene()
	BackgroundAudio.play_forest_ambience()
	BackgroundAudio.play_whispers_ambience(-20)
	BackgroundAudio.play_forest_music(1.5, 2.0)

func _process(delta: float) -> void:
	if not boss_is_dead and Engine.get_process_frames() % 15 == 0:
		if all_enemies_dead():
			boss_is_dead = true
			handle_boss_death()

func all_enemies_dead() -> bool:
	var children : Array[Node] = get_children()
	for child in children:
		if child is Slime:
			return false
	return true

func handle_boss_death():
	player.disable_input_allow_gravity()
	player.camera.limit_right = 1216
	var scene_tween : Tween = create_tween()
	scene_tween.tween_property(player.camera_target, "global_position", moveable_wall.global_position, 1.0)
	scene_tween.tween_interval(0.5)
	scene_tween.tween_callback(moveable_wall.move)
	scene_tween.tween_interval(moveable_wall.movement_duration + 0.5)
	scene_tween.tween_property(player.camera_target, "global_position", player.global_position, 1.0)
	scene_tween.tween_callback(player.enable_input)
