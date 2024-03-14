class_name OldMan
extends GenericEnemy

signal open_top_path()

const dialogue_duration : float = 2.25

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
		var player : Player = target as Player
		if player.is_on_floor():
			speak(player)

func speak(player : Player):
	if SaveData.has_opened_top_path():
		top_path(player)
	elif SaveData.has_crystal(Crystal.CRYSTAL_NAME.SLIME) and not SaveData.has_crystal(Crystal.CRYSTAL_NAME.GRAVITY):
		slime_only(player)
	elif SaveData.has_crystal(Crystal.CRYSTAL_NAME.GRAVITY) and not SaveData.has_crystal(Crystal.CRYSTAL_NAME.SLIME):
		gravity_only(player)
	elif SaveData.has_crystal(Crystal.CRYSTAL_NAME.GRAVITY) and SaveData.has_crystal(Crystal.CRYSTAL_NAME.SLIME):
		slime_and_gravity(player)
	else:
		explain_world(player)

func explain_world(player : Player):
	has_spoken = true
	var tween : Tween = create_tween()
	tween.tween_callback(player.disable_input_allow_gravity)
	tween.tween_callback(func(): dialogue_box.play_content("Ah, another Lost Soul."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("Very well..."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("I'll tell you what I told the others."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("There are three paths before you."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("Defeat the aberration at the end of each."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("Only then will the voices subside."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("Only then will you know peace."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("Now, leave an old blind man alone."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.hide_content())
	tween.tween_callback(player.enable_input)

func slime_only(player : Player):
	has_spoken = true
	var tween : Tween = create_tween()
	tween.tween_callback(player.disable_input_allow_gravity)
	tween.tween_callback(func(): dialogue_box.play_content("So you defeated the Slime King..."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("Perhaps there is hope for you after all."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("But you must still retrieve the other two crystals."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("I'll hold on to this one for you."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.hide_content())
	tween.tween_callback(player.enable_input)

func gravity_only(player : Player):
	has_spoken = true
	var tween : Tween = create_tween()
	tween.tween_callback(player.disable_input_allow_gravity)
	tween.tween_callback(func(): dialogue_box.play_content("I see you've conquered the gravity aberration."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("Perhaps there is hope for you after all."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("But you must still retrieve the other two crystals."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("I'll hold on to this one for you."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.hide_content())
	tween.tween_callback(player.enable_input)

func slime_and_gravity(player : Player):
	has_spoken = true
	var tween : Tween = create_tween()
	tween.tween_callback(player.disable_input_allow_gravity)
	tween.tween_callback(func(): dialogue_box.play_content("You have collected two crystals."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("Very impressive."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("It is clear you are ready for the final encounter."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("Brace yourself."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.hide_content())
	tween.tween_callback(func(): open_top_path.emit())

func top_path(player : Player):
	has_spoken = true
	var tween : Tween = create_tween()
	tween.tween_callback(player.disable_input_allow_gravity)
	tween.tween_callback(func(): dialogue_box.play_content("Take the top path ahead."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.play_content("Prove your worth."))
	tween.tween_interval(dialogue_duration)
	tween.tween_callback(func(): dialogue_box.hide_content())
	tween.tween_callback(player.enable_input)
