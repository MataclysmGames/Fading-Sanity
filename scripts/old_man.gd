extends GenericEnemy

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	if target:
		sprite.flip_h = target.global_position.x > global_position.x
