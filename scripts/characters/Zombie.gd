extends Character

@export var speed: float

var target: Character

@onready var navigation_agent_2d := $NavigationAgent2D

func _physics_process(delta: float) -> void:
	if target:
		navigation_agent_2d.target_position = target.global_position
		var next_position: Vector2 = navigation_agent_2d.get_next_path_position()
		velocity = (next_position - global_position).normalized() * speed * delta
	
	move_and_slide()
