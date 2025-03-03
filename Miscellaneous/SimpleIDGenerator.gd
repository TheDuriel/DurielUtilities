@tool
class_name SimpleIDGenerator
extends RefCounted
## SimpleIDGenerator
##
## Generates a near guaranteed to be unique string


static func get_id() -> String:
	return naive_sha1()


static func naive_sha256() -> String:
	# Naively creates a Sha256 from unix time - running ticks
	# Should really never repeat. And if you do run into a conflict, replace this.
	# NOT FOR CRYPTOGRAPHY. This is just to have non repeating IDs.
	
	var ticks: int = Time.get_ticks_usec()
	var unix: float = Time.get_unix_time_from_system()
	var unix_int: int = int(unix)
	var hash_input: String = str(unix_int - ticks)
	var sha256_text: String = hash_input.sha256_text()
	return sha256_text


static func naive_sha1() -> String:
	# Naively creates a Sha1 from unix time - running ticks
	# Should really never repeat. And if you do run into a conflict, replace this.
	# NOT FOR CRYPTOGRAPHY. This is just to have non repeating IDs.
	
	var ticks: int = Time.get_ticks_usec()
	var unix: float = Time.get_unix_time_from_system()
	var unix_int: int = int(unix)
	var hash_input: String = str(unix_int - ticks)
	var sha1_text: String = hash_input.sha1_text()
	return sha1_text
