class_name ResourceProvider
extends RefCounted

# NONE = Do not keep a reference to the resource.
# KEEP = Store a reference to the resource and keep it in memory after loading.
# PRELOAD = Preload all resources immediately and permanently keep them in memory.
enum CACHE_MODE {NONE, KEEP, PRELOAD}

const RES_PATH: String = "res://"
const DOT_PATH: String = "./"
const REMAP_EXTENSION: String = ".remap"

var _directory: String = ""
var _extensions: Array[String] = []
var _resources_paths: Dictionary[String, String] = {}
var _resources_instances: Dictionary[String, Resource] = {}
var _load_external: bool = false
var _cache_mode: CACHE_MODE = CACHE_MODE.NONE


func _init(directory: String, file_extensions: Array[String], load_external: bool = false, cache_mode: CACHE_MODE = CACHE_MODE.NONE) -> void:
	_directory = directory
	_extensions = file_extensions
	_load_external = load_external
	_cache_mode = cache_mode
	
	_load_resources_from_inside_pck()
	if _load_external:
		_load_resources_next_to_binary()


func _load_resources_from_inside_pck() -> void:
	var resource_paths: PackedStringArray = FileFinder.find(_directory, _extensions)
	for path: String in resource_paths:
		var resource_id: String = path.get_file().get_basename().to_lower()
		_resources_paths[resource_id] = path
		if _cache_mode == CACHE_MODE.PRELOAD:
			_resources_instances[resource_id] = load(path)


func _load_resources_next_to_binary() -> void:
	var external_dir: String = _directory.replace(RES_PATH, DOT_PATH)
	var resource_paths: PackedStringArray = FileFinder.find(external_dir, _extensions)
	for path: String in resource_paths:
		var resource_id: String = path.get_file().get_basename().to_lower()
		_resources_paths[resource_id] = path
		if _cache_mode == CACHE_MODE.PRELOAD:
			_resources_instances[resource_id] = load(path)


func has_resource(name: String) -> bool:
	name = name.to_lower()
	return name in _resources_paths


func get_resource(name: String) -> Resource:
	name = name.to_lower()
	assert(has_resource(name))
	
	if _resources_instances.has(name):
		return _resources_instances[name]
	
	var resource: Resource = load(_resources_paths[name])
	if _cache_mode == CACHE_MODE.KEEP:
		_resources_instances[name] = resource
	
	return resource


func get_count() -> int:
	return _resources_paths.size()


func get_names() -> Array[String]:
	return _resources_paths.keys()


static func remove_remap(file_path: String) -> String:
	if file_path.ends_with(REMAP_EXTENSION):
		return file_path.replace(REMAP_EXTENSION, "")
	return file_path
