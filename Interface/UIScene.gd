@abstract
class_name UIScene
extends MarginContainer

signal enter_animation_finished
signal exit_animation_finished

@export var darken_on_suspend: bool = false

var stack: UISceneStack:
	set(value): Glue.readonly()
	get: return _stack
var is_suspended: bool:
	set(value): Glue.readonly()
	get: return _is_suspended

var _stack: UISceneStack
var _is_suspended: bool = false
var _suspend_sources: Array[Object] = []
var _suspend_rect: ColorRect = ColorRect.new()
var _suspend_tween: Tween
var _instance_tween: Tween


func _init() -> void:
	_suspend_rect.color = Color.BLACK
	_suspend_rect.color.a = 0.75
	_suspend_rect.visible = false
	add_child(_suspend_rect)
	add_theme_constant_override("margin_left", 0)
	add_theme_constant_override("margin_right", 0)
	add_theme_constant_override("margin_up", 0)
	add_theme_constant_override("margin_down", 0)
	
	# This is done so we don't need to declare _ready
	# Making it available for UI needs
	ready.connect(_on_ready_internal, CONNECT_ONE_SHOT)


func _on_ready_internal() -> void:
	_animate_enter()


func set_stack(owning_stack: UISceneStack) -> void:
	_stack = owning_stack


func suspend(source: Object) -> void:
	if not source in _suspend_sources:
		_suspend_sources.append(source)
	
	var was_suspended: bool = _is_suspended
	
	if not _suspend_sources.is_empty():
		_is_suspended = true
	
	if not was_suspended and _is_suspended:
		_animate_suspended()
		var args: Array = [true]
		propagate_call("set_physics_process", args)
		propagate_call("set_process", args)
		propagate_call("set_process_input", args)
		propagate_call("set_process_shortcut_input", args)
		propagate_call("set_process_unhandled_input", args)
		propagate_call("set_process_unhandled_key_input", args)


func unsuspend(source: Object) -> void:
	if source in _suspend_sources:
		_suspend_sources.erase(source)
	
	var was_suspended: bool = _is_suspended
	
	if _suspend_sources.is_empty():
		_is_suspended = false
	
	if was_suspended and not _is_suspended:
		_animate_unsuspended()
		var args: Array = [false]
		propagate_call("set_physics_process", args)
		propagate_call("set_process", args)
		propagate_call("set_process_input", args)
		propagate_call("set_process_shortcut_input", args)
		propagate_call("set_process_unhandled_input", args)
		propagate_call("set_process_unhandled_key_input", args)


func free_scene(skip_animation: bool = false) -> void:
	if skip_animation:
		exit_animation_finished.emit()
		queue_free()
	else:
		var t: Tween = create_tween()
		t.tween_callback(_animate_exit.call_deferred)
		t.tween_await(exit_animation_finished)
		t.tween_callback(queue_free)


@abstract func _animate_enter() -> void
@abstract func _animate_exit() -> void
@abstract func _animate_suspended() -> void
@abstract func _animate_unsuspended() -> void


func _animate_enter_default() -> void:
	visible = true
	modulate.a = 0.0
	_instance_tween = TweenHelper.replace(self, _instance_tween)
	_instance_tween.tween_property(self, "modulate:a", 1.0, 0.33)
	_instance_tween.tween_callback(enter_animation_finished.emit)


func _animate_exit_default() -> void:
	visible = true
	_instance_tween = TweenHelper.replace(self, _instance_tween)
	_instance_tween.tween_property(self, "modulate:a", 0.0, 0.33)
	_instance_tween.tween_property(self, "visible", false, 0.0)
	_instance_tween.tween_callback(exit_animation_finished.emit)


func _animate_suspended_default() -> void:
	_suspend_rect.move_to_front()
	_suspend_tween = TweenHelper.replace(self, _suspend_tween)
	_suspend_rect.visible = true
	_suspend_tween.tween_property(_suspend_rect, "modulate:a", 1.0, 0.33)


func _animate_unsuspended_default() -> void:
	_suspend_rect.move_to_front()
	_suspend_tween = TweenHelper.replace(self, _suspend_tween)
	_suspend_tween.tween_property(_suspend_rect, "modulate:a", 0.0, 0.33)
	_suspend_tween.tween_property(_suspend_rect, "visible", false, 0.0)
