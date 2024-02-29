extends Control

@onready var new_game_button: TitleButton = $VBoxContainer/NewGameButton
@onready var continue_button: TitleButton = $VBoxContainer/ContinueButton
@onready var settings_button: TitleButton = $VBoxContainer/SettingsButton
@onready var exit_button: TitleButton = $VBoxContainer/ExitButton

func _ready():
	BackgroundAudio.play_main_theme(0.4)
	new_game_button.pressed.connect(on_new_game)
	continue_button.pressed.connect(on_continue)
	settings_button.pressed.connect(on_settings)
	exit_button.pressed.connect(on_exit)
	
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
	pass

func on_continue():
	pass

func on_settings():
	pass

func on_exit():
	get_tree().quit()

func can_continue() -> bool:
	return false
