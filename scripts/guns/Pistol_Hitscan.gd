extends Node2D

@export var damage: float = 35.0
@export var accuracy: float = 0.75
@export var bullet_range: float = 500.0
@export var knockback_enabled: bool = false
@export var knockback: float = 150.0

var enemy_bit: int = 9

@onready var gun_sprite: Sprite2D = $GunSprite
@onready var flash: Sprite2D = $GunSprite/FlashSprite
@onready var muzzle_position: Marker2D = $GunSprite/MuzzlePosition
@onready var fire_timer: Timer = $FireTimer
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var fire_sfx: AudioStreamPlayer = $FireSound
@onready var raycast: RayCast2D = $BulletRaycast
@onready var line2d: Line2D = $BulletLine2D

func _ready():
	randomize()
	line2d.set_as_top_level(true)

func hit_node(node: Node2D) -> void:
	if node.get_collision_layer_value(enemy_bit) == true:
		node.damage(damage)
		if knockback_enabled == true:
			node.knockback(-node.global_position.direction_to(global_position), knockback)

func fire(aim_at: Vector2) -> void: # make sure aim_at is global
	if fire_timer.is_stopped():
		fire_timer.start()
		
		var spread: float = randf_range(-accuracy, accuracy)
		raycast.target_position = (to_local(aim_at).normalized() * bullet_range).rotated(deg_to_rad(spread))
		raycast.force_raycast_update()
		
		line2d.points[0] = muzzle_position.global_position
		if raycast.is_colliding():
			var hit_collider = raycast.get_collider()
			line2d.points[1] = raycast.get_collision_point()
			hit_node(hit_collider)
		else:
			line2d.points[1] = to_global(raycast.target_position)
		
		animator.play("Fire")
		fire_sfx.play()
