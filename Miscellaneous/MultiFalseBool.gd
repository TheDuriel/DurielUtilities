class_name MultiFalseBool
extends RefCounted

# Will return FALSE if ANY source wants this value to be false.
# Otherwise will return true
signal became_true
signal became_false


var _setting_objects: Array[Object] = []:
	set(value):
		var old_was_empty: bool = _setting_objects.is_empty()
		var new_is_empty: bool = value.is_empty()
		_setting_objects = value
		
		if old_was_empty and not new_is_empty:
			_cached_value = false
			became_false.emit()
		
		if not old_was_empty and new_is_empty:
			_cached_value = true
			became_true.emit()

var _cached_value: bool = true


func is_true() -> bool:
	return _cached_value


func is_false() -> bool:
	return not _cached_value


func set_false(source: Object) -> void:
	if not source in _setting_objects:
		_setting_objects.append(source)


func set_none(source: Object) -> void:
	if source in _setting_objects:
		_setting_objects.erase(source)
