class_name Gun
extends Node2D

signal fired(aim_direction) # Vector2

@export var Bullet: Resource

@export var damage: int = 35
@export var fire_rate: float = 0.2
@export var accuracy: float = 7.5
@export var bullet_speed: float = 350.0
@export var bullet_range: int = 500.0
@export var knockback: float = 150.0
@export var self_knockback: float = 50.0
@export var spread_pattern := [] # (Array, int)
@export var penetration_power: int = 1
@export var magazine: int = 5

@export var enemy_collision_bit: int = 9

@onready var gun_sprite: Sprite2D = $GunSprite
@onready var muzzle_position: Marker2D = $GunSprite/MuzzlePosition
@onready var flash: Sprite2D = $GunSprite/MuzzlePosition/MuzzleFlash
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var fire_timer: Timer = $FireTimer
@onready var fire_sfx: AudioStreamPlayer = $FireSound

func hit_node(node: Node2D) -> void:
	if node.get_collision_layer_value(enemy_collision_bit) == true:
		var zombie := node.get_parent()
		zombie.damage(damage)
		if knockback > 0:
			zombie.knockback(-zombie.global_position.direction_to(global_position), knockback)

func _ready():
	randomize()
	fire_timer.wait_time = fire_rate

func spawn_bullet(aim_at: Vector2, spread: float):
	var bullet: Bullet = Bullet.instantiate()
	bullet.speed = bullet_speed
	bullet.penetration_power = penetration_power
	bullet.penetration_bit = enemy_collision_bit
	bullet.global_position = muzzle_position.global_position
	bullet.direction = global_position.direction_to(aim_at).rotated(deg_to_rad(spread))
	bullet.connect("hit", Callable(self, "hit_node"))
	get_viewport().add_child(bullet)

func fire(aim_at: Vector2) -> void: # make sure aim_at is global
	if fire_timer.is_stopped():
		emit_signal("fired", global_position.direction_to(aim_at))
		fire_timer.start()
		
		if spread_pattern.size() > 1:
			for spread in spread_pattern:
				spawn_bullet(aim_at, spread)
		else:
			var spread: float = randf_range(-accuracy, accuracy)
			spawn_bullet(aim_at, spread)
		
		animator.play("Fire")
		fire_sfx.play()
