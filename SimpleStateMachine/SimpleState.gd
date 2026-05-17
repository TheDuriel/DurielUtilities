@abstract
class_name SimpleState
extends RefCounted
## Base State Class
##
## Extend this class to implement your own App States.
## Usually only the enter function needs to be defined.

signal entered
signal exited

var scene_tree: SceneTree


func can_enter_from(_active_state: SimpleState) -> bool: return _can_enter_from(_active_state)
func can_exit_to(_new_state: SimpleState) -> bool: return _can_exit_to(_new_state)
func enter(_previous_state: SimpleState) -> void: _enter(_previous_state)
func exit(_new_state: SimpleState) -> void: _exit(_new_state)
func emit_entered() -> void: entered.emit()
func emit_exited() -> void: exited.emit()
func pass_input(event: InputEvent) -> void: _input(event)
func pass_process(delta: float) -> void: _process(delta)
func pass_physics_process(delta: float) -> void: _physics_process(delta)


@abstract func _can_enter_from(_active_state: SimpleState) -> bool
@abstract func _can_exit_to(_new_state: SimpleState) -> bool
@abstract func _exit(_new_state: SimpleState) -> void
@abstract func _enter(_previous_state: SimpleState) -> void
@abstract func _input(event: InputEvent) -> void
@abstract func _process(delta: float) -> void
@abstract func _physics_process(delta: float) -> void
