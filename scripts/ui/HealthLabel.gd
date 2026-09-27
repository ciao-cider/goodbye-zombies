extends RichTextLabel

func _ready():
	Globals.player.connect("health_changed", Callable(self, "new_health_text"))

# new_health: float
func new_health_text(new_health) -> void:
	text = str(new_health)
