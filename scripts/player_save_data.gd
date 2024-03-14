class_name PlayerSaveData
extends Resource

func _init() -> void:
	game_start_time = Time.get_unix_time_from_system() * 1000

# System Info
@export var game_start_time : int = 0
@export var game_finish_time : int = 0
@export var last_scene_loaded : String

# Player Stats
@export var health : float = 100

# Inventory
@export var has_slime_crystal : bool = false
@export var has_gravity_crystal : bool = false
@export var has_identity_crystal : bool = false

# State
@export var has_opened_top_path : bool = false
