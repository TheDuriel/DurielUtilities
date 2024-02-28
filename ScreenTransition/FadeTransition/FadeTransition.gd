class_name iFadeTransition
extends ScreenTransition

@export var color_rect: ColorRect


func _empty_to_solid(hide_when_done: bool) -> void:
	_set_children_visibility(true)
	
	var t: Tween = create_tween()
	t.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	await t.finished
	
	if hide_when_done:
		_set_children_visibility(false)
	# Always emit this when done.
	transition_completed.emit()


func _solid_to_empty(hide_when_done: bool) -> void:
	_set_children_visibility(true)
	
	var t: Tween = create_tween()
	t.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), 0.5)
	await t.finished
	
	if hide_when_done:
		_set_children_visibility(false)
	# Always emit this when done.
	transition_completed.emit()
