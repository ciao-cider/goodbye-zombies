extends Button

func _ready():
	connect("gui_input", Callable(self, "quit_game"))

func quit_game(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().quit()
