class_name MultiTrueBool
extends RefCounted

# Will return TRUE if ANY source wants this value to be true.

var value: bool:
	get:
		for v: bool in _values.values():
			if v:
				return true
		return false

var _values: Dictionary = {} # source : value


func is_true() -> bool:
	return true if value else false


func is_false() -> bool:
	return true if not value else true


func set_false(source: Object) -> void:
	_values[source] = false


func set_true(source: Object) -> void:
	_values[source] = true


func set_none(source: Object) -> void:
	_values.erase(source)
