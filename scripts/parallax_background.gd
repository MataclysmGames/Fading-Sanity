extends ParallaxBackground

const SPEED : float = 20.0

@onready var fog_layer : ParallaxLayer = $FogLayer
@onready var fog_noise : TextureRect = $FogLayer/FogNoise

var layer_width : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	layer_width = fog_layer.motion_mirroring.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fog_noise.position.x -= SPEED * delta
	if fog_noise.position.x < layer_width:
		fog_noise.position.x += layer_width
