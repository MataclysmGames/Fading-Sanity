extends GenericEnemy

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

var timer : Timer = Timer.new()

func _ready() -> void:
	super()
	add_child(timer)
	timer.timeout.connect(on_timer)
	timer.autostart = true
	timer.one_shot = false
	timer.start(0.25 + randf_range(0.00, 0.15))

func _process(delta: float) -> void:
	if not is_stunned:
		sprite.flip_h = velocity.x < 0

func on_timer():
	if not is_stunned and is_on_floor():
		jump()

func jump():
	var curr_rotation : float = rotation_degrees
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 0.8), 0.25)
	tween.tween_callback(func(): velocity.y = -300)
	tween.tween_property(self, "scale", Vector2(1, 1.2), 0.25)
	tween.tween_property(self, "rotation_degrees", curr_rotation + 90, 0.25)
	tween.tween_property(self, "scale", Vector2(1, 1), 0)
