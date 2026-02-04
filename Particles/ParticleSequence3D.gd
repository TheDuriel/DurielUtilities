@tool
class_name ParticleSequence3D
extends Node3D
## ParticleSequence3D
##
## Executes particles with a custom time offset per.

signal finished

var _t: Tween

@export_tool_button("Test") var test_button: Callable = run

## Repeat infinitely
@export var loop: bool = false
## How many times to repeat before finishing
@export_range(1, 100) var repeats: int = 1

## Additional time between each particle system
@export_range(0.0, 60.0) var delay: float = 0.0

@export var system_0: GPUParticles3D
@export_range(0.0, 60.0, 0.01) var system_0_delay: float = 0.0
@export var system_1: GPUParticles3D
@export_range(0.0, 60.0, 0.01) var system_1_delay: float = 0.0
@export var system_2: GPUParticles3D
@export_range(0.0, 60.0, 0.01) var system_2_delay: float = 0.0
@export var system_3: GPUParticles3D
@export_range(0.0, 60.0, 0.01) var system_3_delay: float = 0.0
@export var system_4: GPUParticles3D
@export_range(0.0, 60.0, 0.01) var system_4_delay: float = 0.0
@export var system_5: GPUParticles3D
@export_range(0.0, 60.0, 0.01) var system_5_delay: float = 0.0
@export var system_6: GPUParticles3D
@export_range(0.0, 60.0, 0.01) var system_6_delay: float = 0.0
@export var system_7: GPUParticles3D
@export_range(0.0, 60.0, 0.01) var system_7_delay: float = 0.0
@export var system_8: GPUParticles3D
@export_range(0.0, 60.0, 0.01) var system_8_delay: float = 0.0
@export var system_9: GPUParticles3D
@export_range(0.0, 60.0, 0.01) var system_9_delay: float = 0.0


func _ready() -> void:
	if system_0:
		system_0.one_shot = true
		system_0.emitting = false
	if system_1:
		system_1.one_shot = true
		system_1.emitting = false
	if system_2:
		system_2.one_shot = true
		system_2.emitting = false
	if system_3:
		system_3.one_shot = true
		system_3.emitting = false
	if system_4:
		system_4.one_shot = true
		system_4.emitting = false
	if system_5:
		system_5.one_shot = true
		system_5.emitting = false
	if system_6:
		system_6.one_shot = true
		system_6.emitting = false
	if system_7:
		system_7.one_shot = true
		system_7.emitting = false
	if system_8:
		system_8.one_shot = true
		system_8.emitting = false
	if system_9:
		system_9.one_shot = true
		system_9.emitting = false


func run() -> void:
	if _t:
		cancel()
	
	_t = create_tween()
	
	if system_0:
		_t.tween_callback(system_0.restart)
		_t.tween_interval(delay + system_0_delay)
	if system_1:
		_t.tween_callback(system_1.restart)
		_t.tween_interval(delay + system_1_delay)
	if system_2:
		_t.tween_callback(system_2.restart)
		_t.tween_interval(delay + system_2_delay)
	if system_3:
		_t.tween_callback(system_3.restart)
		_t.tween_interval(delay + system_3_delay)
	if system_4:
		_t.tween_callback(system_4.restart)
		_t.tween_interval(delay + system_4_delay)
	if system_5:
		_t.tween_callback(system_5.restart)
		_t.tween_interval(delay + system_5_delay)
	if system_6:
		_t.tween_callback(system_6.restart)
		_t.tween_interval(delay + system_6_delay)
	if system_7:
		_t.tween_callback(system_7.restart)
		_t.tween_interval(delay + system_7_delay)
	if system_8:
		_t.tween_callback(system_8.restart)
		_t.tween_interval(delay + system_8_delay)
	if system_9:
		_t.tween_callback(system_9.restart)
		_t.tween_interval(delay + system_9_delay)
	
	if loop:
		_t.set_loops()
	else:
		_t.set_loops(repeats)
		_t.tween_callback(finished.emit)


func cancel() -> void:
	if _t:
		_t.kill()
		_t = null
	finished.emit()
