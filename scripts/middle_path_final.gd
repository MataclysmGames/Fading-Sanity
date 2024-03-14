extends Node2D

const gravity_vectors : Array[Vector2] = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]

@onready var player : Player = $Player
@onready var gravity_zone : GravityZone = $"Gravity Zone"
@onready var crystal : Crystal = $Crystal
@onready var moveable_wall : MoveableWall = $"Moveable Wall"

var gravity_zone_tween : Tween
var vector_index : int = 0

func _ready() -> void:
	MoodLighting.prepare_for_scene(0.8)
	BackgroundAudio.play_forest_ambience()
	BackgroundAudio.play_whispers_ambience(-20)
	BackgroundAudio.play_forest_music(1.5, 2.0)
	crystal.obtained.connect(on_crystal_obtained)
	
	gravity_zone_tween = create_tween()
	gravity_zone_tween.tween_callback(apply_new_gravity)
	gravity_zone_tween.tween_interval(2.5)
	gravity_zone_tween.set_loops()
	
	var move_wall_tween : Tween = create_tween()
	move_wall_tween.tween_interval(0.2)
	moveable_wall.move()

func apply_new_gravity():
	gravity_zone.apply_gravity_vector(gravity_vectors[vector_index])
	vector_index = (vector_index + 1) % len(gravity_vectors)

func on_crystal_obtained():
	gravity_zone_tween.kill()
	gravity_zone.apply_gravity_vector(Vector2(0, 1))
