extends Character

@export var sprinting_accel = 75.0
@export var equipped_gun: Gun

@onready var default_accel = accel

@onready var animation_state_machine = $AnimationTree.get("parameters/playback")
@onready var hurt_sfx: AudioStreamPlayer = $HurtSound

var firing := false

func _on_death():
	super._on_death()
	queue_free()

func _ready():
	Globals.player = self
	$AnimationTree.set_active(true)

func animate():
	if velocity.length() > 0.5:
		animation_state_machine.travel("Run")
	else:
		animation_state_machine.travel("Idle")

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("fire"):
		firing = true
	elif event.is_action_released("fire"):
		firing = false

func _physics_process(_delta: float):
	var mouse_position = get_global_mouse_position()
	var difference = position - mouse_position
	if difference.x < 0:
		$Sprite2D.flip_h = false
		equipped_gun.scale.y = 1
	else:
		$Sprite2D.flip_h = true
		equipped_gun.scale.y = -1
		difference = -difference
	equipped_gun.look_at(mouse_position)
	if firing:
		equipped_gun.fire(mouse_position)
	
	if Input.is_action_pressed("sprint"):
		accel = sprinting_accel
	else:
		accel = default_accel
	
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move()
	animate()

func _on_damaged(damage_value) -> void:
	print("damaged")
	hurt_sfx.play()

func _on_Pistol_fired(aim_direction: Vector2):
	knockback(-aim_direction, equipped_gun.self_knockback)
