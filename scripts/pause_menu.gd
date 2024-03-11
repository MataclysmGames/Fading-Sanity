extends CanvasLayer

@onready var settings_container : SettingsContainer = $SettingsContainer
@onready var quit_button: TitleButton = $SettingsContainer/QuitButton

var player : Player

func _ready() -> void:
	hide()
	settings_container.back_button.text = "Resume"
	settings_container.back_button.pressed.connect(resume_game)
	quit_button.pressed.connect(quit_game)
	
	settings_container.back_button.focus_next = quit_button.get_path()
	settings_container.back_button.focus_neighbor_right = quit_button.get_path()
	settings_container.back_button.focus_neighbor_bottom = settings_container.master_volume_slider.get_path()

	quit_button.focus_previous = settings_container.back_button.get_path()
	quit_button.focus_neighbor_left = settings_container.back_button.get_path()
	quit_button.focus_neighbor_top = settings_container.back_button.get_path()
	quit_button.focus_next = settings_container.master_volume_slider.get_path()
	
	quit_button.focus_neighbor_bottom = settings_container.master_volume_slider.get_path()
	
	settings_container.master_volume_slider.focus_previous = quit_button.get_path()
	settings_container.master_volume_slider.focus_neighbor_top = quit_button.get_path()

func toggle_pause(player : Player):
	self.player = player
	visible = not visible
	player.can_handle_user_input = not visible
	if visible:
		settings_container.update_settings_from_save()
		settings_container.back_button.grab_focus()

func resume_game():
	visible = false
	player.can_handle_user_input = true

func quit_game():
	visible = false
	BackgroundAudio.play_bell()
	SceneLoader.fade_in_scene("res://scenes/title.tscn")
