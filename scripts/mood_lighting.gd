extends DirectionalLight2D

const default_energy_level : float = 0.95

var next_energy_level : float = 0.0

func prepare_for_scene(alt_energy_level : float = default_energy_level):
	energy = alt_energy_level
	show()

func change_energy(new_level : float, duration : float = 1.0):
	if new_level != next_energy_level:
		print(new_level)
		var tween : Tween = create_tween()
		tween.tween_property(self, "energy", new_level, duration)
		next_energy_level = new_level
