extends Panel

@onready var trans_animation_player = $"../AnimationPlayer"

@onready var rich_text_label = $RichTextLabel
@onready var v_box_container = $VBoxContainer

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		visible = !visible
		get_tree().paused = !get_tree().paused

func _on_Restart_gui_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		visible = false
		get_tree().paused = false
