class_name SaveDataResource
extends Resource

# Game Stats
@export var game_start_time : int = 0
@export var game_finish_time : int = 0

# Settings
@export var audio_bus_volumes : Dictionary = {
	"Master": 1.0,
	"SFX": 0.75,
	"Ambient": 0.85
}
