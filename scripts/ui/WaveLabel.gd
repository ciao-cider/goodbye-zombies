extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalHub.connect("wave_changed", Callable(self, "new_wave_text"))

# new_wave: int
func new_wave_text(new_wave) -> void:
	text = "Wave: " + str(new_wave)
