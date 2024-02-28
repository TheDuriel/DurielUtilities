class_name iFadeTransition
extends ScreenTransition

@export var color_rect: ColorRect


func _empty_to_solid() -> void:
	_set_children_visibility(true)
	
	var t: Tween = create_tween()
	t.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	await t.finished
	
	# Always emit this when done.
	transition_completed.emit()


func _solid_to_empty() -> void:
	_set_children_visibility(true)
	
	var t: Tween = create_tween()
	t.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), 0.5)
	await t.finished
	
	# Always make invisible when done.
	_set_children_visibility(false)
	transition_completed.emit()
