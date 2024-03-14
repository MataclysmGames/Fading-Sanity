extends Node2D

const reduced_volume_db : float = -20.0

@onready var music_player : AudioStreamPlayer = $MusicPlayer
@onready var ambience_player : AudioStreamPlayer = $AmbiencePlayer
@onready var whispers_ambience_player : AudioStreamPlayer = $WhispersAmbiencePlayer
@onready var voices_ambience_player : AudioStreamPlayer = $VoicesAmbiencePlayer
@onready var sfx_player : AudioStreamPlayer = $SFXPlayer
@onready var footstep_player : AudioStreamPlayer = $FootstepPlayer

var main_theme : AudioStream = load("res://external_assets/Free Sound/xythe_loop.wav")
var forest_music : AudioStream = load("res://external_assets/Free Sound/furbyguy_pno.wav")
var bell : AudioStream = load("res://external_assets/Free Sound/church_bell.wav")
var forest_leaves : AudioStream = load("res://external_assets/Free Sound/forest-leaves_loop.wav")
var whispers : AudioStream = load("res://external_assets/Free Sound/whispers.mp3")
var voices : AudioStream = load("res://external_assets/Free Sound/voices.mp3")

var footstep_audios : Array[AudioStream] = [
	load("res://external_assets/Kenney/footstep_grass_000.ogg"),
	load("res://external_assets/Kenney/footstep_grass_001.ogg"),
	load("res://external_assets/Kenney/footstep_grass_002.ogg"),
	load("res://external_assets/Kenney/footstep_grass_003.ogg"),
	load("res://external_assets/Kenney/footstep_grass_004.ogg")
]

func _ready():
	pass

func play_random_footstep(extra_volume : float = 0.0, force : bool = false):
	if not footstep_player.playing or force:
		var volume : float = randf_range(reduced_volume_db - 15, reduced_volume_db - 12) + extra_volume
		var pitch : float = 1.0 if force else randf_range(0.6, 1.0)
		play_audio(footstep_player, footstep_audios.pick_random(), volume, pitch, 0.0)

func play_voices_ambience(volume : float = reduced_volume_db, pitch : float = 0.5, transition_duration : float = 1.0):
	play_audio(voices_ambience_player, voices, volume, pitch, transition_duration)

func play_main_theme(pitch : float = 1.0):
	play_audio(music_player, main_theme, -25, pitch, 0.25)

func play_forest_music(pitch : float = 1.0, transition_duration : float = 1.0):
	play_music(forest_music, reduced_volume_db, pitch, transition_duration)

func play_bell():
	play_audio(music_player, bell, reduced_volume_db, 1.0, 0.0)
	
func play_music(audio : AudioStream, volume : float = reduced_volume_db, pitch : float = 1.0, transition_duration : float = 1.0):
	play_audio(music_player, audio, volume, pitch, transition_duration)
	
func stop_music(transition_duration : float = 1.0):
	stop_audio(music_player, transition_duration)
	
func play_forest_ambience(volume : float = reduced_volume_db, pitch : float = 1.0, transition_duration : float = 1.0):
	play_audio(ambience_player, forest_leaves, volume, pitch, transition_duration)

func play_whispers_ambience(volume : float = reduced_volume_db, pitch : float = 1.0, transition_duration : float = 1.0):
	play_audio(whispers_ambience_player, whispers, volume, pitch, transition_duration)
	
func stop_ambience(transition_duration : float = 1.0):
	stop_audio(ambience_player, transition_duration)

func play_audio(player : AudioStreamPlayer, audio : AudioStream, volume : float = reduced_volume_db, pitch : float = 1.0, transition_duration : float = 1.0):
	if not audio:
		return
	if player.stream and audio.resource_path == player.stream.resource_path:
		if "loop_mode" in audio and audio.loop_mode == AudioStreamWAV.LOOP_FORWARD or "loop" in audio and audio.loop:
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
