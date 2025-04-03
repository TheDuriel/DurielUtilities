class_name MultiTrueBool
extends RefCounted

# Will return TRUE if ANY source wants this value to be true.
# Otherwise will return false
signal became_true
signal became_false


var _setting_objects: Array[Object] = []:
	set(value):
		var old_was_empty: bool = _setting_objects.is_empty()
		var new_is_empty: bool = value.is_empty()
		_setting_objects = value
		
		if old_was_empty and not new_is_empty:
			_cached_value = true
			became_true.emit()
		
		if not old_was_empty and new_is_empty:
			_cached_value = false
			became_false.emit()

var _cached_value: bool = false


func is_true() -> bool:
	return _cached_value


func is_false() -> bool:
	return not _cached_value


func set_true(source: Object) -> void:
	if not source in _setting_objects:
		_setting_objects.append(source)


func set_none(source: Object) -> void:
	if source in _setting_objects:
		_setting_objects.erase(source)
