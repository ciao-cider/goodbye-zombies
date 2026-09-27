extends Node

var crosshair = preload("res://sprites/ui/crosshair.png")

func _ready():
	Input.set_custom_mouse_cursor(crosshair)
