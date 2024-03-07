extends Node2D

const reduced_volume_db : float = -20.0

@onready var music_player : AudioStreamPlayer = $MusicPlayer
@onready var ambience_player : AudioStreamPlayer = $AmbiencePlayer
@onready var sfx_player : AudioStreamPlayer = $SFXPlayer

var main_theme : AudioStream = load("res://external_assets/Free Sound/xythe_loop.wav")
var forest_music : AudioStream = load("res://external_assets/Free Sound/furbyguy_pno.wav")
var bell : AudioStream = load("res://external_assets/Free Sound/church_bell.wav")
var ambience : AudioStream = load("res://external_assets/Free Sound/forest-leaves_loop.wav")

func _ready():
	pass

func play_main_theme(pitch : float = 1.0):
	play_audio(music_player, main_theme, -25, 0.6, 0.25)

func play_forest_music(pitch : float = 1.0, transition_duration : float = 1.0):
	play_music(forest_music, reduced_volume_db, pitch, transition_duration)
	
func play_bell():
	play_audio(music_player, bell, reduced_volume_db, 1.0, 0.0)
	
func play_music(audio : AudioStream, volume : float = reduced_volume_db, pitch : float = 1.0, transition_duration : float = 1.0):
	play_audio(music_player, audio, volume, pitch, transition_duration)
	
func stop_music(transition_duration : float = 1.0):
	stop_audio(music_player, transition_duration)
	
func play_forest_ambience(volume : float = reduced_volume_db, pitch : float = 1.0, transition_duration : float = 1.0):
	play_audio(ambience_player, ambience, volume, pitch, transition_duration)
	
func stop_ambience(transition_duration : float = 1.0):
	stop_audio(ambience_player, transition_duration)

func play_audio(player : AudioStreamPlayer, audio : AudioStream, volume : float = reduced_volume_db, pitch : float = 1.0, transition_duration : float = 1.0):
	if not audio:
		return
	if player.stream and audio.resource_path == player.stream.resource_path and audio.loop_mode == AudioStreamWAV.LOOP_FORWARD:
		player.create_tween().tween_property(player, "volume_db", volume, transition_duration)
		player.create_tween().tween_property(player, "pitch_scale", pitch, transition_duration)
	else:
		var tween = player.create_tween()
		if player.playing:
			tween.tween_property(player, "volume_db", -100, transition_duration)
		tween.tween_callback(func(): player.stream = audio)
		tween.tween_callback(func(): player.volume_db = -30)
		tween.tween_callback(func(): player.pitch_scale = pitch)
		tween.tween_callback(player.play)
		tween.tween_property(player, "volume_db", volume, transition_duration)
		
func stop_audio(player : AudioStreamPlayer, transition_duration : float = 1.0):
	var tween = player.create_tween()
	tween.tween_property(player, "volume_db", -100, transition_duration)
	tween.tween_callback(player.stop)
