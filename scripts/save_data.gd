extends Node

const save_resource_name : String = "user://save.tres"

var save_resource : SaveDataResource

func _ready():
	reload()

func reload():
	save_resource = ResourceLoader.load(save_resource_name, "", ResourceLoader.CACHE_MODE_IGNORE) as SaveDataResource
	if not save_resource:
		save_resource = SaveDataResource.new()
		save_to_disk()

func save_to_disk():
	ResourceSaver.save(save_resource, save_resource_name)

func purge_save_data():
	save_resource = SaveDataResource.new()
	save_to_disk()

func has_save() -> bool:
	return save_resource.game_start_time != 0

func get_volume(bus_name : String) -> float:
	if not save_resource.audio_bus_volumes.has(bus_name):
		save_resource.audio_bus_volumes[bus_name] = 1.0
	return save_resource.audio_bus_volumes[bus_name]

func set_volume(bus_name : String, value : float):
	save_resource.audio_bus_volumes[bus_name] = value
	save_to_disk()
