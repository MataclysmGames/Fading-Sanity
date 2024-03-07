extends GenericEnemy

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _process(_delta: float) -> void:
	if not is_stunned:
		sprite.flip_h = velocity.x < 0
