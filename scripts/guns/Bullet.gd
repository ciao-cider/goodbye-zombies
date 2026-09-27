class_name Bullet
extends Sprite2D

signal hit(node) # Node

@export var speed := 500.0
@export var penetration_power: int = 1
@export var penetration_bit: int = 1

var _hit_count: int = 0
var original_shooter
var direction := Vector2()

func _ready():
	set_as_top_level(true)

func _process(delta: float):
	look_at(global_position + direction)
	global_position += direction * speed * delta

func _on_hit(body) -> void:
	_hit_count += 1
	emit_signal("hit", body)
	if _hit_count >= penetration_power:
		queue_free()
	elif not body.get_collision_layer_value(penetration_bit):
		queue_free()

func _on_Hitbox_body_entered(body):
	_on_hit(body)

func _on_Hitbox_area_entered(area):
	_on_hit(area)
