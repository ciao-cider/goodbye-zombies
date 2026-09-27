extends Button

func _ready():
	connect("gui_input", Callable(self, "restart_game"))

func restart_game(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
