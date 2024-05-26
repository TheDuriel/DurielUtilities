class_name Popups
extends MarginContainer
# Generic Popup Handler
# Manages a stack of dependant popups

var _input_blocker: ColorRect
var _input_blocker_enabled: bool = false:
	set(value):
		if _input_blocker_enabled == value:
			return
		_input_blocker_enabled = value
		if _input_blocker:
			_input_blocker.visible = value
var _center_container: CenterContainer

var _stack: Array[BasePopup] = []

var active_popup: BasePopup:
	get:
		if _stack.is_empty():
			return null
		return _stack[0]


func _init() -> void:
	add_theme_constant_override("margin_top", 0)
	add_theme_constant_override("margin_left", 0)
	add_theme_constant_override("margin_bottom", 0)
	add_theme_constant_override("margin_right", 0)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	_input_blocker = ColorRect.new()
	_input_blocker.color = Color(0.0, 0.0, 0.0, 0.5)
	_input_blocker.visible = false
	_input_blocker.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_input_blocker)
	
	_center_container = CenterContainer.new()
	_center_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_center_container)


## Pushes a new popup to the stack and displays it
## Returns a new config, which holds the created scene and signal for handling
## The popup through
func push(popup_config: PopupConfiguration) -> BasePopup:
	
	var scene: BasePopup = popup_config.scene.instantiate()
	scene.set_config(popup_config)
	scene.closed.connect(_on_popup_closed.bind(scene))
	_stack.append(scene)
	_center_container.add_child(scene)
	
	_refresh()
	
	return scene


func _on_popup_closed(scene: Control) -> void:
	_stack.erase(scene)
	scene.queue_free()
	_refresh()


func _refresh() -> void:
	if _stack.is_empty():
		visible = false
		return
	
	visible = true
	
	for popup: BasePopup in _stack:
		popup.visible = false
	
	_stack[-1].visible = true
