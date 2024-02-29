class_name TitleButton
extends Button

const button_tween_duration : float = 0.25

var hover_effect_active : bool = false
var initial_position : Vector2
var initial_position_set : bool = false

func _process(delta):
	register_initial_position()
	if is_hovered() and not hover_effect_active and not disabled:
		grab_focus()
	
	if has_focus() and not hover_effect_active and not disabled:
		hover_effect_active = true
		create_tween().tween_property(self, "position", initial_position + Vector2(-8, 0), button_tween_duration).set_trans(Tween.TRANS_EXPO)
	elif not has_focus() and hover_effect_active:
		hover_effect_active = false
		create_tween().tween_property(self, "position", initial_position, button_tween_duration).set_trans(Tween.TRANS_EXPO)
		

func register_initial_position():
	if not initial_position_set:
		initial_position_set = true
		initial_position = position
