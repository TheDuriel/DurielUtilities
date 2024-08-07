class_name BasePopup
extends PanelContainer

@warning_ignore("unused_signal")
signal closed

## Override me.
## These warnings are ignored here.
## You should statically type the override.
@warning_ignore("untyped_declaration", "unused_parameter")
func set_config(value) -> void:
	Logger.warn(self, set_config, "You didn't override this.")
