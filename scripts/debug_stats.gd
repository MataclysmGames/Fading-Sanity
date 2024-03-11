extends CanvasLayer

@onready var fps_value: Label = $GridContainer/FpsValue
@onready var resolution_value: Label = $GridContainer/ResolutionValue
@onready var object_count_value: Label = $GridContainer/ObjectCountValue
@onready var processor_value: Label = $GridContainer/ProcessorValue
@onready var graphics_value: Label = $GridContainer/GraphicsValue
@onready var time_process_value: Label = $GridContainer/TimeProcessValue
@onready var time_physics_process_value: Label = $GridContainer/TimePhysicsProcessValue

var update_labels_tween : Tween

func _ready() -> void:
	SaveData.updated.connect(settings_updated)
	update_labels_tween = create_tween()
	update_labels_tween.tween_interval(2)
	update_labels_tween.tween_callback(update_labels)
	update_labels_tween.set_loops()

func settings_updated(resource : SaveDataResource):
	update_labels()
	visible = resource.show_debug_stats

func update_labels():
	var resolution : Vector2i = DisplayServer.screen_get_size()
	fps_value.text = "%d" % Engine.get_frames_per_second()
	resolution_value.text = "%dx%d" % [resolution.x, resolution.y]
	object_count_value.text = "%d" % Performance.get_monitor(Performance.OBJECT_COUNT)
	processor_value.text = "%s x%d" % [OS.get_processor_name(), OS.get_processor_count()]
	graphics_value.text = "%s" % [RenderingServer.get_video_adapter_name()]
	time_process_value.text = "%.1f ms" % [Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0]
	time_physics_process_value.text = "%.1f ms" % [Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000.0]
