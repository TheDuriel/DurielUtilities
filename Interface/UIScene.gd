class_name UIScene
extends MarginContainer

signal appear_animation_finished
signal hide_animation_finished


@export var darken_on_suspend: bool = false
@export_range(0.0, 1.0) var darken_ammount: float = 0.5

var stack: UISceneStack:
	set(value): Glue.readonly()
	get: return _stack
var is_suspended: bool:
	get: return _suspend_sources.size() > 0

var _stack: UISceneStack
var _suspend_sources: Array[Object] = []
var _suspend_rect: ColorRect = ColorRect.new()
var _suspend_tween: Tween


func _init() -> void:
	_suspend_rect.color = Color.BLACK
	_suspend_rect.visible = false
	add_child(_suspend_rect)
	add_theme_constant_override("margin_left", 0)
	add_theme_constant_override("margin_right", 0)
	add_theme_constant_override("margin_up", 0)
	add_theme_constant_override("margin_down", 0)


func _ready() -> void:
	appear_animation_finished.emit()


func set_stack(owning_stack: UISceneStack) -> void:
	_stack = owning_stack


func suspend(source: Object) -> void:
	if not source in _suspend_sources:
		_suspend_sources.append(source)
	_update_suspension()


func unsuspend(source: Object) -> void:
	if source in _suspend_sources:
		_suspend_sources.erase(source)
	_update_suspension()


func free_scene() -> void:
	hide_animation_finished.emit()
	queue_free()


func _update_suspension() -> void:
	var state: bool = not is_suspended # false if suspended, true if not
	var args: Array = [state]
	propagate_call("set_physics_process", args)
	propagate_call("set_process", args)
	propagate_call("set_process_input", args)
	propagate_call("set_process_shortcut_input", args)
	propagate_call("set_process_unhandled_input", args)
	propagate_call("set_process_unhandled_key_input", args)
	_animate_suspension()


func _animate_suspension() -> void:
	_suspend_rect.move_to_front()
	_suspend_tween = TweenHelper.replace(self, _suspend_tween)
	if is_suspended:
		_suspend_rect.visible = true
	_suspend_tween.tween_property(_suspend_rect, "modulate:a", 1.0 if is_suspended else 0.0, 0.15)
	if not is_suspended:
		_suspend_tween.tween_property(_suspend_rect, "visible", false, 0.0)
