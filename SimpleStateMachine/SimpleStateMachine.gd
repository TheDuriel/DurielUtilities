class_name SimpleStateMachine
extends RefCounted

signal changed(old_state: SimpleState, new_state: SimpleState)

var tree: SceneTree

var _previous_state: SimpleState = null
var active_state: SimpleState:
	get:
		return _active_state
var _active_state: SimpleState = SimpleStateNone.new()


## Implement this yourself with the correct respective type hint.
#func enter_state(new_state: SimpleState) -> void:
	#_enter_state(new_state)


func _enter_state(new_state: SimpleState) -> void:
	if not _active_state.can_exit_to(new_state):
		Logger.error(self, _enter_state, "Current state can't exit to new state.")
		return
	if not new_state.can_enter_from(_active_state):
		Logger.error(self, _enter_state, "New state can't enter from current state.")
		return
	
	if _active_state:
		
		Logger.confirm(self, _enter_state, "Exiting %s" % Logger.get_object_file_name(_active_state))
		_active_state.exit.call_deferred(new_state)
		await _active_state.exited
		Logger.confirm(self, _enter_state, "Exited")
		
		_previous_state = _active_state
	
	Logger.confirm(self, _enter_state, "Entering %s" % Logger.get_object_file_name(new_state))
	_active_state = new_state
	_active_state.scene_tree = tree
	
	_active_state.enter.call_deferred(_previous_state)
	await _active_state.entered
	Logger.confirm(self, _enter_state, "Entered")
	
	changed.emit(_previous_state, _active_state)
