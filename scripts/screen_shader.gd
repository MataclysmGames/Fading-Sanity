extends ParallaxBackground

@onready var shader_rect : ColorRect = $ParallaxLayer/ShaderRect

func _process(delta: float) -> void:
	if Engine.get_process_frames() % 30 == 0 and not (SaveData.save_resource as SaveDataResource).allow_aberration:
		set_aberration(0.0)

func set_aberration(val : float):
	if not (SaveData.save_resource as SaveDataResource).allow_aberration:
		val = 0.0
	if shader_rect.material and shader_rect.material is ShaderMaterial:
		var shader : ShaderMaterial = shader_rect.material as ShaderMaterial
		shader.set_shader_parameter("aberration", val)

func set_pixelate(is_on : bool):
	if shader_rect.material and shader_rect.material is ShaderMaterial:
		var shader : ShaderMaterial = shader_rect.material as ShaderMaterial
		shader.set_shader_parameter("pixelate", is_on)
