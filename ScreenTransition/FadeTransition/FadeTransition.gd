@tool
class_name iFadeTransition
extends ScreenTransition

@export var fade_time: float = 1.0
@export var color_rect: ColorRect


func _empty_to_solid(hide_when_done: bool) -> void:
	visible = true
	
	color_rect.color = Color.BLACK
	color_rect.color.a = 0.0
	
	var t: Tween = create_tween()
	t.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), fade_time)
	await t.finished
	
	visible = not hide_when_done
	# Always emit this when done.
	empty_to_solid_completed.emit()


func _solid_to_empty(hide_when_done: bool) -> void:
	visible = true
	
	color_rect.color = Color.BLACK
	color_rect.color.a = 1.0
	
	var t: Tween = create_tween()
	t.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), fade_time)
	await t.finished
	
	visible = not hide_when_done
	# Always emit this when done.
	solid_to_empty_completed.emit()
