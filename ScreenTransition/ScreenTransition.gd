class_name ScreenTransition
extends Node
## ScreenTransition
##
## Base class for building reusable screen transitions from
## Screen transitions shoul be unique to the game scene
## Usage example:
## await Interface.generic_transition.empty_to_solid()

signal transition_completed


func _ready() -> void:
	_set_children_visibility(false)
	_post_ready.call_deferred()


func _post_ready() -> void:
	get_parent().move_child(self, -1)


func empty_to_solid(hide_when_done: bool = false) -> Signal:
	_empty_to_solid.call_deferred(hide_when_done)
	return transition_completed


func solid_to_empty(hide_when_done: bool = true) -> Signal:
	_solid_to_empty.call_deferred(hide_when_done)
	return transition_completed


# Override this in inherited scene
func _empty_to_solid(hide_when_done: bool) -> void:
	_set_children_visibility(true)
	
	# Your animation here
	#var t: Tween = create_tween()
	#t.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	#await t.finished
	
	# Always emit this when done.
	if hide_when_done:
		_set_children_visibility(false)
	transition_completed.emit()


# Override this in inherited scene
func _solid_to_empty(hide_when_done: bool) -> void:
	_set_children_visibility(true)
	
	# Your animation here
	#var t: Tween = create_tween()
	#t.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.5)
	#await t.finished
	
	if hide_when_done:
		_set_children_visibility(false)
	transition_completed.emit()


func _set_children_visibility(visibility: bool) -> void:
	for child: Node in get_children():
		if child is CanvasItem or child is CanvasLayer:
			child.visible = visibility
