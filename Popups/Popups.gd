class_name Popups
extends MarginContainer
## Generic Popup Handler
##
## An assumption is made that popups should be centered.
## You can edit the layout here.
##
## Usage example:
## Configure your popup
#var request: PopupRequestBinary = PopupRequestBinary.new()
## Optional Overrides
#request.header_label = "U sure?"
#request.yes_label = "Yeah"
#request.no_label = "Nah"
## Display it
#Interface.popups.request_popup(request)
## Wait for result and parse it.
## You should probably connect this to a function rather than awaiting.
#await request.closed
## Handle result.
#print(request.result)

signal input_blocker_pressed

const INPUT_BLOCKER_COLOR: Color = Color(0.0, 0.0, 0.0, 0.15)

var _input_blocker: ColorRect
var _popup_container: CenterContainer

var _current_popup: BasePopup

var _block_input: bool:
	set(value):
		if _input_blocker:
			_input_blocker.visible = value


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	_input_blocker = ColorRect.new()
	_input_blocker.mouse_filter = Control.MOUSE_FILTER_STOP
	_input_blocker.name = "InputBlocker"
	_input_blocker.color = INPUT_BLOCKER_COLOR
	_input_blocker.visible = false
	_input_blocker.gui_input.connect(_on_input_blocker_gui_input)
	add_child(_input_blocker)
	
	_popup_container = CenterContainer.new()
	_popup_container.name = "PopupContainer"
	_popup_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_popup_container)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func request_popup(request: PopupRequest) -> void:
	if _current_popup:
		Logger.error(self, request_popup, "There already is a popup.")
		return
	if not request.popup_scene:
		Logger.error(self, request_popup, "Request lacks packed scene.")
		return
	
	var popup: BasePopup = request.popup_scene.instantiate()
	popup.configure(self, request)
	request.closed.connect(_on_popup_closed)
	
	_popup_container.add_child(popup)
	
	_current_popup = popup
	_block_input = true


func _on_popup_closed() -> void:
	_current_popup = null
	_block_input = false


func _on_input_blocker_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		input_blocker_pressed.emit()
