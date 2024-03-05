extends GenericEnemy

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func on_target_process(target : Player):
	var direction = (target.global_position - global_position).normalized() * speed
	if respects_gravity:
		velocity.x = direction.x
	else:
		velocity = direction
	sprite.flip_h = velocity.x < 0
		
func on_no_target_process(initial_position : Vector2):
	var direction = (initial_position - global_position).normalized() * speed / 2.0
	if respects_gravity:
		velocity.x = direction.x
	else:
		velocity = direction
	sprite.flip_h = velocity.x < 0
