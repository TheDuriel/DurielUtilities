class_name BasePopup
extends PanelContainer

var popups: Popups
var request: PopupRequest


func configure(_popups: Popups, _request: PopupRequest) -> void:
	popups = _popups
	request = _request
