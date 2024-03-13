class_name iPopupBinary
extends BasePopup

@export var header_label: Label
@export var yes_button: Button
@export var no_button: Button

var _request: PopupRequestBinary: # For proper typing.
	get: return request


func _ready() -> void:
	header_label.text = _request.header_label
	yes_button.text = _request.yes_label
	no_button.text = _request.no_label
	
	yes_button.pressed.connect(_on_yes_pressed)
	no_button.pressed.connect(_on_no_pressed)
	popups.input_blocker_pressed.connect(_on_input_blocker_pressed)



func _on_yes_pressed() -> void:
	_finish_with_result(PopupRequestBinary.RESULT.YES)


func _on_no_pressed() -> void:
	_finish_with_result(PopupRequestBinary.RESULT.NO)


func _on_input_blocker_pressed() -> void:
	_finish_with_result(PopupRequestBinary.RESULT.NONE)


func _finish_with_result(result: PopupRequestBinary.RESULT) -> void:
	visible = false
	queue_free()
	_request.close(result)
