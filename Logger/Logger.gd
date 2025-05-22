class_name Logger
extends RefCounted
## Static Logger
##
## Provides pretty print logging in a static fashion.


const APP_CONFIG: LoggerConfig = preload("res://Config/logger_config.tres")


## Confirms are green. A confirm informs you a function was called, and was successful.
@warning_ignore("untyped_declaration")
static func confirm(emitter: Object, function: Callable, message = "") -> void:
	var do_log: bool = true
	if APP_CONFIG:
		do_log = APP_CONFIG.log_confirms
	
	if not do_log:
		return
	
	var msg: String = _get_message(emitter, function, str(message))
	var string: String = "[color=green]%s[/color]" % msg
	print_rich(string)


## Hints are grey. A hint informs you a function was called, but not if it completed.
@warning_ignore("untyped_declaration")
static func hint(emitter: Object, function: Callable, message = "") -> void:
	var do_log: bool = true
	if APP_CONFIG:
		do_log = APP_CONFIG.log_hints
	
	if not do_log:
		return
	
	var msg: String = _get_message(emitter, function, str(message))
	var string: String = "[color=gray]%s[/color]" % msg
	print_rich(string)


## Warnings are yellow. A warning indicates execution continued despite a problem.
@warning_ignore("untyped_declaration")
static func warn(emitter: Object, function: Callable, message = "") -> void:
	var do_log: bool = true
	if APP_CONFIG:
		do_log = APP_CONFIG.log_warnings
	
	if not do_log:
		return
	
	var msg: String = _get_message(emitter, function, str(message))
	var string: String = "[color=yellow]%s[/color]" % msg
	print_rich(string)


## Errors are red. An error indicates that execution was stopped.
@warning_ignore("untyped_declaration")
static func error(emitter: Object, function: Callable, message = "") -> void:
	var do_log: bool = true
	if APP_CONFIG:
		do_log = APP_CONFIG.log_errors
	
	if not do_log:
		return
	
	var msg: String = _get_message(emitter, function, str(message))
	var string: String = "[color=red]%s[/color]" % msg
	print_rich(string)
	
	if APP_CONFIG and APP_CONFIG.assert_errors:
		# Read the error and follow the stack trace to find your problem!
		assert(false)


static func _get_message(emitter: Object, function: Callable, message: String = "") -> String:
	var obj_name: String = emitter.get_class()
	if emitter.get_script():
		var s: Script = emitter.get_script()
		if s:
			obj_name = s.get_path().get_file()
	var func_name: String = function.get_method()
	
	var rs: String = ""
	if obj_name:
		rs = "%s" % obj_name
	if func_name:
		rs = rs + " - %s" % func_name
	if message:
		rs = rs + " - %s" % message
	
	return rs


static func get_object_file_name(object: Object) -> String:
	var s: Script = object.get_script()
	
	if s:
		return s.resource_path.get_file()
	
	return object.get_class()
