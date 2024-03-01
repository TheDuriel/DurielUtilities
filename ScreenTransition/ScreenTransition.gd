@tool
class_name ScreenTransition
extends Control
## ScreenTransition
##
## Base class for building reusable screen transitions from
## Screen transitions shoul be unique to the game scene
## Usage example:
## await Interface.generic_transition.empty_to_solid()

signal empty_to_solid_completed
signal solid_to_empty_completed

@export var test_empty_to_solid: bool = false:
	set(value): empty_to_solid(true)
@export var test_solid_to_empty: bool = false:
	set(value): solid_to_empty(true)


func _ready() -> void:
	visible = false


func empty_to_solid(hide_when_done: bool = false) -> Signal:
	_empty_to_solid.call_deferred(hide_when_done)
	return empty_to_solid_completed


func solid_to_empty(hide_when_done: bool = true) -> Signal:
	_solid_to_empty.call_deferred(hide_when_done)
	return solid_to_empty_completed


# Override this in inherited scene
func _empty_to_solid(hide_when_done: bool) -> void:
	visible = true
	
	# Your animation here
	#var t: Tween = create_tween()
	#t.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	#await t.finished
	
	# Always emit this when done.
	visible = not hide_when_done
	empty_to_solid_completed.emit()


# Override this in inherited scene
func _solid_to_empty(hide_when_done: bool) -> void:
	visible = true
	
	# Your animation here
	#var t: Tween = create_tween()
	#t.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.5)
	#await t.finished
	
	visible = not hide_when_done
	solid_to_empty_completed.emit()
