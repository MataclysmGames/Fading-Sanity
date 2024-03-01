extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		BackgroundAudio.play_bell()
		SceneLoader.fade_in_scene("res://scenes/title.tscn")
