class_name SettingsContainer
extends MarginContainer

@onready var back_button: TitleButton = $BackButton

@onready var master_volume_slider: HSlider = $GridContainer/MasterVolumeSlider
@onready var master_volume_value: Label = $GridContainer/MasterVolumeValue
@onready var music_volume_slider: HSlider = $GridContainer/MusicVolumeSlider
@onready var music_volume_value: Label = $GridContainer/MusicVolumeValue
@onready var sfx_volume_slider: HSlider = $GridContainer/SFXVolumeSlider
@onready var sfx_volume_value: Label = $GridContainer/SFXVolumeValue
@onready var ambient_volume_slider: HSlider = $GridContainer/AmbientVolumeSlider
@onready var ambient_volume_value: Label = $GridContainer/AmbientVolumeValue

func _ready() -> void:
	master_volume_slider.value_changed.connect(func(value : float): update_label(master_volume_value, "Master", value))
	music_volume_slider.value_changed.connect(func(value : float): update_label(music_volume_value, "Music", value))
	sfx_volume_slider.value_changed.connect(func(value : float): update_label(sfx_volume_value, "SFX", value))
	ambient_volume_slider.value_changed.connect(func(value : float): update_label(ambient_volume_value, "Ambient", value))
	
	var master_volume : float = SaveData.get_volume("Master")
	master_volume_slider.value = master_volume
	update_label(master_volume_value, "Master", master_volume)
	
	var music_volume : float = SaveData.get_volume("Music")
	music_volume_slider.value = music_volume
	update_label(music_volume_value, "Music", music_volume)
	
	var sfx_volume : float = SaveData.get_volume("SFX")
	sfx_volume_slider.value = sfx_volume
	update_label(sfx_volume_value, "SFX", sfx_volume)
	
	var ambient_volume : float = SaveData.get_volume("Ambient")
	ambient_volume_slider.value = ambient_volume
	update_label(ambient_volume_value, "Ambient", ambient_volume)

func update_label(label : Label, bus_name : String, value : float):
	print("Setting %s to %.3f" % [bus_name, value])
	label.text = "%3d" % (value * 100)
	var master_bus_index = AudioServer.get_bus_index(bus_name)
	if master_bus_index != -1:
		AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))
		SaveData.set_volume(bus_name, value)
	else:
		push_error("Unable to find audio bus")
