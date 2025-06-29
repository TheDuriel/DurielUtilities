class_name SubMenu
extends Control

signal opened # Before animations
signal opened_animated
signal closed # Before animations
signal closed_animated

@export var menu_name: String = "NONAME"
@export var _focus_target: Control:
	set(value): _focus_target = Glue.assert_value(value)


var open: bool = false:
	set(value):
		if open == value: return
		open = value
		visible = open
		if open:
			opened.emit()
			_focus_target.grab_click_focus()
			_focus_target.grab_focus()
			_animate_open()
		else:
			closed.emit()
			_animate_close()


func _init() -> void:
	visible = false


func _animate_open() -> void:
	opened_animated.emit.call_deferred()


func _animate_close() -> void:
	closed_animated.emit.call_deferred()
