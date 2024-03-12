extends Node

func _ready():
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))

func _notification(what : int):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		handle_close()
		
func handle_close():
	print("Handle close")
