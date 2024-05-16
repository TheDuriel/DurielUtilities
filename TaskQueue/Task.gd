class_name Task
extends RefCounted

signal state_changed(task: Task, state: STATE)

enum STATE {NONE, FAILED, WAITING, READY, DONE}
var state: STATE:
	get: return _state
var _state: STATE = STATE.NONE:
	set(value):
		_state = value
		state_changed.emit(self, _state)


## Override this.
#func _init() -> void:

	#pass

## Override this.
func _prepare() -> void:
	_ready()


## Override this.
func _execute() -> void:
	_done()


func prepare() -> void:
	_prepare()


func execute() -> void:
	_execute()


func _fail() -> void: _state = STATE.FAILED
func _wait() -> void: _state = STATE.WAITING
func _ready() -> void: _state = STATE.READY
func _done() -> void: _state = STATE.DONE

func is_failed() -> bool: return state == STATE.FAILED
func is_waiting() -> bool: return state == STATE.WAITING
func is_ready() -> bool: return state == STATE.READY
func is_done() -> bool: return state == STATE.DONE
