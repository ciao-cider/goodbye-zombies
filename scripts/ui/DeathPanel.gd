extends Panel

@onready var pause = $"../Pause"

func _on_Player_died():
	pause.queue_free()
	visible = true
