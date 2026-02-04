@tool
class_name GPUParticles2DHelper
extends GPUParticles2D

@export_category("Stats")
## The amount of particles emitted per second. Equal to ammount / lifetime
## This value can not be changed here.
@export var current_particles_per_second: float:
	get: return amount / lifetime

## The time in seconds between each particle. Equal to 1.0 / current_particles_per_second
## This value can not be changed here.
@export var current_particle_interval: float:
	get: return 1.0 / current_particles_per_second

@export_category("Spawn Rate")
## The ammount of particles you want to spawn.
@export var ammount_desired: int = 0
## The delay between each individual particle.
@export var interval_desired: float = 0.0
## The time that each individual particle should exist for.
@export var lifetime_desired: float = 0.0
## Press to calculate the lifetime
@export_tool_button("Lifetime from Amount+Interval") var calculate_lifetime_button: Callable = _calculate_lifetime
@export_tool_button("Amount from Interval+Lifetime") var calculate_amount_button: Callable = _calculate_amount


func _calculate_lifetime() -> void:
	amount = ammount_desired
	lifetime = interval_desired * ammount_desired
	print("Calculating -> Ammount: %s, Lifetime: %s, Interval: %s" % [amount, lifetime, interval_desired])


func _calculate_amount() -> void:
	amount = int(lifetime_desired / interval_desired)
	lifetime = lifetime_desired
	print("Calculating -> Ammount: %s, Lifetime: %s, Interval: %s" % [amount, lifetime, interval_desired])
