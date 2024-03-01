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
		new_game_button.focus_next = settings_button.get_path()
		new_game_button.focus_neighbor_bottom = settings_button.get_path()
		settings_button.focus_previous = new_game_button.get_path()
		settings_button.focus_neighbor_top = new_game_button.get_path()
		new_game_button.grab_focus()
		continue_button.set_deferred("disabled", true)
	else:
		continue_button.grab_focus()
	
func on_new_game():
	SaveData.purge_save_data()
	SaveData.save_resource.game_start_time = Time.get_unix_time_from_system()
	print("New game")

func on_continue():
	print("Continue")

func on_exit():
	get_tree().quit()

func can_continue() -> bool:
	return SaveData.has_save()
