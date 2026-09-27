extends Character

@export var attack_damage: int = 50

var target: CharacterBody2D
var target_in_attack_range = false
var attacking = false

@onready var hurtbox := $Hurtbox
@onready var detection_range := $DetectionRange
@onready var attack_range := $AttackRange
@onready var animation_state_machine = $AnimationTree.get("parameters/playback")
@onready var hurt_sfx := $HurtSound
@onready var death_sfx := $DeathSound

func _ready():
	$AnimationTree.set_active(true)

func _on_death():
	super._on_death()
	set_physics_process(false)
	detection_range.set_deferred("monitoring", false)
	attack_range.set_deferred("monitoring", false)
	hurtbox.set_deferred("monitorable", false)
	
	death_sfx.play()
	animation_state_machine.travel("Death")

func _on_damaged(_damage_value: int):
	hurt_sfx.play()

func damage_current_target():
	target.damage(attack_damage)
	if target.health <= 0:
		target = null
		target_in_attack_range = false

func attack(_attack_target: CharacterBody2D):
	if attacking == false:
		attacking = true
		$AttackCooldown.start()
		$DamageTimer.start()

func _on_attack_end():
	attacking = false
	if target_in_attack_range:
		attack(target)

func _on_DamageTimer_timeout():
	if target and target_in_attack_range == true:
		damage_current_target()

func animate():
	if attacking == true:
		animation_state_machine.travel("Attack")
	elif velocity.length() > 0.5:
		animation_state_machine.travel("Run")
	else:
		animation_state_machine.travel("Idle")

func _physics_process(_delta):
	if target and !attacking and !$NavigationAgent2D.is_navigation_finished():
		$NavigationAgent2D.set_target_position(target.global_position)
		input_vector = ($NavigationAgent2D.get_next_path_position() - get_global_position()).normalized()
	var difference = input_vector
	if input_vector != Vector2.ZERO:
		if difference.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	
	move()
	animate()

func _on_DetectionRange_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		input_vector = (target.global_position - get_global_position()).normalized()

func _on_DetectionRange_body_exited(body):
	if body == target:
		target = null

func _on_AttackRange_body_entered(body):
	if body == target:
		input_vector = Vector2.ZERO
		target_in_attack_range = true
		attack(target)

func _on_AttackRange_body_exited(body):
	if body == target:
		target_in_attack_range = false

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	input_vector = safe_velocity
