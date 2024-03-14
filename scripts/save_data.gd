extends Node

signal updated(resource: SaveDataResource)

const save_resource_name : String = "user://save.tres"

var save_resource : SaveDataResource

func _ready():
	reload()

func reload():
	save_resource = ResourceLoader.load(save_resource_name, "SaveDataResource", ResourceLoader.CACHE_MODE_IGNORE) as SaveDataResource
	if not save_resource:
		save_resource = SaveDataResource.new()
		save_to_disk()

func save_to_disk():
	ResourceSaver.save(save_resource, save_resource_name)
	updated.emit(save_resource)

func purge_save_data():
	var new_save_resource : SaveDataResource = SaveDataResource.new()
	new_save_resource.audio_bus_volumes = save_resource.audio_bus_volumes
	save_resource = new_save_resource
	save_to_disk()
	
func get_resource() -> SaveDataResource:
	return save_resource

func has_save() -> bool:
	return save_resource.player != null

func get_volume(bus_name : String) -> float:
	if not save_resource.audio_bus_volumes.has(bus_name):
		save_resource.audio_bus_volumes[bus_name] = 1.0
	return save_resource.audio_bus_volumes[bus_name]

func set_volume(bus_name : String, value : float):
	save_resource.audio_bus_volumes[bus_name] = value
	save_to_disk()

func start_new():
	save_resource.player = PlayerSaveData.new()
	save_to_disk()

func update_current_scene(file_path : String):
	save_resource.player.last_scene_loaded = file_path
	save_to_disk()

func get_last_scene() -> String:
	return save_resource.player.last_scene_loaded
	
func obtain_crystal(crystal_name : Crystal.CRYSTAL_NAME):
	match crystal_name:
		Crystal.CRYSTAL_NAME.SLIME:
			save_resource.player.has_slime_crystal = true
		Crystal.CRYSTAL_NAME.GRAVITY:
			save_resource.player.has_gravity_crystal = true
		Crystal.CRYSTAL_NAME.IDENTITY:
			save_resource.player.has_identity_crystal = true

func has_crystal(crystal_name : Crystal.CRYSTAL_NAME):
	match crystal_name:
		Crystal.CRYSTAL_NAME.SLIME:
			return save_resource.player.has_slime_crystal
		Crystal.CRYSTAL_NAME.GRAVITY:
			return save_resource.player.has_gravity_crystal
		Crystal.CRYSTAL_NAME.IDENTITY:
			return save_resource.player.has_identity_crystal
	return false

func open_top_path():
	save_resource.player.has_opened_top_path = true
	save_to_disk()

func has_opened_top_path() -> bool:
	return save_resource.player.has_opened_top_path
