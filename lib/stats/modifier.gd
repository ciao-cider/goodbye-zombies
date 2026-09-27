class_name Modifier
extends Resource

@export var mix_mode: MixMode = MixMode.ADDITIVE
@export var multiplier: float = 1.0
@export var add: float = 0.0

enum MixMode {ADDITIVE, MULTIPLICATIVE}

func _ready() -> void:
	pass

func apply(object: Stat) -> float:
	var value: float
	if mix_mode == MixMode.ADDITIVE:
		value = add
	elif mix_mode == MixMode.MULTIPLICATIVE:
		value = multiplier
	
	return value
