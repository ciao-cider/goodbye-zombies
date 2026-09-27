extends Node2D

@export var zombie_scene: PackedScene
@export var player: Character

@export var navigation_mesh: NavigationRegion2D
@onready var spawner_positions_node := $SpawnerPositions
var spawner_positions = []

func _ready():
	randomize()
	for position in spawner_positions_node.get_children():
		spawner_positions.append(position)

func spawn_zombie() -> Character:
	var random_spawner: Marker2D = spawner_positions[randf_range(0, spawner_positions.size())]
	var zombie = zombie_scene.instantiate()
	zombie.target = player
	zombie.global_position = random_spawner.global_position
	navigation_mesh.add_child(zombie)
	return zombie
