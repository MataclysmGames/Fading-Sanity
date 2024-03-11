class_name SaveDataResource
extends Resource

# Game Stats
@export var game_start_time : int = 0
@export var game_finish_time : int = 0

# Settings
@export var audio_bus_volumes : Dictionary = {
	"Master": 0.5,
	"Music": 0.9,
	"SFX": 0.8,
	"Ambient": 1.0
}
@export var allow_aberration : bool = true
@export var allow_pixelation : bool = true
@export var show_debug_stats : bool = false
