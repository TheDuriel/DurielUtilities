class_name PopupRequestBinary
extends PopupRequest

enum RESULT {NONE, YES, NO}
var result: RESULT

var header_label: String = "Accept?"
var yes_label: String = "Yes"
var no_label: String = "No"


func _get_popup_scene() -> PackedScene:
	return preload("uid://qhh3itgspxf0")


func close(_result: RESULT) -> void:
	result = _result
	closed.emit()
