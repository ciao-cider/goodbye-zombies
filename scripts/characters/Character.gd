class_name Character
extends CharacterBody2D

signal damaged(damaged_for) # float
signal health_changed(new_health) # float
signal died

@export var health: int = 100: set = set_health
var max_health: int = health
@export var accel: float = 50.0
@export var max_speed: float = 50.0
@export var damping: float = 1.0

var input_vector: Vector2 = Vector2()

func _on_death() -> void:
	emit_signal("died")

func _on_damaged(_damage_value: int) -> void:
	pass

func set_health(new_health: int) -> void:
	if health > 0:
		#warning-ignore:NARROWING_CONVERSION
		health = clamp(new_health, 0, max_health)
		if health <= 0:
			health = 0
			_on_death()
		emit_signal("health_changed", health)

func damage(damage_value: int) -> void:
	emit_signal("damaged", damage_value)
	set_health(health - damage_value)
	_on_damaged(damage_value)

# direction must be normalized
func knockback(direction: Vector2, knockback_value: float) -> void:
	velocity += direction * knockback_value

func move() -> void:
	velocity += input_vector * accel
	velocity /= 1 + damping
	velocity = velocity.limit_length(max_speed)
	
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
