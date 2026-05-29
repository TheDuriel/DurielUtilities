class_name SimpleStateMachine
extends RefCounted

signal changed(old_state: SimpleState, new_state: SimpleState)

var scene_tree: SceneTree

var _previous_state: SimpleState = null
var active_state: SimpleState:
	get:
		return _active_state
var _active_state: SimpleState = SimpleStateNone.new()


## Implement this yourself with the correct respective type hint.
#func enter_state(new_state: SimpleState) -> void:
	#_enter_state(new_state)


func _enter_state_deferred(new_state: SimpleState) -> void:
	_enter_state.call_deferred(new_state)


func _enter_state(new_state: SimpleState) -> void:
	new_state.scene_tree = scene_tree
	
	if not _active_state.can_exit_to(new_state):
		DurielLogger.error_assert(self, _enter_state, "%s can't exit to %s" % [_active_state, new_state])
		return
	if not new_state.can_enter_from(_active_state):
		DurielLogger.error_assert(self, _enter_state, "%s can't be entered from %s" % [_active_state, new_state])
		return
	
	if _active_state:
		
		DurielLogger.confirm(self, _enter_state, "Exiting %s" % DurielLogger.get_object_file_name(_active_state))
		_active_state.exit.call_deferred(new_state)
		await _active_state.exited
		DurielLogger.confirm(self, _enter_state, "Exited")
		
		_previous_state = _active_state
	
	DurielLogger.confirm(self, _enter_state, "Entering %s" % DurielLogger.get_object_file_name(new_state))
	_active_state = new_state
	
	_active_state.enter.call_deferred(_previous_state)
	await _active_state.entered
	DurielLogger.confirm(self, _enter_state, "Entered")
	
	changed.emit(_previous_state, _active_state)


func pass_input(event: InputEvent) -> void:
	_active_state.pass_input(event)


func pass_process(delta: float) -> void:
	_active_state.pass_process(delta)


func pass_physics_process(delta: float) -> void:
	_active_state.pass_physics_process(delta)
