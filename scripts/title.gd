extends Control

const tween_duration : float = 0.4
const shader_max_aberration : float = 0.03

@onready var title_container: TitleContainer = $TitleContainer
@onready var settings_container: SettingsContainer = $SettingsContainer

var shader_aberration_value : float = 0.0
var shader_aberration_delta : float = 0.03
var aberration_enabled : bool = false

func _ready():
	MoodLighting.hide()
	BackgroundAudio.stop_music(0.0)
	BackgroundAudio.stop_ambience(0.0)
	BackgroundAudio.play_main_theme(0.4)
	title_container.settings_button.pressed.connect(on_settings_pressed)
	settings_container.back_button.pressed.connect(on_settings_back_pressed)
	SaveData.updated.connect(func(save_resource : SaveDataResource): aberration_enabled = save_resource.allow_aberration)
	settings_container.position += Vector2(1000, 0)
	settings_container.back_button.set_deferred("disabled", true)
	settings_container.visible = true
	aberration_enabled = (SaveData.get_resource() as SaveDataResource).allow_aberration

func _process(delta: float) -> void:
	if aberration_enabled and Engine.get_process_frames() % 10 == 0:
		shader_aberration_value += shader_aberration_delta * delta
		ScreenShader.set_aberration(shader_aberration_value)
		if abs(shader_aberration_value) > shader_max_aberration:
			shader_aberration_delta *= -1

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
