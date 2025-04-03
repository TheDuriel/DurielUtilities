class_name MultiTrueBool
extends RefCounted

# Will return TRUE if ANY source wants this value to be true.
# Otherwise will return false
signal became_true
signal became_false


var _setting_objects: Array[Object] = []
var _cached_value: bool = false


func is_true() -> bool:
	return true if _cached_value else false


func is_false() -> bool:
	return false if _cached_value else true


func set_true(source: Object) -> void:
	if not source in _setting_objects:
		_setting_objects.append(source)
		_update()


func set_none(source: Object) -> void:
	if source in _setting_objects:
		_setting_objects.erase(source)
		_update()


func _update() -> void:
	var old_value: bool = _cached_value
	var new_value: bool = false
	
	if not _setting_objects.is_empty():
		new_value = true
	
	if old_value == false and new_value == true:
		_cached_value = true
		became_true.emit()
	
	elif old_value == true and new_value == false:
		_cached_value = false
		became_false.emit()
