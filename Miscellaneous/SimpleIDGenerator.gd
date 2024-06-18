class_name SimpleIDGenerator
extends RefCounted
## SimpleIDGenerator
##
## Generates a near guaranteed to be unique string

static func get_id() -> String:
	# Naively creates a Sha256 from unix time - running ticks
	# Should really never repeat. And if you do run into a conflict, replace this.
	# Yes I know this isn't the right way to do it. But it works.
	
	var ticks: int = Time.get_ticks_usec()
	var unix: float = Time.get_unix_time_from_system()
	var unix_int: int = int(unix)
	var hash_input: String = str(unix_int - ticks)
	var sha256_text: String = hash_input.sha256_text()
	return sha256_text
