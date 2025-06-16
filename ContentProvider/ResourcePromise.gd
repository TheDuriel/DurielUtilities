class_name ResourcePromise
extends RefCounted

signal loading_finished(status: STATUS)

enum STATUS {NONE, OK, FAILED}

var status: STATUS:
	get:
		if _status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			return STATUS.OK
		if _status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
			return STATUS.FAILED
		return STATUS.NONE

var _status: ResourceLoader.ThreadLoadStatus = ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS
var resource: Resource
var resource_path: String
var resource_id: String


func _init(id: String, path: String, perform_load: bool = true, use_sub_threads: bool = false) -> void:
	resource_id = id
	resource_path = path
	
	# Used when no threaded loading is actually required.
	if not perform_load:
		return
	
	ResourceLoader.load_threaded_request(resource_path, "", use_sub_threads)
	Engine.get_main_loop().process_frame.connect(_on_process_frame)


func _on_process_frame() -> void:
	_status = ResourceLoader.load_threaded_get_status(resource_path)
	
	var stop: bool = true
	
	match _status:
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
			Logger.error(self, _on_process_frame, "Resource %s does not exist." % resource_path)
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
			stop = false
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
			Logger.error(self, _on_process_frame, "Resource %s failed to load." % resource_path)
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			resource = ResourceLoader.load_threaded_get(resource_path)
	
	if stop:
		Engine.get_main_loop().process_frame.disconnect(_on_process_frame)
		loading_finished.emit(status)
