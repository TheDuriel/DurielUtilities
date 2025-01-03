class_name UILinkObserver
extends Node
# Use UILink.observe() to create this.

var _observer: WeakRef
var _target: Control
var _observer_property: String
var _target_property: String


func _init(observer: Object, target_control: Control, property_id: String, observer_property_name: String) -> void:
	_observer = weakref(observer)
	_target = target_control
	_target_property = property_id
	_observer_property = observer_property_name
	
	target_control.add_child(self)


func _process(_delta: float) -> void:
	if not _observer.get_ref():
		queue_free()
		return
	if not _target:
		queue_free()
		return
	
	_observer.get_ref()[_observer_property] = _target[_target_property]
