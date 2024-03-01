extends CanvasModulate

var normal_dim_level = Color(1, 1, 1, 1)
var fade_out_level = Color(0, 0, 0, 1)

func _ready() -> void:
	color = normal_dim_level

func fade_in_scene(scene_name : StringName, duration_out : float = 1.0, duration_in : float = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "color", fade_out_level, duration_out)
	tween.tween_callback(func(): get_tree().change_scene_to_file(scene_name))
	tween.tween_property(self, "color", normal_dim_level, duration_in)
	
func reload_scene(duration : float = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "color", fade_out_level, duration)
	tween.tween_callback(func(): get_tree().reload_current_scene())
	tween.tween_property(self, "color", normal_dim_level, duration)

func set_dimness(level : float = 0.5, duration : float = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "color", level, duration)
