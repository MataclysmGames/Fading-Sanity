class_name PlayerSaveData
extends Resource

func _init() -> void:
	game_start_time = Time.get_unix_time_from_system() * 1000

# Game Stats
@export var game_start_time : int = 0
@export var game_finish_time : int = 0
@export var last_scene_loaded : String

# Player Stats
