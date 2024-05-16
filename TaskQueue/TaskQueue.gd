class_name TaskQueue
extends RefCounted

var busy: bool:
	get: return not _tasks.is_empty()

var _tasks: Array[Task] = []


func put_first(task: Task) -> void:
	_tasks.insert(0, task)
	_flush.call_deferred()


func put_last(task: Task) -> void:
	_tasks.append(task)
	_flush.call_deferred()


func put_before(task: Task, target: Task) -> void:
	if not target in _tasks:
		put_last(task)
		return
	
	var index: int = _tasks.find(target)
	if index >= _tasks.size() - 1:
		put_last(task)
		return
	if index < 1:
		put_first(task)
		return
	
	_tasks.insert(index - 1, task)
	_flush.call_deferred()


func put_after(task: Task, target: Task) -> void:
	if not target in _tasks:
		put_last(task)
		return
	
	var index: int = _tasks.find(target)
	if index >=_tasks.size() - 1:
		put_last(task)
		return
	
	_tasks.insert(index + 1, task)
	_flush.call_deferred()


func _on_task_state_changed(task: Task, state: Task.STATE) -> void:
	match state:
		Task.STATE.FAILED:
			_tasks.erase(task)
		Task.STATE.DONE:
			_tasks.erase(task)
	
	_flush.call_deferred()


func _flush() -> void:
	if _tasks.is_empty():
		return
	
	var first_task: Task = _tasks[0]
	match first_task.state:
		Task.STATE.NONE:
			first_task.ready()
		Task.STATE.WAITING:
			first_task.ready()
	
	if first_task.is_ready():
		first_task.execute.call_deferred()
