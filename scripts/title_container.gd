class_name TitleContainer
extends Control

@onready var new_game_button: TitleButton = $NewGameButton
@onready var continue_button: TitleButton = $ContinueButton
@onready var settings_button: TitleButton = $SettingsButton
@onready var exit_button: TitleButton = $ExitButton

func _ready():
	new_game_button.pressed.connect(on_new_game)
	continue_button.pressed.connect(on_continue)
	exit_button.pressed.connect(on_exit)
	focus_first_button()

func focus_first_button():
	if not can_continue():
		continue_button.set_deferred("disabled", true)
		new_game_button.focus_previous = new_game_button.get_path()
		new_game_button.focus_neighbor_top = new_game_button.get_path()
		new_game_button.grab_focus()
	else:
		continue_button.grab_focus()

func on_new_game():
	new_game_button.release_focus()
	SaveData.purge_save_data()
	SaveData.start_new()
	BackgroundAudio.play_bell()
	PlayerLoadInfo.load_animation = "death"
	SceneLoader.fade_in_scene("res://scenes/intro.tscn", 3.4, 1.0)

func on_continue():
	continue_button.release_focus()
	BackgroundAudio.play_bell()
	SceneLoader.fade_in_scene("res://scenes/home.tscn", 3.4, 1.0)

func on_exit():
	get_tree().quit()

func can_continue() -> bool:
	return SaveData.has_save()
