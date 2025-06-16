class_name UIGlue
extends RefCounted

## Example use:
#@export var my_button: Button:
	#set(value): my_button = UIGlue.glue_pressed(my_button, value, _on_button_pressed)


static func glue(old: Signal, new: Signal, target_func: Callable) -> void:
	if old and old.is_connected(target_func):
		old.disconnect(target_func)
	if new:
		new.connect(target_func)


static func glue_pressed(old: Button, new: Button, target_func: Callable) -> Button:
	glue(old.pressed, new.pressed, target_func)
	return new


static func glue_focus_entered(old: Control, new: Control, target_func: Callable) -> Control:
	glue(old.focus_entered, new.focus_entered, target_func)
	return new


static func glue_focus_exited(old: Control, new: Control, target_func: Callable) -> Control:
	glue(old.focus_exited, new.focus_exited, target_func)
	return new


static func glue_mouse_entered(old: Control, new: Control, target_func: Callable) -> Control:
	glue(old.mouse_entered, new.mouse_entered, target_func)
	return new


static func glue_mouse_exited(old: Control, new: Control, target_func: Callable) -> Control:
	glue(old.mouse_exited, new.mouse_exited, target_func)
	return new
