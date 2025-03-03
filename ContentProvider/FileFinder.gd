class_name FileFinder
extends RefCounted
## FileFinder
##
## Finds files matching the criteria within the project dir.


## directory = the absolute or relative to res:// dir to scan.
## extensions = extensions to include. ex ["tres", "tscn", "txt"]
## return value is an array of file paths, directory + filename, ["res://folder/file.ext"]
## This search is recursive. Be careful calling it on a deep folder structure.
## Directories starting with . are ignored.
static func find(directory: String, extensions: Array[String]) -> Array[String]:
	var dirs: PackedStringArray = DirAccess.get_directories_at(directory)
	var files: PackedStringArray = DirAccess.get_files_at(directory)
	
	var matching_files: Array[String] = []
	for file: String in files:
		if file.get_extension() in extensions:
			var file_path: String = directory.path_join(file)
			matching_files.append(file_path)
	
	for dir: String in dirs:
		# Skip navigation and "hidden" dirs.
		
		if dir[0] == ".":
			continue
		
		var dir_path: String = directory.path_join(dir)
		matching_files += find(dir_path, extensions)
	
	return matching_files
