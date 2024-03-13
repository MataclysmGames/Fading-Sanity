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
	if SaveData.has_crystal(Crystal.CRYSTAL_NAME.SLIME):
		slime()
	else:
		explain_world()

func explain_world():
	has_spoken = true
	var tween : Tween = create_tween()
	tween.tween_callback(func(): dialogue_box.play_content("Ah, another Lost Soul."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.play_content("Very well..."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.play_content("I'll tell you what I told the others."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.play_content("There are three paths before you."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.play_content("Defeat the aberration at the end of each."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.play_content("Only then will the voices subside."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.play_content("Only then will you know peace."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.play_content("Now, leave an old blind man alone."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.hide_content())

func slime():
	has_spoken = true
	var tween : Tween = create_tween()
	tween.tween_callback(func(): dialogue_box.play_content("So you defeated the Slime King..."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.play_content("Perhaps you have hope after all."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.play_content("But first, retrieve the other two crystals."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.play_content("I'll hold on to this one for you."))
	tween.tween_interval(2.0)
	tween.tween_callback(func(): dialogue_box.hide_content())
