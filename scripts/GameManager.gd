extends Node

signal wave_started(new_wave) # int

@export var zombie_spawners: Node2D

var current_wave: int = 0
var wave_zombie_count: int = 0
var total_zombies_spawned_in_round: int = 0
var total_zombies_killed_in_round: int = 0

@onready var respawn_timer := $RespawnTimer
@onready var wave_break_timer := $WaveBreakTimer

func _ready():
	take_break()

func take_break() -> void:
	wave_break_timer.start()

func start_new_wave() -> void:
	current_wave += 1
	SignalHub.emit_signal("wave_changed", current_wave)
	wave_zombie_count = calculate_zombie_count()
	total_zombies_spawned_in_round = 0
	total_zombies_killed_in_round = 0
	
	Globals.player.set_health(Globals.player.health + 25)
	
	if current_wave == 5:
		respawn_timer.wait_time = 1.5
	elif current_wave == 10:
		respawn_timer.wait_time = 1.2
	elif current_wave == 15:
		respawn_timer.wait_time = 1
	respawn_timer.start()

func calculate_zombie_count() -> int:
	var calculated_count = 3 + current_wave * 2
	return calculated_count

func _on_Zombie_spawn():
	var zombie: Character = zombie_spawners.spawn_zombie()
	zombie.connect("died", Callable(self, "_on_Zombie_death"))
	
	var calculated_zombie_accel: float = zombie.accel + current_wave * 2.75
	calculated_zombie_accel = clamp(calculated_zombie_accel, zombie.accel, 65)
	zombie.accel = int(calculated_zombie_accel)
	
	total_zombies_spawned_in_round += 1
	if total_zombies_spawned_in_round == wave_zombie_count:
		respawn_timer.stop()

func _on_Zombie_death():
	total_zombies_killed_in_round += 1
	if total_zombies_killed_in_round >= wave_zombie_count:
		take_break()

func _on_WaveBreakTimer_timeout():
	start_new_wave()
