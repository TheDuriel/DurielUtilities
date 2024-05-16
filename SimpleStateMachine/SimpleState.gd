class_name SimpleState
extends RefCounted
## Base State Class
##
## Extend this class to implement your own App States.
## Usually only the enter function needs to be defined.

signal entered
signal exited

var scene_tree: SceneTree


func can_enter_from(_active_state: SimpleState) -> bool:
	return true


func can_exit_to(_new_state: SimpleState) -> bool:
	return true


func enter(_previous_state: SimpleState) -> void:
	entered.emit()


func exit(_new_state: SimpleState) -> void:
	exited.emit()
