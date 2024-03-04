extends CanvasLayer

@onready var color_rect : ColorRect = $ColorRect

const normal_dim_level = Color(0, 0, 0, 0)
const fade_out_level = Color(0, 0, 0, 1)

var fade_tween : Tween

func _ready() -> void:
	color_rect.color = normal_dim_level

func fade_in_scene(scene_name : StringName, duration_out : float = 1.0, duration_in : float = 1.0):
	fade_tween = create_tween()
	fade_tween.tween_property(color_rect, "color", fade_out_level, duration_out)
	fade_tween.tween_callback(func(): get_tree().change_scene_to_file(scene_name))
	fade_tween.tween_property(color_rect, "color", normal_dim_level, duration_in)
	
func reload_scene(duration : float = 1.0):
	fade_tween = create_tween()
	fade_tween.tween_property(color_rect, "color", fade_out_level, duration)
	fade_tween.tween_callback(func(): get_tree().reload_current_scene())
	fade_tween.tween_property(color_rect, "color", normal_dim_level, duration)

func set_light_level(level : float = 0.5):
	if fade_tween:
		fade_tween.kill()
	color_rect.color = Color(0, 0, 0, level)

func set_color(color : Color = Color(0, 0, 0, 0.5)):
	if fade_tween:
		fade_tween.kill()
	color_rect.color = color
