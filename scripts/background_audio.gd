extends Node2D

const reduced_volume_db : float = -22.5

@onready var audio_stream_player : AudioStreamPlayer = $AudioStreamPlayer

var main_theme : AudioStream = load("res://external_assets/100870__xythe__loop.wav")
var bell : AudioStream = load("res://external_assets/76405__dsp9000__old-church-bell.wav")
var current_audio_resource = "none"

func _ready():
	pass

func play_main_theme(pitch : float = 1.0):
	play_audio(main_theme, reduced_volume_db, pitch, 0.25)
	
func play_bell():
	play_audio(bell, reduced_volume_db, 1.0, 0.0)

func play_audio(audio : AudioStream, volume : float = reduced_volume_db, pitch : float = 1.0, transition_duration : float = 2.0):
	if not audio:
		return
	if audio.resource_path == current_audio_resource and audio.loop_mode == AudioStreamWAV.LOOP_FORWARD:
		audio_stream_player.create_tween().tween_property(audio_stream_player, "volume_db", volume, transition_duration)
		audio_stream_player.create_tween().tween_property(audio_stream_player, "pitch_scale", pitch, transition_duration)
	else:
		current_audio_resource = audio.resource_path
		var tween = audio_stream_player.create_tween()
		if audio_stream_player.playing:
			tween.tween_property(audio_stream_player, "volume_db", -100, transition_duration)
		tween.tween_callback(func(): audio_stream_player.stream = audio)
		tween.tween_callback(func(): audio_stream_player.volume_db = -30)
		tween.tween_callback(func(): audio_stream_player.pitch_scale = pitch)
		tween.tween_callback(audio_stream_player.play)
		tween.tween_property(audio_stream_player, "volume_db", volume, transition_duration)
		
func stop_audio(fade_duration : float = 1.0):
	current_audio_resource = "none"
	var tween = audio_stream_player.create_tween()
	tween.tween_property(audio_stream_player, "volume_db", -100, fade_duration)
	tween.tween_callback(audio_stream_player.stop)
