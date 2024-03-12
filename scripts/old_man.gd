extends GenericEnemy

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogue_box : DialogueBox = $DialogueBox

var has_spoken : bool = false

func _ready() -> void:
	super()
	dialogue_box.hide()

func _process(_delta: float) -> void:
	if target:
		sprite.flip_h = target.global_position.x > global_position.x
	
	if not has_spoken and target is Player and target.global_position.distance_to(global_position) < 100:
		speak()

func speak():
	has_spoken = true
	var tween : Tween = create_tween()
	tween.tween_callback(func(): dialogue_box.play_content("Ah, another Lost Soul."))
	tween.tween_interval(3.0)
	tween.tween_callback(func(): dialogue_box.play_content("Very well. Go fight the three aberrations."))
	tween.tween_interval(3.0)
	tween.tween_callback(func(): dialogue_box.play_content("Collect their treasures and return to me."))
	tween.tween_interval(3.0)
	tween.tween_callback(func(): dialogue_box.play_content("Only then will the voices subside."))
	tween.tween_interval(3.0)
	tween.tween_callback(func(): dialogue_box.hide_content())
