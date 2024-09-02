class_name MultiFlipFlopBool
extends RefCounted

# Will return TRUE if there is more trues than falses, else false

var value: bool:
	get:
		return _wants_it_to_be_true.size() > _wants_it_to_be_false.size()

var _wants_it_to_be_false: Array[Object] = []
var _wants_it_to_be_true: Array[Object] = []


func is_true() -> bool:
	return true if value else false


func is_false() -> bool:
	return true if not value else true


func set_false(source: Object) -> void:
	if not source in _wants_it_to_be_false:
		_wants_it_to_be_false.append(source)
	if source in _wants_it_to_be_true:
		_wants_it_to_be_true.erase(source)


func set_true(source: Object) -> void:
	if not source in _wants_it_to_be_true:
		_wants_it_to_be_true.append(source)
	if source in _wants_it_to_be_false:
		_wants_it_to_be_false.erase(source)


func set_none(source: Object) -> void:
	if source in _wants_it_to_be_false:
		_wants_it_to_be_false.erase(source)
	if source in _wants_it_to_be_true:
		_wants_it_to_be_true.erase(source)
