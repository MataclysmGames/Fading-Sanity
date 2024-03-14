extends Node2D

@onready var player : Player = $Player
@onready var finish: Area2D = $Finish

var farthest_x : float = 0
var finished : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MoodLighting.prepare_for_scene(0.99)
	BackgroundAudio.stop_music()
	BackgroundAudio.stop_ambience()
	BackgroundAudio.play_whispers_ambience(-30, 1.6)
	BackgroundAudio.play_voices_ambience(-28, 0.8)
	farthest_x = player.global_position.x
	
	player.general_light.energy = 0.05
	player.precise_light.energy = 0.1
	player.can_attack = false
	
	finish.body_entered.connect(on_finish)

func _process(delta: float) -> void:
	if finished:
		return
		
	farthest_x = max(farthest_x, player.global_position.x)
	var x_int : int = farthest_x
	var distance : int = x_int / 250
	MoodLighting.change_energy(1 - distance * 0.01)
	
	if Engine.get_process_frames() % 300 == 0:
		var base_volume : float = -15 - distance * 1.9
		var volume : float = randf_range(base_volume - 5, base_volume + 5)
		var pitch : float = randf_range(0.5, 1.2)
		if distance >= 13:
			volume = -80
		BackgroundAudio.play_voices_ambience(volume, pitch)
		BackgroundAudio.play_whispers_ambience(volume, 1.4)

	player.general_light.energy = 0.05 + distance * 0.003
	player.precise_light.energy = 0.1 + distance * 0.003

func on_finish(body : Node2D):
	if body is Player:
		print("Finished")
		BackgroundAudio.play_voices_ambience(-80, 1.0)
		BackgroundAudio.play_whispers_ambience(-80, 1.0)
		finished = true
		player.disable_input_allow_gravity()
		
		var tween : Tween = create_tween()
		tween.tween_interval(1.2)
		tween.tween_callback(func(): player.sprite.flip_h = true)
		tween.tween_interval(2.5)
		tween.tween_callback(func(): player.sprite.flip_h = false)
		tween.tween_callback(player.run.bind(Vector2(50, 0)))
		tween.tween_interval(5.0)
		tween.tween_callback(func(): SceneLoader.fade_in_scene("res://scenes/levels/credits.tscn"))
