class_name BackgroundWithFog
extends ParallaxBackground

const SPEED : float = 50.0

@onready var fog_layer : ParallaxLayer = $FogLayer
@onready var fog_noise : TextureRect = $FogLayer/FogNoise
@onready var fog_shader: ColorRect = $FogLayer/FogShader

var layer_width : float
var shader_material : ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	layer_width = fog_layer.motion_mirroring.x
	shader_material = fog_shader.material as ShaderMaterial
	shader_material.set_shader_parameter("speed", Vector2(0.05, 0.01))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fog_noise.position.x -= SPEED * delta
	if fog_noise.position.x < -layer_width:
		fog_noise.position.x += layer_width

func set_fog_speed(speed : float):
	shader_material.set_shader_parameter("speed", Vector2(speed, 0.01))
