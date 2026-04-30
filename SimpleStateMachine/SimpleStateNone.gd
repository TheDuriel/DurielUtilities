class_name SimpleStateNone
extends SimpleState


func _can_enter_from(_active_state: SimpleState) -> bool:
	return true


func _can_exit_to(_new_state: SimpleState) -> bool:
	return true


func _enter(_previous_state: SimpleState) -> void:
	emit_entered()


func _exit(_new_state: SimpleState) -> void:
	emit_exited()
