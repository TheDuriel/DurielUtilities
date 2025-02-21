class_name MultiFalseBool
extends RefCounted

# Will return FALSE if ANY source wants this value to be false.

var value: bool:
	get:
		if _wants_it_to_be_false.is_empty():
			return false
		return true

var _wants_it_to_be_false: Array[Object] = []


func is_true() -> bool:
	return value


func is_false() -> bool:
	return not value


func set_false(source: Object) -> void:
	if not source in _wants_it_to_be_false:
		_wants_it_to_be_false.append(source)


func set_none(source: Object) -> void:
	if source in _wants_it_to_be_false:
		_wants_it_to_be_false.erase(source)
