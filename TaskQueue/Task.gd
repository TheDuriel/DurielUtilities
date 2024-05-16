class_name Task
extends RefCounted

signal readied(task: Task)
signal completed(task: Task)
signal failed(task: Task)

enum STATE {NONE, WAITING, READY, COMPLETED, FAILED}
var state: int:
	get: return _state
var _state: int = STATE.NONE
var _async: bool = false
var _unique: bool = false


## Override This
#func _init() -> void:
	#pass


## Override This
func _prepare() -> void:
	goto_ready() #Or if we're waiting, goto_waiting()


## Override This
func _complete() -> void:
	goto_completed()


## Override This
func _cancel() -> void:
	goto_failed()


func prepare() -> void:
	_prepare()


func complete() -> void:
	_complete()


func cancel() -> void:
	_cancel()


func is_async() -> bool:
	return _async


func is_unique() -> bool:
	return _unique


func set_state(new_state: int) -> void:
	var old_state: int = _state
	
	if old_state == new_state:
		return
	
	match new_state:
		STATE.NONE:
			pass
		STATE.WAITING:
			_state = STATE.WAITING
			Logger.hint(self, set_state, "waiting")
		STATE.READY:
			_state = STATE.READY
			Logger.hint(self, set_state, "ready")
			readied.emit(self)
		STATE.COMPLETED:
			_state = STATE.COMPLETED
			Logger.hint(self, set_state, "completed")
			completed.emit(self)
		STATE.FAILED:
			_state = STATE.FAILED
			Logger.hint(self, set_state, "failed")
			failed.emit(self)


func goto_waiting() -> void: set_state(STATE.WAITING)
func goto_ready() -> void: set_state(STATE.READY)
func goto_completed() -> void: set_state(STATE.COMPLETED)
func goto_failed() -> void: set_state(STATE.FAILED)

func is_waiting() -> bool: return _state == STATE.WAITING
func is_ready() -> bool: return _state == STATE.READY
func was_ready() -> bool: return _state > STATE.READY
func is_completed() -> bool: return _state == STATE.COMPLETED
func is_failed() -> bool: return _state == STATE.FAILED
