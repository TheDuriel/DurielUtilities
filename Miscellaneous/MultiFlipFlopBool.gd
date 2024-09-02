class_name MultiFlipFlopBool
extends RefCounted

# Will return TRUE if there is more trues than falses, else false

var value: bool:
	get:
		var t: int = 0
		var f: int = 0
		
		for v: bool in _values.values():
			if v: t += 1
			else: f += 1
		
		return t > f

var _values: Dictionary = {} # source : value


func set_false(source: Object) -> void:
	_values[source] = false


func set_true(source: Object) -> void:
	_values[source] = true


func set_none(source: Object) -> void:
	_values.erase(source)
