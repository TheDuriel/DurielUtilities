class_name iFadeTransition
extends ScreenTransition

@export var color_rect: ColorRect
@export var fade_time: float = 1.0


func _empty_to_solid(hide_when_done: bool) -> void:
	_set_children_visibility(true)
	
	var t: Tween = create_tween()
	t.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), fade_time)
	await t.finished
	
	if hide_when_done:
		_set_children_visibility(false)
	# Always emit this when done.
	empty_to_solid_completed.emit()


func _solid_to_empty(hide_when_done: bool) -> void:
	_set_children_visibility(true)
	
	var t: Tween = create_tween()
	t.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), fade_time)
	await t.finished
	
	if hide_when_done:
		_set_children_visibility(false)
	# Always emit this when done.
	solid_to_empty_completed.emit()
