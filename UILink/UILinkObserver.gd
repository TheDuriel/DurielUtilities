class_name UILinkObserver
extends Node

var _observer: Object
var _target: Control
var _observer_property: String
var _target_property: String


func _init(observer: Object, target_control: Control, property_id: String, observer_property_name: String) -> void:
	_observer = observer
	_target = target_control
	_target_property = property_id
	_observer_property = observer_property_name
	
	target_control.add_child(self)


func _process(_delta: float) -> void:
	if not _observer:
		queue_free()
		return
	if not _target:
		queue_free()
		return
	
	_observer[_observer_property] = _target[_target_property]
