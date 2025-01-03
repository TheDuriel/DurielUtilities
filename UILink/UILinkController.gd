class_name UILinkController
extends Node

var _controller: Object
var _target: Control
var _controller_property: String
var _target_property: String


func _init(controller: Object, target_control: Control, property_id: String, controller_property_name: String) -> void:
	_controller = controller
	_target = target_control
	_target_property = property_id
	_controller_property = controller_property_name
	
	target_control.add_child(self)


func _process(_delta: float) -> void:
	if not _controller:
		queue_free()
		return
	if not _target:
		queue_free()
		return
	
	_target[_target_property] = _controller[_controller_property]
