extends CanvasLayer

@export var main_game: Resource

func transition_to_game():
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to_packed(main_game)

func _on_StartGame_gui_input(event):
	if event.is_action_pressed("ui_accept"):
		$AnimationPlayer.play("start_game")
