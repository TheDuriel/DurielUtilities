class_name TaskQueue
extends RefCounted

signal task_queued(task: Task)
signal task_readied(task: Task)
signal task_completed(task: Task)
signal task_failed(task: Task)
signal task_cancelled(task: Task)
signal queue_finished

var require_manual_flushing: bool = false

# For debugging, artifically slows the queue down.
var slow_mode: bool = false
var slow_mode_wait_time: float = 0.15

# True if the queue is working. Useful for blocking user input until its done.
var busy: bool:
	get: return _tasks.is_empty()

var _tree: SceneTree
var _tasks: Array[Task] = []


func _init(tree: SceneTree) -> void:
	_tree = tree


func flush_manually() -> void:
	if not require_manual_flushing:
		Logger.warn(self, flush_manually, "require_manual_flushing is not true")
		return
	
	_ready_tasks.call_deferred()


	# Add Task to the end of the queue
func put_task(task: Task) -> void:
	put_last(task)


	# Add Task to the start of the queue
func put_first(task: Task) -> void:
	_insert_task_at(task, 0)


	# Add Task to the end of the queue
func put_last(task: Task) -> void:
	_insert_task_at(task, _tasks.size())


	# Add Task before Task
func put_task_before(task: Task, before: Task) -> void:
	var index: int = 0
	for idx: int in _tasks.size():
		var value: Task = _tasks[idx]
		if value == before:
			index = int(max(idx - 1, 0))
			break
	_insert_task_at(task, index)


	# Add Task after Task
func put_task_after(task: Task, after: Task) -> void:
	var index: int = _tasks.size()
	for idx: int in _tasks.size():
		var value: Task = _tasks[idx]
		if value == after:
			index = int(min(idx + 1, _tasks.size()))
			break
	_insert_task_at(task, index)


func cancel_task(task: Task) -> void:
	if task in _tasks:
		_tasks.erase(task)
		task.cancel()
		task_cancelled.emit(task)


func _insert_task_at(task: Task, index: int) -> void:
	if task.is_unique():
		for t: Task in _tasks:
			if t.get_script() == task.get_script(): # Stupid
				return
	
	if index == _tasks.size():
		_tasks.append(task)
	else:
		_tasks.insert(index, task)
	
	task.readied.connect(_on_task_readied)
	task.completed.connect(_on_task_completed)
	task.failed.connect(_on_task_failed)
	
	if not require_manual_flushing:
		_ready_tasks.call_deferred()
	
	task_queued.emit(task)
	
	Logger.hint(self, _insert_task_at, Logger.get_object_file_name(task) + " - queue size: %s" % _tasks.size())


func _ready_tasks() -> void:
	if slow_mode:
		await _tree.create_timer(slow_mode_wait_time).timeout
	
	Logger.hint(self, _ready_tasks)
	if _tasks.is_empty():
		Logger.hint(self, _ready_tasks, "nothing to ready.")
		queue_finished.emit()
		return
	
	# All async tasks
	for t: Task in _tasks:
		if t.is_async() and t.state == Task.STATE.NONE:
			t.prepare.call_deferred()
	
	Logger.hint(self, _ready_tasks, "readying async.")
	
	# First task in list
	var first_task: Task = _tasks[0]
	
	Logger.hint(self, _ready_tasks, "First task is: %s" % Logger.get_object_file_name(first_task))
	
	if first_task.is_async():
		Logger.hint(self, _ready_tasks, "first task is async. Stopped")
		return
	
	if first_task.state <= Task.STATE.WAITING:
		first_task.prepare.call_deferred()
		Logger.hint(self, _ready_tasks, "readied first task.")
		return
	
	Logger.hint(self, _ready_tasks, "failed. First task is %s" % first_task.state)


func _on_task_readied(task: Task) -> void:
	if slow_mode:
		await _tree.create_timer(slow_mode_wait_time).timeout
	
	if task.is_async() or task == _tasks[0]:
		task.complete.call_deferred()
	
	task_readied.emit(task)


func _on_task_completed(task: Task) -> void:
	if slow_mode:
		await _tree.create_timer(slow_mode_wait_time).timeout
	
	_tasks.erase(task)
	
	_ready_tasks.call_deferred()
	
	task_completed.emit(task)


func _on_task_failed(task: Task) -> void:
	if slow_mode:
		await _tree.create_timer(slow_mode_wait_time).timeout
	
	_tasks.erase(task)
	
	_ready_tasks.call_deferred()
	
	task_failed.emit(task)
