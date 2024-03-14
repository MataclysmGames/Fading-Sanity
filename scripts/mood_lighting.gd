extends DirectionalLight2D

const default_energy_level : float = 0.95

func prepare_for_scene(alt_energy_level : float = default_energy_level):
	energy = alt_energy_level
	show()
