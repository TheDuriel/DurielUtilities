class_name SimpleStateMachine
extends RefCounted

signal changed(old_state: SimpleState, new_state: SimpleState)

var _previous_state: SimpleState
var active_state: SimpleState:
	get:
		return _active_state
var _active_state: SimpleState = SimpleStateNone.new()


func enter_state(new_state: SimpleState) -> void:
	if _active_state.can_exit_to(new_state) and new_state.can_enter_from(_active_state):
		_change_state(new_state)
		changed.emit(_previous_state, _active_state)


func _change_state(new_state: SimpleState) -> void:
	if _active_state:
		
		Logger.confirm(self, enter_state, "Exiting %s" % Logger.get_object_file_name(_active_state))
		_active_state.exit.call_deferred(new_state)
		await _active_state.exited
		Logger.confirm(self, enter_state, "Exited")
		
		_previous_state = _active_state
		
	else:
		_previous_state = null
	
	Logger.confirm(self, enter_state, "Entering %s" % Logger.get_object_file_name(new_state))
	_active_state = new_state
	_active_state.scene_tree = Simple.get_tree()
	
	_active_state.enter.call_deferred(_previous_state)
	await _active_state.entered
	Logger.confirm(self, enter_state, "Entered")
