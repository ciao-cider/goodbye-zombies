class_name Stat
extends Resource

signal value_changed

@export var minimum: int = 0
@export var maximum: int = 0
@export var value: int:
	set(new_value):
		#var total_add: int = 0
		#var total_mult: float = 1.0
		#
		#var multiplicative_mods: Array[Modifier] = []
		## apply additive mods first
		#for modifier: Modifier in modifiers:
			#if modifier.mix_mode == Modifier.MixMode.MULTIPLICATIVE:
				#multiplicative_mods.push_back(modifier)
				#print("mult detected")
			#else:
				#total_add += modifier.apply(self)
		## apply multiplicative mods second
		#for modifier: Modifier in multiplicative_mods:
			#total_mult *= modifier.apply(self)
		#
		#new_value = int(float((new_value + total_add)) * total_mult)
		
		value = clamp(new_value, minimum, maximum)
		value_changed.emit()

@export var modifiers: Array[Modifier] = []

func _ready() -> void:
	pass

func _init(new_min: int = 0, new_max: int = 1, new_value: int = 1) -> void:
	minimum = new_min
	maximum = new_max
	value = new_value

func is_min() -> bool:
	if value == minimum:
		return true
	else:
		return false
