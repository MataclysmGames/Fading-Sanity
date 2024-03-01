extends Control

const tween_duration : float = 0.4

@onready var title_container: TitleContainer = $TitleContainer
@onready var settings_container: SettingsContainer = $SettingsContainer

func _ready():
	BackgroundAudio.stop_audio(0.0)
	BackgroundAudio.play_main_theme(0.4)
	title_container.settings_button.pressed.connect(on_settings_pressed)
	settings_container.back_button.pressed.connect(on_settings_back_pressed)
	settings_container.position += Vector2(1000, 0)
	settings_container.back_button.set_deferred("disabled", true)
	settings_container.visible = true

func on_settings_pressed():
	var tween = create_tween()
	tween.tween_property(title_container, "position", title_container.position - Vector2(1000, 0), tween_duration).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(settings_container, "position", settings_container.position - Vector2(1000, 0), tween_duration).set_trans(Tween.TRANS_EXPO)
	title_container.settings_button.set_deferred("disabled", true)
	settings_container.back_button.set_deferred("disabled", false)
	settings_container.back_button.grab_focus()

func on_settings_back_pressed():
	var tween = create_tween()
	tween.tween_property(title_container, "position", title_container.position + Vector2(1000, 0), tween_duration).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(settings_container, "position", settings_container.position + Vector2(1000, 0), tween_duration).set_trans(Tween.TRANS_EXPO)
	title_container.settings_button.set_deferred("disabled", false)
	settings_container.back_button.set_deferred("disabled", true)
	title_container.focus_first_button()
