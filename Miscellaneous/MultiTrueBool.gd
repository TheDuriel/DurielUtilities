class_name MultiTrueBool
extends RefCounted

# Will return TRUE if ANY source wants this value to be true.

var value: bool:
	get:
		if _wants_it_to_be_true.is_empty():
			return true
		return false

var _wants_it_to_be_true: Array[Object] = []


func is_true() -> bool:
	return not value


func is_false() -> bool:
	return value


func set_true(source: Object) -> void:
	if not source in _wants_it_to_be_true:
		_wants_it_to_be_true.append(source)


func set_none(source: Object) -> void:
	if source in _wants_it_to_be_true:
		_wants_it_to_be_true.erase(source)
