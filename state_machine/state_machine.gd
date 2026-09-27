class_name StateMachine
extends Node

signal state_changed(old_state: State, new_state: State)

@export var target: Character
@export var starting_state: State

var current_state: State
var current_state_name: String

func _ready() -> void:
	for state in get_children():
		state.state_machine = self
		state.root_node = owner
		state.init_state()
	starting_state.enter()
	current_state = starting_state

func transition_to(state_path: NodePath) -> void:
	var state: State = get_node(state_path)
	current_state.exit()
	
	state_changed.emit(current_state, state)
	current_state = state
	current_state.enter()

func _physics_process(delta: float) -> void:
	current_state.physics_process_update(delta)

func _process(delta: float) -> void:
	current_state.process_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	current_state.unhandled_input_update(event)
