class_name MultiFlipFlopBool
extends RefCounted
# Will return TRUE if there is more trues than falses, else false
# Defaults to false

signal became_true
signal became_false

var _true_setters: Array[Object] = []
var _false_setters: Array[Object] = []

var _cached_value: bool = false


func is_true() -> bool:
	return true if _cached_value else false


func is_false() -> bool:
	return false if _cached_value else true


func set_false(source: Object) -> void:
	if not source in _false_setters:
		_false_setters.append(source)
	if source in _true_setters:
		_true_setters.erase(source)


func set_true(source: Object) -> void:
	if not source in _true_setters:
		_true_setters.append(source)
	if source in _false_setters:
		_false_setters.erase(source)


func set_none(source: Object) -> void:
	if source in _false_setters:
		_false_setters.erase(source)
	if source in _true_setters:
		_true_setters.erase(source)

func _update() -> void:
	var old_value: bool = _cached_value
	var new_value: bool = false
	if _true_setters.size() > _false_setters.size():
		new_value = true
	
	if old_value == new_value:
		return
	
	_cached_value = new_value
	
	if _cached_value:
		became_true.emit()
	else:
		became_false.emit()
