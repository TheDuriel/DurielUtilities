class_name ResourceProvider
extends RefCounted

const RES_PATH: String = "res://"
const DOT_PATH: String = "./"
const REMAP_EXTENSION: String = ".remap"

var _directory: String = ""
var _extensions: Array[String] = []
var _resources: Dictionary = {}
var _load_external: bool = false


func _init(directory: String, file_extensions: Array[String], load_external: bool = false) -> void:
	_directory = directory
	_extensions = file_extensions
	_load_external = load_external
	_load_resources_from_inside_pck()
	if _load_external:
		_load_resources_next_to_binary()


func _load_resources_from_inside_pck() -> void:
	var files_in_dir: PackedStringArray = FileFinder.find(_directory, _extensions)
	var new_resources: Dictionary = {}
	for file: String in files_in_dir:
		new_resources[file.get_file().get_basename()] = load(file)
	
	for res: String in new_resources:
		_resources[res] = new_resources[res]


func _load_resources_next_to_binary() -> void:
	var external_dir: String = _directory.replace(RES_PATH, DOT_PATH)
	var files_in_dir: PackedStringArray = FileFinder.find(external_dir, _extensions)
	var new_resources: Dictionary = {}
	for file: String in files_in_dir:
		new_resources[file.get_file().get_basename()] = load(file)
	
	for res: String in new_resources:
		_resources[res] = new_resources[res]


func has_resource(name: String) -> bool:
	return name in _resources


func get_resource(name: String) -> Resource:
	assert(has_resource(name))
	return _resources[name]


func get_count() -> int:
	return _resources.size()


static func remove_remap(file_path: String) -> String:
	if file_path.ends_with(REMAP_EXTENSION):
		return file_path.replace(REMAP_EXTENSION, "")
	return file_path
